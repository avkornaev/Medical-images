function [f0,Y0]=AmpFreqResp(x,fs,L)
%Подпрограмма построения АЧХ
NFFT0=2^nextpow2(L);
f0=fs/2*linspace(0,1,NFFT0/2+1);
YY0=fft(x,NFFT0)/L;
Y0=2*abs(YY0(1:NFFT0/2+1));
end

