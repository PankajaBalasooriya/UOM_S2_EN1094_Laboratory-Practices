% Given data
x = [10 50 75 100 200 300 400 470 450 500 600 700 1000 10000]; % Logarithm of x values
y = [0 0 0 80 120 140 160 180 160 160 40 0 0 0]; % Corresponding y values

% Plotting
plot(log(x), y, 'o-');
xlabel('log(x)'); % Label for x-axis
ylabel('y'); % Label for y-axis
title('Plot of y vs log(x)'); % Title for the plot
grid on; % Turn on grid