function [au_sub_xy, n_au_sub_xy] = oli_subtract_block(au_x, au_y)
                                        
[n_x, c_x] = size(au_x);
[n_y, c_y] = size(au_y);

[p_max_x_y, r_max_x_y, cr_max_x_y] = oli_cancel_parameters(au_x, au_y, 1, n_x);
disp([p_max_x_y, floor(10*log10(abs(cr_max_x_y)))])

au_sub_xy = au_x - r_max_x_y .* au_y((1:n_x)-p_max_x_y, :);
n_au_sub_xy = size(au_sub_xy)(1);
end

