% Given data
x = [10 100 200 300 400 500 600 700 1000 10000]; % Logarithm of x values
y = [420 464 400 468 464 460 452 440 424 264]; % Corresponding y values

% Plotting
plot(log(x), y, 'o-');
xlabel('log(x)'); % Label for x-axis
ylabel('y'); % Label for y-axis
title('Plot of y vs log(x)'); % Title for the plot
grid on; % Turn on grid
