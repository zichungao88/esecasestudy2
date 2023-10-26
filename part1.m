% simulating the SIRD model from scratching w/o using pre-packaged MATLAB
% functions e.g. "lsim" and "ss"

x = [1, 0, 0, 0]'; % begin with the entire population susceptible
A = [0.95, 0.04, 0, 0; 0.05, 0.85, 0, 0; 0, 0.1, 1, 0; 0, 0.01, 0, 1];

Y = x; % day 1
for i = 2:300 % days 2 to convergence
    x = A * x;
    Y = [Y, x];
end

plot(Y', 'LineWidth', 2);
axis tight;
title('SIRD Model Simulated Manually');
legend('Susceptible', 'Infected', 'Recovered', 'Deceased');
xlabel('Time');
ylabel('Population Percentage');

% re-simulating the SIRD model but re-infections are possible i.e. all
% recovered individuals immediately become susceptible again; model is
% simplified to neglect the period of immunization between initial
% infection and later re-infections i.e. an individual is susceptible again
% immediately after recovery

x = [1, 0, 0, 0]'; % again, begin with the entire population susceptible
A = [0.95, 0.09, 0, 0; 0.05, 0.9, 0, 0; 0, 0, 0, 0; 0, 0.01, 0, 1];

Y = x; % day 1
for i = 2:3000 % days 2 to convergence
    x = A * x;
    Y = [Y, x];
end

figure;
plot(Y', 'LineWidth', 2);
axis tight;
title('Modified SIRD Model Simulated Manually');
legend('Susceptible', 'Infected', 'Recovered', 'Deceased');
xlabel('Time');
ylabel('Population Percentage');