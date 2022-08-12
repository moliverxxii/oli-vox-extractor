function norms = oli_norms(scan,n_extr)
n_scan = length(scan);
a_scan  = scan.^2;
filt_b = ones(n_extr,1);
n_norms = n_scan + n_extr -1;
n_fft = 2^ceil(log2(n_norms));

norms_f = fft(a_scan, n_fft);
norms_f = norms_f .* fft(filt_b, n_fft);

norms = zeros(n_fft,1);
norms = real(ifft(norms_f));

norms = norms(1:n_norms);
norms = abs(norms.^.5);
for i = (3:n_norms)
    if(norms(i-1)==0)
	norms(i-1) = .5*(norms(i-2)+norms(i));
    end


end
plot(norms)
end
