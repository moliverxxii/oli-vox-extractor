"Vocaux"
"Récupération des sources"
%t_song = "The Day The World Went Away";
t_src = "Source/";
t_dst = "Vocaux/";
t_instru = " (Instrumental)";
t_wav = ".wav";
t_vox = " (Vocals)";
instru = audioread([t_src,t_song,t_instru,t_wav]);
[full, sample_r] = audioread([t_src,t_song,t_wav]);

"Initialisation"
n_extr = 2*sample_r;
n_instru = length(instru(:,1))
n_full = length(full(:,1))
ratio = 8;
n_off = n_extr/ratio

n_scan = n_instru - n_full;
n_scan = floor(abs(n_scan - 3*sample_r) + 3*sample_r);
n_fft = 2^(ceil(log2(n_extr+n_scan-1)))
n_scan = n_fft - n_extr + 1;


vox = zeros(n_full,2);
"calcul des normes"
norms_instru = oli_norms(instru(:,1),n_extr);



"calcul de la covariance"
for os = (0:n_off:n_full-n_extr)
    os2 = os - 1 * sample_r;
    if(os + n_extr>n_full)
	n_extr = n_full - os;
    end
    if(os2<0)
	os2 = 0;
    end
    r_full = (1+os:n_extr+os);
    r_instru = (1+os2:n_scan+os2);
    if(r_instru(end)>n_instru)
	os2 = n_instru - n_scan;
	r_instru = (1+os2:n_scan+os2);
    end

    covar = oliCorr(full(r_full,1), instru(r_instru,1));

    "calcul de la correlation";
    r_norms = (os2 + n_scan + n_extr - 1):-1:(os2 + 1); %TODO PASBON!!!
    corr = (covar./norms_instru(r_norms))/norm(full(r_full,1));
    [max_corr, i_max] = max(abs(corr));
    corr(i_max)
    delta = i_max - n_scan;
    beta = covar(i_max)/(norms_instru(n_extr + os2 - delta)^2); %TODO 
    r_instru = (os2-delta + 1):(os2-delta+n_extr);
    if r_instru(1) < 1
	r_full = r_full(2-r_instru(1) :end);
	r_instru = r_instru(2-r_instru(1) :end);
    end
    if (r_instru(end) > n_instru)
	vox(r_full,:) += ratio^(-1)*(full(r_full,:));
    else
	vox(r_full,:) += ratio^(-1)*(full(r_full,:) - beta * instru(r_instru,:));
    end
end


audiowrite([t_dst,t_song,t_vox,t_wav],vox,sample_r,'BitsPerSample',32)
"Fin"
