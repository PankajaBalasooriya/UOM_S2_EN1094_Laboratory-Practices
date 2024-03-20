% Sampling
Fs = 6000; 
qbits = 8; 
% recObj = audiorecorder(Fs,qbits,1); 
% disp('Start speaking.') 
% recordblocking(recObj, 5);
% disp('End of Recording.');
% audio_samples = getaudiodata(recObj);
[audio_samples,Fs] = audioread('Recording.wav');

% quantizing
siz = size(audio_samples);
size_audio_samples = siz(1);
number_of_bits = qbits*size_audio_samples;
bit_stream = zeros([1,number_of_bits]);

for i = 1:size_audio_samples
    num = audio_samples(i, 1);
    if(num<0)
    bit_stream(1,(i-1)*qbits+1) = 1;
    else
    bit_stream(1,(i-1)*qbits+1) = 0;
    end
    num =abs(num);
    for j = 2:qbits
        num = 2*num;
        if(num>=1)
            bit_stream(1,(i-1)*qbits+j) = 1;
            num = num - 1;
        else
            bit_stream(1,(i-1)*qbits+j) = 0;
        end
    end
end

% Encode
samples_per_bit = 100;
%Amplitude in decibels
Amplitude = -5;
%The sampling rate used to represent the anlog singal in MATLAB
sampling_rate = Fs*qbits*samples_per_bit; 
% frequency of the sinosoid
fc = sampling_rate/100;
Wc = 2*pi*fc;
%Sample time period
delt = 1/sampling_rate; 
phase0 = pi;
phase1 = 0;

%Total number of samples of the transmitted signal
number_of_samples = number_of_bits*samples_per_bit;
%X(t) − This array is used to store the transmitted analog signal
X = zeros([1,number_of_samples]); 

power = 10^(Amplitude/20); %Signal power in watts.
t_bit = delt:delt:delt*samples_per_bit;
bit1 = sqrt(power)*sin(Wc*t_bit+phase1); %Representation of bit 1
bit0 = sqrt(power)*sin(Wc*t_bit+phase0); %Representation of bit 0
for i = 1:number_of_bits
    if(bit_stream(i)==1)
        X(samples_per_bit*(i-1)+1:samples_per_bit*i) = bit1;
    else
        X(samples_per_bit*(i-1)+1:samples_per_bit*i) = bit0;
    end
end

% Channel
att = 0.8;%attenuation factor
%Paramenters of the noise signal (mu, and sigma). modeling noise as a 
% Gaussian random variable
mu = 0; 
sigma = 1;
%N(t) − noise signal
N = normrnd(mu,sigma,1,samples_per_bit*number_of_bits); 
X_hat = att*X + N; %signal after noise
%Filtering Effect
fc_butter = fc*25;
[fil_b,fil_a] = butter(10,fc_butter/(sampling_rate/2));
%recived signal after bandwidth limitation (filtering)
Y = filter(fil_b,fil_a,X_hat);

% Reciver
%The array to store the decoded bit stream
decoded_bit_stream = zeros([1,number_of_bits]); 
%Phase estimation matrox
H = [cos(Wc*delt*[1:samples_per_bit]'),sin(Wc*delt*[1:samples_per_bit]')];

% Phase estimation
for i = 1:number_of_bits 
    f = inv(H'*H)*H'*Y((i-1)*samples_per_bit+1:i*samples_per_bit)';
    decoded_phase = 0;
    if(f(2) == 0)
        if(f(1) >= 0)
            decoded_phase = pi/2;
        else
            decoded_phase = -pi/2;
        end
    else
        decoded_phase = atan(f(1)/f(2));
        if(f(1)<=0 & f(2)<0)
            decoded_phase = decoded_phase-pi;
        elseif(f(1)>0 & f(2)<0)
        decoded_phase = decoded_phase+pi;
        end
    end
    p0 = min(abs(decoded_phase - phase0),2*pi-abs(decoded_phase - phase0));
    p1 = min(abs(decoded_phase - phase1),2*pi-abs(decoded_phase - phase1));
    if(p0<p1)
        decoded_bit_stream(i) = 0;
    else
        decoded_bit_stream(i) = 1;
    end
end

% Reconstructing the auddio samples from the bit stream
decoded_audio_samples = zeros([size_audio_samples,1]);
for i=1:size_audio_samples
    st = 0.5;
    for j=2:qbits
        decoded_audio_samples(i) = decoded_audio_samples(i)+st*decoded_bit_stream((i-1)*qbits+j);
        st = st/2;
    end
    if(decoded_bit_stream((i-1)*qbits+1) == 1)
        decoded_audio_samples(i) = -decoded_audio_samples(i);
    end
end

% Destination
% pause(10);
sound(5*decoded_audio_samples,Fs)

figure(1)
subplot(1,2,1)
plot(audio_samples)
title('Original Audio Signal')
xlabel('t (s)')
ylabel('Amplitude')
subplot(1,2,2)
plot(decoded_audio_samples);
title('Decoded Audio Signal')
xlabel('t (s)')
ylabel('Amplitude')

L_1 = size_audio_samples;
Audio_freq = fft(audio_samples);
Audio_freq_norm = abs(Audio_freq/L_1);
Audio_freq_norm_one = Audio_freq_norm(1:L_1/2+1);
Audio_freq_norm_one(2:end-1) = 2*Audio_freq_norm_one(2:end-1);
L_2 = samples_per_bit*number_of_bits;
X_freq = fft(X);
X_freq_norm = abs(X_freq/L_2);
X_freq_norm_one = X_freq_norm(1:L_2/2+1);
X_freq_norm_one(2:end-1) = 2*X_freq_norm_one(2:end-1);
f_1 = Fs*(0:(L_1/2))/L_1;
f_2 = sampling_rate*(0:(L_2/2))/L_2;
figure(2)
subplot(1,2,1)
plot(f_1,Audio_freq_norm_one);
title('Single-Sided Amplitude Spectrum of the Original Audio Stream');
xlabel('f (Hz)')
ylabel('|P1(f)|')
subplot(1,2,2)
plot(f_2,X_freq_norm_one);
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


%BER calculation
BER = sum(decoded_bit_stream ~= bit_stream)/length(bit_stream);
disp(BER);