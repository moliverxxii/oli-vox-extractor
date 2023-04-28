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
t_block = 2   %Durée d'un bloc de reconstruction. (secondes)
%r_block      %Taux de recouvrement (pourcents).

%Recherche de la position globale.
c_block2 = 5; % t_block2/t_block: Nombre de blocs de reconstruction (block)
                 % dans un bloc de recherche de positions (block2).
t_block2 = c_block2 * t_block % Durée d'un bloc de recherche de position.
t_tail   = t_block/4          % Durée de la queue avant et après un bloc de
                              % recherge de position pour réglage fin.
c_block3 = 400;
t_block3 = t_block/c_block3;

"Vocaux"
"Récupération des sources"
[au_instru, au_full, f_samplerate] = oli_load_tracks(tx_title);

"Initialisation"
n_block  = floor(f_samplerate * t_block);
n_block2 = c_block2 * n_block;
n_block3 = n_block/c_block3
n_tail   = floor(f_samplerate * t_tail);

[n_instru, c_instru] = size(au_instru);
[n_full,   c_full]   = size(au_full);

%Initialisation du flux audio
au_vox = zeros(n_full,c_full);

%"Calcul des normes"
%norms_instru_mp = oli_norms_mp(au_instru(:,1), n_block);

"Calcul des normes des petits blocs."
[nm_full_block,   rg_full_block]   = oli_block_norm(au_full,   n_block3);
[nm_instru_block, rg_instru_block] = oli_block_norm(au_instru, n_block3);

tm_init      = time;
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
    rg_nm_full = k_block2/n_block3  + [1: n_block32]; %TODO FLOOR OU CEIL???
    %TODO ICI trouver la valeur n_x_start
    p_max_nm_block2_instru = oli_cancel_parameters(nm_full_block,...
                                  nm_instru_block,...
				  rg_nm_full(1),...
				  n_block32);
    disp(-p_max_nm_block2_instru*t_block3);

				  

    %au_instru2 = au_instru(rg_instru2,:);

    %Calcul d'un bloc de reconstruction (block).
    for k_block = k_block2 + n_block*(0:c_block2 - 1)
        %Calcul de la covacovariance
        %p_corr: (-ny+1 : n_x-1)
        % k = p_corr + N_y - 1
	if(k_block + n_block > n_full)
	    disp("Dernier bloc.")
	    b_last_block = true;
	    n_block = n_full - k_block;
	end
	rg_block = k_block + (1:n_block);


        %Calcul de la norme de l'extrait
        %nm_block = sum(abs(au_block).^2,1).^.5;

        %Calcul de la correlation

        %On trouve la position dans l'extrait

        %Ajout aux statistiques, delta temporel (échantillon et
        %secondes), corrélation.

        %Calcul du range
        %n_max_corr_start = rg_instru2(1) - p_block_instru2_max;
        %n_max_corr_end   = n_max_corr_start + c_block3*n_block - 1;

        %rg_max_corr = max(1,n_max_corr_start):min(n_instru,n_max_corr_end);


        %Calcul du coefficient.
	
        %Ajout du bloc au flux.
        %au_vox(rg_block, :) = oli_subtract_block(au_full, au_instru,n_full_start,  n_block, p_max_corr, coefficient); %TODO: DANGER
	if(b_last_block)
	    break;
	end
    end
end
%Écriture du fichier.
%oli_save_track(au_vox, f_samplerate, tx_title);
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
