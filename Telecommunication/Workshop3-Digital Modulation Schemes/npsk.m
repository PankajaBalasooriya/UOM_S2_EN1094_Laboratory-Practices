function []=npsk(bit_pattern,n)
Cf =4E5; %Carrier frequency 0.4 MHz;
%Wewillrepresent the signal as samples taken at intervals of le−8 S
%i.e., a sampling frequency of 100 MHz
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
%Seewhatit looks like
figure;
subplot(2,1,1); plot(t,bits);
ylabel ('Amplitude');
title ('Info signal');
axis([0 tmax -2 2]);
if n==2
    %BPSKModulation
    BPSK=[];
    for bit_no=1:1:length(bit_pattern)
        if bit_pattern(bit_no)==1
            t_bit = (bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
            Wc=Cf*2*pi*t_bit;
            mod=(1)*sin(Wc);
        elseif bit_pattern(bit_no)==0
            t_bit = (bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
            Wc=Cf*2*pi*t_bit;
            mod=(1)*sin(Wc+pi);
        end
        BPSK=[BPSK mod];
    end
    subplot(2,1,2); plot(t,BPSK);
    ylabel ('Amplitude');
    title ('BPSK Modulated Signal');
    axis([0 tmax -2 2]);
elseif n == 4
    %QPSKModulation
    QPSK=[];
    for bit_no=1:2:length(bit_pattern)
        if bit_pattern(bit_no)==0 & bit_pattern(bit_no + 1) == 0
            t_bit = (bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
            Wc=Cf*2*pi*t_bit;
            mod=(1)*sin(Wc + pi/4);
        elseif bit_pattern(bit_no)==0 & bit_pattern(bit_no + 1) == 1
            t_bit = (bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
            Wc=Cf*2*pi*t_bit;
            mod=(1)*sin(Wc + 3*pi/4);
        elseif bit_pattern(bit_no)==1 & bit_pattern(bit_no + 1) == 1
            t_bit = (bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
            Wc=Cf*2*pi*t_bit;
            mod=(1)*sin(Wc+ 5*pi/4);
        elseif bit_pattern(bit_no)==1 & bit_pattern(bit_no + 1) == 0
            t_bit = (bit_no-1)*samples_per_bit*delt:delt:(bit_no*samples_per_bit-1)*delt;
            Wc=Cf*2*pi*t_bit;
            mod=(1)*sin(Wc+7*pi/4);
        end
        QPSK=[QPSK [mod] mod];
    end
    subplot(2,1,2); plot(t,QPSK);
    ylabel ('Amplitude');
    title ('QPSK Modulated Signal');
    axis([0 tmax -2 2]);
    disp(QPSK(1))

end