
x = [10 100 200 300 400 500 600 700 1000 10000];
y = [48 192 288 326 352 360 368 376 368 176];

% Calculate the log of x
log_x = log10(x);

% Plot log_x vs. y
plot(log_x, y, 'o-');

% Add labels and title
xlabel('log_{10}(frequency)');
ylabel('V (mv)');
title('Voltage vs. Log(frequency)');
% Customize the plot (optional)
grid on;  % Add grid lines
