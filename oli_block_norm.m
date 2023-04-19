% Calcul la norme de chaque canal de input pour chaque bloc de longueur n_block
% block_norms: les normes pour chaque bloc
% block_pos  : la position de depart de chaque bloc dans input (relatif à zéro).
function [block_norms, block_pos] =  oli_block_norm(input, n_block)
[n_input, width_input]  = size(input);
block_pos = 0:n_block:(n_input-1);
norms_instru = zeros(length(block_pos),width_input);
for n = 1:length(block_pos)
    block_norms(n,:) = sum(input( (1+block_pos(n)):min(n_block+block_pos(n),end),:).^2);
end
block_norms = abs(block_norms).^.5;
end
