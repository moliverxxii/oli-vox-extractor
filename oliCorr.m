% vect_x longueur : n_x,n_can
% vect_y longueur : n_y,n_can
% vect_corr(k+1) = vect_x (conv) vect_y
% corr_{x|y}(p) \ p = [[ -(n_y - 1), (n_x - 1) ]]
%    k = 0              <=> p = -(n_y - 1) ,
%    k = n_x + n_y - 2  <=> p = n_x - 1    ,
% => p = k - (n_y - 1).
%
%   corr_{x|y}(p) = <x(0 : n_x-1)|y(-p : n_x-1-p)>
%
function [vect_corr, p_corr] = oliCorr(vect_x,vect_y)
n_x = size(vect_x)(1);
n_y = size(vect_y)(1);
n_corr = n_x + n_y - 1;
vect_corr = zeros(n_x+n_y-1, size(vect_x)(2));
n_fft = 2^ceil(log2(n_corr));
corr_f = fft(vect_x,n_fft);
corr_f = corr_f .* fft(vect_y(end:-1:1,:),n_fft);
vect_corr = real(ifft(corr_f));
vect_corr = vect_corr(1:n_corr,:);
p_corr = ((-n_y+1):(n_x-1));
end

