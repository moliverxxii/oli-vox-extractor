function oli_save_track(au_vox, f_samplerate, tx_title)
tx_dst = "Vocaux/";
tx_vox = " (Vocals)";
tx_wav = ".wav";
audiowrite([tx_dst,tx_title,tx_vox,tx_wav],au_vox,f_samplerate,'BitsPerSample',32)
end
