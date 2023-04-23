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
t_block = .01 %Durée d'un bloc de reconstruction. (secondes)
%r_block     %Taux de recouvrement (pourcents).

%Recherche de la position globale.
c_block2 = 100; % t_block2/t_block: Nombre de blocs de reconstruction (block)
               % dans un bloc de recherche de positions (block2).
t_block2 = c_block2 * t_block % Durée d'un bloc de recherche de position.
t_tail = 10*t_block            % Durée de la queue avant et après un bloc de 
                              % recherge de position pour réglage fin.

"Vocaux"
"Récupération des sources"
[au_instru, au_full, f_samplerate] = oli_load_tracks(tx_title);

"Initialisation"
n_block  = floor(f_samplerate * t_block);
n_block2 = c_block2 * n_block;
n_tail   = floor(f_samplerate * t_tail);

[n_instru, c_instru] = size(au_instru);
[n_full,   c_full]   = size(au_full);

%Initialisation du flux audio
au_vox = zeros(n_full,c_full);

%"Calcul des normes"
%norms_instru_mp = oli_norms_mp(au_instru(:,1), n_block);

"Calcul des normes des petits blocs."
[nm_full_block,   rg_full_block]   = oli_block_norm(au_full,   n_block);
[nm_instru_block, rg_instru_block] = oli_block_norm(au_instru, n_block);

tm_init = time;

%Calcul d'un bloc de recherche de positions (block2).
for k_block2 = 0:length(rg_full_block)-1
    %On trouve le meilleur extrait a soustraire.
    n_nm_block2 = rg_full_block(k_block2+1);
    if(1+c_block2*k_block2 > length(rg_full_block))
	break
    end
    r_actuel = rg_full_block(1+c_block2*k_block2)/n_full;
    tm_actuel = time;
    tm_final_m_actuel = (r_actuel^(-1) - 1) * (tm_actuel - tm_init);
    tm_final = tm_actuel + tm_final_m_actuel;
    disp(["Temps restant: ",...
          num2str(floor(tm_final_m_actuel/60)),...
	  " min. Fin prévue: ",...
	  ctime(tm_final)])
    nm_block2   = nm_full_block(1+k_block2:c_block2+k_block2, :); 
    [cr_block2,     p_block2]     = oli_corr(nm_block2, nm_instru_block);
    [cr_max_block2,  n_max_block2]  = max(cr_block2, [], 1); %plus grand du bloc2.
    [cr2_max_block2, n2_max_block2] = max(cr_max_block2); %plus grand de la stéréo.
    p_max_block2 = p_block2(n_max_block2(n2_max_block2));
    display(cr_max_block2)

    rg_instru2 =...
        max(1,               1 + rg_full_block(1+k_block2) - p_max_block2 - n_tail):...
        min(n_instru, n_block2 + rg_full_block(1+k_block2) - p_max_block2 + n_tail);
    n_instru2 = length(rg_instru2);
                 
    au_instru2 = au_instru(rg_instru2,:);
    %Calcul des normes de l'instrumental
    nm_instru2_mp = oli_norms_mp(au_instru2, n_block);

    %Calcul d'un bloc de reconstruction (block).
    for k_block = (0:(c_block2-1))
	    %Calcul de la covacovariance
	    %p_corr: (-ny+1 : n_x-1)
	    % k = p_corr + N_y - 1
	    k_global = 1 + k_block+c_block2*k_block2;
	    if(k_global>length(rg_full_block))
		break;
	    end

            n_block_start = 1 + rg_full_block(k_global);
	    n_block_end   = min(n_full, n_block_start + n_block - 1);
	    rg_block = n_block_start:n_block_end;
	    au_block = au_full(rg_block,:);
	    [cv_block_instru2, p_block_instru2] = oli_cov(au_block, au_instru2);

	    %Calcul de la norme de l'extrait
	    nm_block = sum(abs(au_block).^2,1).^.5;

	    %Calcul de la correlation
	    %p: (-ny+1 : nx-1);
	    if(length(rg_block) < n_block)
		n2_block = length(rg_block);
		nm_instru2_mp = oli_norms_mp(au_instru2, n2_block);
	    end
	    cr_block_instru2 =   cv_block_instru2...
	                      ./(nm_instru2_mp .* nm_block);

	    %On trouve la position dans l'extrait
	    [cr_block_instru2_max, n_block_instru2_max] =...
                max(abs(cr_block_instru2),[],1);
            [cr2_block_instru_max, n2_block_instru2_max] =...
	        max(cr_block_instru2_max);
            n3_block_instru2_max = n_block_instru2_max(n2_block_instru2_max);
	    p_block_instru2_max = p_block_instru2(n3_block_instru2_max);

	    %Ajout aux statistiques, delta temporel (échantillon et 
	    %secondes), corrélation.

	    %Calcul du range
	    n_max_corr_start = rg_instru2(1) - p_block_instru2_max;
	    n_max_corr_end   = n_max_corr_start + n_block - 1;

	    rg_max_corr = max(1,n_max_corr_start):min(n_instru,n_max_corr_end);


	    %Calcul du coefficient.
	    coefficient = cv_block_instru2(n3_block_instru2_max, :)...
	    		./(nm_instru2_mp(n3_block_instru2_max,:).^2);
            disp([cr_block_instru2_max,coefficient, length(rg_max_corr) - length(rg_block)])
            if(length(rg_block) == length(rg_max_corr))
		%Ajout du bloc au flux.
		au_vox(rg_block,:) =    au_full(rg_block,:)...
				      - coefficient...
				     .* au_instru(rg_max_corr,:);
            end
    end
end
%Écriture du fichier.
oli_save_track(au_vox, f_samplerate, tx_title);
%Écriture du ficher statistique.
"Fin"
