% vect_x longueur : n_x,n_can
% vect_y longueur : n_y,n_can
% vect_cov(k+1) = vect_x (conv) vect_y
% cov_{x|y}(p) \ p = [[ -(n_y - 1), (n_x - 1) ]]
%    k = 0              <=> p = -(n_y - 1) ,
%    k = n_x + n_y - 2  <=> p = n_x - 1    ,
% => p = k - (n_y - 1).
%
%   cov_{x|y}(p) = <x(0 : n_x-1)|y(-p : n_x-1-p)>
%
function [vect_cov, p_cov] = oli_cov(vect_x,vect_y)
n_x = size(vect_x)(1);
n_y = size(vect_y)(1);
n_cov = n_x + n_y - 1;
vect_cov = zeros(n_x+n_y-1, size(vect_x)(2));
n_fft = 2^ceil(log2(n_cov));
cov_f = fft(vect_x,n_fft);
cov_f = cov_f .* fft(vect_y(end:-1:1,:),n_fft);
vect_cov = real(ifft(cov_f));
vect_cov = vect_cov(1:n_cov,:);
p_cov = ((-n_y+1):(n_x-1));
end

