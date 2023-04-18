function [vect_cov, p_cov] = oli_corr(vect_x, vect_y)
[vect_cov, p_corr] = oli_cov(vect_x, vect_y);

[n_corr, width_track] = size(vect_cov);
n_x = size(vect_x)(1);
n_y = size(vect_y)(1);

norm_x = sum(vect_x.^2).^.5;
norms_y_mp = zeros(n_corr,width_track);
for n = 1:length(p_corr)
    range_n = max(1, 1 - p_corr(n)):...
              min(n_y, n_x - p_corr(n));
    norms_y_mp(n,:) =  sum(vect_y(range_n,:).^2);
end
norms_y_mp = norms_y_mp.^.5;

vect_corr = vect_cov./(norms_y_mp .* norm_x);
end
