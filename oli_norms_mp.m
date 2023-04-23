%nm_norms_mp: les normes selon la variable p_norms (-n_input+1:n_block-1).
%p_norms : les décalages entre le bloc et l'audio à comparer.
%au_input   : audio dont il faut calculer les normes.
%n_block    : durée numérique du bloc sur lequel les normes sont calculées.
function [nm_norms_mp, p_norms] = oli_norms_mp(au_input, n_block)
[n_input, c_input] = size(au_input);
p_input_block = (-n_input+1):(n_block-1);

nm_norms_mp = zeros(length(p_input_block),c_input);
for k_norms = 1:length(p_input_block)
    rg_norms = max(1,             1 - p_input_block(k_norms)):...
               min(n_input, n_block - p_input_block(k_norms));
    nm_norms_mp(k_norms,:) =  sum(au_input(rg_norms,:).^2);
end
nm_norms_mp = nm_norms_mp.^.5;
end
