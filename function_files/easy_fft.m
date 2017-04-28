function [f,v]=easy_fft(X,sf)

Fs=sf;
T=1/Fs;
L=length(X);
t=(0:L-1)*T;

NFFT=2^nextpow2(L);
v=fft(X,NFFT)/L;
f=Fs/2*linspace(0,1,NFFT/2+1);

v=2*abs(v(1:NFFT/2+1));