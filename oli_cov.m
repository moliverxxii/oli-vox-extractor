% vect_x longueur : n_x,n_can
% vect_y longueur : n_y,n_can
% vect_cov(k+1) = vect_x (conv) vect_y
% cov_{x|y}(p) \ p = [[ n_x - n_y , 0 ]]
%    k = 0              <=> p = n_x - n_y ,
%    k = n_y - n_y      <=> p = 0         ,
% => p = k + n_x - n_y.
%
%   cov_{x|y}(p) = <x(0 : n_x-1)|y(-p : n_x-1-p)>
%    TODO: <n_x-n_y :0>
function [vect_cov, p_cov] = oli_cov(vect_x,vect_y)
n_x = size(vect_x)(1);
n_y = size(vect_y)(1);
n_cov = n_y - n_x + 1;
n_cov2 = n_y + n_x - 1;
vect_cov = zeros(n_cov, size(vect_x)(2));
n_fft = 2^ceil(log2(n_cov2));
cov_f = fft(vect_x,n_fft);
cov_f = cov_f .* fft(vect_y(end:-1:1,:),n_fft);
vect_cov = real(ifft(cov_f))(n_x:n_y,:);
vect_cov = vect_cov(1:n_cov,:);
p_cov = ((n_x-n_y):0);
end

