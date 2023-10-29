% The following matrix implements the SIR dynamics example from Chapter 9.3
% of the textbook.
A = [0.95, 0.04, 0, 0; 0.05, 0.85, 0, 0; 0, 0.1, 1, 0; 0, 0.01, 0, 1];

% The following matrix is needed to use the lsim function to simulate the
% system in question
B = zeros(4, 1);

% initial conditions (i.e., values of S, I, R, D at t = 0).
x0 = [1, 0, 0, 0];

% Here is a compact way to simulate a linear dynamical system.
% Type 'help ss', 'help lsim', etc., to learn about how these functions work!!
sys_sir_base = ss(A, B, eye(4), zeros(4, 1), 1);
Y = lsim(sys_sir_base, zeros(300, 1), linspace(0, 299, 300), x0);

% plot the output trajectory
plot(Y, 'LineWidth', 2);
axis tight;
title('SIRD Model');
legend('Susceptible', 'Infected', 'Recovered', 'Deceased');
xlabel('Elapsed Time (Days)');
ylabel('Population Percentage');

% Compared to the output of the manual implementation of the SIRD model in
% part1.m, implementation via pre-packaged MATLAB functions such as "lsim"
% and "ss" are both concise and easy to modify different parameters. For
% example, changing a few values of lsim from the original

% lsim(sys_sir_base, zeros(1000, 1), linspace(0, 999, 1000), x0);

% to the current

% lsim(sys_sir_base, zeros(300, 1), linspace(0, 299, 300), x0);

% simulates the model in only 300 days instead of 1000, which is already
% sufficient given that the SIRD values graphically converge by the time
% 300 days have elapsed.

% The two methods require different approaches (pre-packaged functions vs.
% manually but arrive at the same result.