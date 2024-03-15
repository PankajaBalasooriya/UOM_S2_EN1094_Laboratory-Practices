%fsk.m
close all;
clear all;
bit_pattern=[ 1 0 0 1 1 0 1 1 1 0 1 1 0 0 0 1 1 1 1 0 0 0 1 1];
Cf0 = 0.8E6; % Carrier frequency to encode binary 0, 0.8 MHz;
Cf1 = 2.4E6; % Carrier frequency to encode binary 1, 2.4 MHz;
%We will represent the signal using samples taken at intervals of le−8 S
%i.e., a sampling frequency of 100 MHz
%and a bit rate of 400 kbps i.e. 250 samples per bit
delt=1E-8;
fs=1/delt;
samples_per_bit=250;
tmax = (samples_per_bit*length(bit_pattern)-1)*delt;
t = 0:delt:tmax; %time window we are interested in
%Generation of the binary info signal
bits=zeros(1,length(t));
for bit_no=1:1:length(bit_pattern)
    for sample=1:1:samples_per_bit
        bits((bit_no-1)*samples_per_bit+sample)=bit_pattern(bit_no);
    end
end
%See what it looks like
figure;
subplot(2,1,1); plot(t,bits);
ylabel ('Amplitude');
title ('Info signal');
axis([0 tmax -2 2]);
%FSK Modulation
FSK=[];
for bit_no=1:1:length(bit_pattern)
    if bit_pattern(bit_no)==1
        t_bit =(bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
        Wc=Cf1*2*pi*t_bit;
        mod=(1)*sin(Wc);
    elseif bit_pattern(bit_no)==0
        t_bit =(bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
        Wc=Cf0*2*pi*t_bit;
        mod=(1)*sin(Wc);
    end
    FSK=[FSK mod];
end
subplot(2,1,2); plot(t,FSK);
ylabel ('Amplitude');
title ('FSK Modulated Signal');
axis([0 tmax -2 2]);



