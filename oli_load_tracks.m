function [instrumental, full, samplerate] = oli_load_tracks(tx_title)
tx_src = "Source/";
tx_instru = " (Instrumental)";
tx_wav = ".wav";
tx_vox = " (Vocals)";

instrumental = audioread([tx_src,tx_title,tx_instru,tx_wav]);
[full, samplerate] = audioread([tx_src,tx_title,tx_wav]);
end
