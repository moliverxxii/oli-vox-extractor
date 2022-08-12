function vect_corr = oliCorr(vect_x,vect_y)
n_x = length(vect_x);
n_y = length(vect_y);
n_corr = n_x + n_y - 1;
vect_corr = zeros(n_x+n_y-1, 1);
n_fft = 2^ceil(log2(n_corr));
corr_f = fft(vect_x,n_fft);
corr_f = corr_f .* fft(vect_y(end:-1:1),n_fft);
vect_corr = real(ifft(corr_f));
vect_corr = vect_corr(1:n_corr);
end
