function [cr_output, p_output] = oli_corr(au_x, au_y)
[cv_output, p_output] = oli_cov(au_x, au_y);

[n_corr, c_output] = size(cv_output);
n_x = size(au_x)(1);
n_y = size(au_y)(1);

nm_x = sum(au_x.^2).^.5;
nm_y_mp = oli_norms_mp(au_y, n_x);

vect_corr = cv_output./(nm_y_mp .* nm_x);
end
