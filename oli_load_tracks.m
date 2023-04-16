function [instrumental, full, samplerate] = oli_load_tracks(t_title)
t_src = "Source/";
t_dst = "Vocaux/";
t_instru = " (Instrumental)";
t_wav = ".wav";
t_vox = " (Vocals)";

instrumental = audioread([t_src,t_title,t_instru,t_wav]);
[full, samplerate] = audioread([t_src,t_title,t_wav]);
end
