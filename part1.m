% simulating the SIRD model from scratching w/o using pre-packaged MATLAB
% functions e.g. "lsim" and "ss"

x = [0.75, 0.1, 0.1, 0.05]';
A = [0.95, 0.04, 0, 0; 0.05, 0.85, 0, 0; 0, 0.1, 1, 0; 0, 0.01, 0, 1];

Y = x; % day 1
for i = 2:100 % days 2 to 100
    x = A * x;
    Y = [Y, x];
end

plot(Y', 'LineWidth', 2);
axis tight;
title('SIRD Model Simulated Manually');
legend('Susceptible','Infected','Recovered','Deceased');
xlabel('Time');
ylabel('Population Percentage');