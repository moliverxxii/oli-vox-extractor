function nm_output = oli_norms(au_input,n_block)
[n_input, c_input] = size(au_input);
au_input_sq  = au_input.^2;
filt_b = ones(n_block,1);
n_norms = n_input + n_block - 1;
n_fft = 2^ceil(log2(n_norms));

fr_nm_output = fft(au_input_sq, n_fft);
fr_nm_output = fr_nm_output .* fft(filt_b, n_fft);

nm_output = zeros(n_fft,c_input);
nm_output = ifft(fr_nm_output);
nm_output = nm_output(1:n_norms,:);
nm_output = abs(nm_output).^.5;
oli_norms_param = false;
if(oli_norms_param)
    for i = (3:n_norms)
	if(nm_output(i-1)==0)
	    nm_output(i-1) = .5*(nm_output(i-2)+nm_output(i));
	end
    end
end
end
