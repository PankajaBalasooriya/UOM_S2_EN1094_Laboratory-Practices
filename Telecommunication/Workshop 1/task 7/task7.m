% Define time vector
t = 0:0.0001:1.5; % Time range from 0 to 10 seconds with 0.01 second steps


% Generate the sine wave
y = 10*sin(200*t) + 8*sin(220*t) + 6*sin(240*t) + 4*sin(260*t) + 2*sin(280*t);

% Create the plot
figure;
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sine Wave');
