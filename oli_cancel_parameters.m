%au_x l'extrait avec le bloc dont il faut trouver la position dans au_y
%au_y le bloc ou se trouve au_x dans une certaine proportion.
%n_x_start la position (1 à n_x) du premier échantillon du bloc à analyser.
%n_block le nombre d'échantillons du bloc.
function [p_max_x_y, r_max_x_y, cr_max_x_y] = oli_cancel_parameters(au_x,...
                                                                    au_y,...
                                                                    n_x_start,...
                                                                    n_block)
rg_block_x              = n_x_start+(0:n_block-1);
nm_y_mp                 = oli_norms_mp(au_y, n_block);
nm_block                = sum(abs(au_x(rg_block_x,:)).^2,1).^.5;
[cv_block_y, p_block_y] = oli_cov(au_x(rg_block_x,:),au_y);
cr_block_y              = cv_block_y ./(nm_y_mp .* nm_block);

[cr1_max_block_y, n1_max_block_y] =...
        max(abs(cr_block_y),[],1);
[cr2_block_instru_max, n2_max_block_y] =...
        max(cr1_max_block_y,[],2);
n3_max_block_y = n1_max_block_y(n2_max_block_y);
%Le décalage à appliquer.
p_max_x_y = p_block_y(n3_max_block_y) + n_x_start - 1;
%Le coefficient de projection.
r_max_x_y = cv_block_y(n3_max_block_y,:)./(nm_y_mp(n3_max_block_y,:).^2);
%Le coefficient de corrélation.
cr_max_x_y = cr_block_y(n3_max_block_y);
%plot(p_block_y, cr_block_y)

end
