%nm_norms_mp: les normes selon la variable p_norms_mp (-n_input+1:n_block-1).
%p_norms_mp : les décalages entre le bloc et l'audio à comparer.
%au_input   : audio dont il faut calculer les normes.
%n_block    : durée numérique du bloc sur lequel les normes sont calculées.
function [nm_norms_mp, p_norms_mp] = oli_norms_mp(au_input, n_block)
[n_input, c_input] = size(au_input);
p_input_block = (-n_input+1):(n_block-1);

nm_norms_mp = zeros(n_corr,c_input);
for k_norms = 1:length(p_input_block)
    rg_norms = max(1, 1 - p_corr(k_norms)):...
               min(n_input, n_block - p_corr(k_norms));
    norms_y_mp(n,:) =  sum(au_input(rg_norms,:).^2);
end
norms_y_mp = norms_y_mp.^.5;
end
