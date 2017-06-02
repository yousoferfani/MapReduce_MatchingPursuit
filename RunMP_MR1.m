clc
clear all
close all
load 'FBDATA.mat'

maxIter=350
Lbase=4000
no_segments=40

[sig,fs] = wavread('myaudiofile.wav');

knumBases=25;
sig=sig(1:end,1);
no_segments=floor(no_segments*length(sig)/fs);
[selected_max_coefficient,selected_time_indx,selected_channel_indx]  = MP_MR1(sig, maxIter,FB,no_segments);
plot(selected_max_coefficient)
Leng=length(sig);


[out]=reconstruct(selected_max_coefficient,selected_channel_indx,selected_time_indx,FB,Leng+Lbase);
out=out(1:length(sig));
out=out';


% wavplay(out,fs)
mSNRR=10*log10( sum(sig.^2)/sum((sig-out).^2)  )

plot(sig);hold on;plot(out,'r')


