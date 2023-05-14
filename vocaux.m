%Nomenclature des variables.
%t_   : Temps/Durée Temporelle [s]
%n_   : Échantillon/Durée numérique
%f_   : Fréquence        [Hz]
%c_   : Compte
%k_   : Compteur de boucle
%au_  : Audio            (n_audio,       c_canal)
%cv_  : Produit scalaire (n_covariance,  c_canal)
%cr_  : Correlation      (n_correlation, c_canal)
%nm_  : Normes           (n_normes,      c_canal)
%tx_  : Texte            (c_texte)
%cl_  : Cellule          (y_cellule,     x_cellule)
%rg_  : Range            (c_range)
%p_   : Décalages        (n_covariance)
%r_   : Rapport          [0, 1]

%Paramètres
%Reconstruction
t_block = 1.06 %Durée d'un bloc de reconstruction. (secondes)
%r_block      %Taux de recouvrement (pourcents).

%Recherche de la position globale.
c_block2 = 12; % t_block2/t_block: Nombre de blocs de reconstruction (block)
                 % dans un bloc de recherche de positions (block2).
t_block2 = c_block2 * t_block % Durée d'un bloc de recherche de position.
                              % recherge de position pour réglage fin.
t_block3 = .023;
c_block3 = floor(t_block/t_block3);
t_block3 = t_block/c_block3
c_block3 = int32(c_block3);

t_tail   = t_block/2          % Durée de la queue avant et après un bloc de

"Vocaux"
"Récupération des sources"
[au_instru, au_full, f_samplerate] = oli_load_tracks(tx_title);

"Initialisation"
n_block  = int32(floor(f_samplerate * t_block));
n_block2 = c_block2 * n_block;
n_block3 = n_block/c_block3
n_hop    = floor(n_block/2);
n_tail   = int32(floor(f_samplerate * t_tail));

[n_instru, c_instru] = size(au_instru);
[n_full,   c_full]   = size(au_full);

%Initialisation du flux audio
au_vox = zeros(n_full, c_full);

%"Calcul des normes"
%norms_instru_mp = oli_norms_mp(au_instru(:,1), n_block);

"Calcul des normes des petits blocs."
[nm_full_block,   rg_full_block]   = oli_block_norm(au_full,   n_block3);
[nm_instru_block, rg_instru_block] = oli_block_norm(au_instru, n_block3);

b_last_block = false;
%Calcul d'un bloc de recherche de positions (block2).
for k_block2 = 0:n_block2:(n_full-1)
    %On trouve le meilleur extrait a soustraire.
    if(k_block2 + n_block2 > n_full)
        disp("Dernier bloc.")
        n_block2 = n_full - k_block2;
    end

    au_full(k_block2+[1,n_block2],:);
    n_block32 = floor(n_block2/n_block3); 
    rg_nm_full = k_block2/n_block3  + (1: n_block32); %TODO FLOOR OU CEIL???
    p_max_nm_block2_instru = oli_cancel_parameters(nm_full_block,...
                                  nm_instru_block,...
                                  rg_nm_full(1),...
                                  n_block32);
    disp(-p_max_nm_block2_instru*t_block3);
    p2 = p_max_nm_block2_instru * n_block2/n_block3;


    %Calcul d'un bloc de reconstruction (block).
    for k_block = k_block2 + (0:n_hop:(n_block*(c_block2)-1))
        %Calcul de la covacovariance
        %p_corr: (-ny+1 : n_x-1)
        % k = p_corr + N_y - 1
        if(k_block + n_block > n_full)
            disp("Dernier bloc.")
            b_last_block = true;
            n_block = n_full - k_block;
        end
        rg_block = k_block + (1:n_block);
        au_block = au_full(rg_block, :);
        rg_instru2_low = ...
           1 + max(0,k_block - n_tail - p2);
        n_instru2 = (n_block + 2*n_tail);
        rg_instru2 = ...
           (0:(n_instru2-1)) + min(rg_instru2_low, n_instru-n_instru2 + 1);

        au_instru2 = au_instru(rg_instru2,:);

        %Ajout du bloc au flux.
        r_window = ones(n_block,1);
        if(!b_last_block)
            if(0 != k_block)
                r_window(1:n_hop) = (1:n_hop)/n_hop;
            end
            r_window(n_hop+1:n_block) = (n_block-n_hop:-1:1)/n_hop;
        else
            r_window(1:n_block) = (1:n_block)/n_hop;
        end
        au_vox(rg_block, :) += r_window .* oli_subtract_block(au_block, au_instru2);
        if(b_last_block)
            break;
        end
    end
end
%Écriture du fichier.
oli_save_track(au_vox, f_samplerate, tx_title);
%Écriture du ficher statistique.
disp("Fin")

%%BOUCLE1
%On va analyser un bloc de quelques secondes, et on regarde où il se trouve.
%block3: normes: quelques millisecondes
%block2: bloc de reconstruction. moins de trois secondes
%block1: bloc de recherche de position. quelques secondes

%%BOUCLE2
%%FIN BOUCLE2

%%FIN BOUCLE1
