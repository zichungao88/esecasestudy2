% simulating the SIRD model from scratching w/o using pre-packaged MATLAB
% functions e.g. "lsim" and "ss"

x = [1, 0, 0, 0]'; % begin with the entire population susceptible

% define matrix elements outside the matrix for purposes of simpler
% modification
ss = 0.95;
si = 0.04;
sr = 0;
sd = 0;
is = 0.05;
ii = 0.85;
ir = 0;
id = 0;
rs = 0;
ri = 0.1;
rr = 1;
rd = 0;
ds = 0;
di = 0.01;
dr = 0;
dd = 1;

A = [ss, si, sr, sd; is, ii, ir, id; rs, ri, rr, rd; ds, di, dr, dd];

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
% immediately after recovery (everyone will die eventually as a result)

x = [1, 0, 0, 0]'; % again, begin with the entire population susceptible

ss = 0.95;
si = 0.09;
sr = 0;
sd = 0;
is = 0.05;
ii = 0.9;
ir = 0;
id = 0;
rs = 0;
ri = 0;
rr = 0;
rd = 0;
ds = 0;
di = 0.01;
dr = 0;
dd = 1;

A = [ss, si, sr, sd; is, ii, ir, id; rs, ri, rr, rd; ds, di, dr, dd];

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

% Compared to the output of the manual implementation of the SIRD model in
% part1.m, implementation via pre-packaged MATLAB functions such as "lsim"
% and "ss" in base_sir.m are both concise and easy to modify different
% parameters. For example, changing a few values of lsim from the original

% lsim(sys_sir_base, zeros(1000, 1), linspace(0, 999, 1000), x0);

% to the current

% lsim(sys_sir_base, zeros(300, 1), linspace(0, 299, 300), x0);

% simulates the model in only 300 days instead of 1000, which is already
% sufficient given that the SIRD values graphically converge by the time
% 300 days have elapsed.

% The two methods require different approaches (pre-packaged functions vs.
% manually but arrive at the same result.