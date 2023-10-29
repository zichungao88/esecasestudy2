% Part II: Fit the Model to Real Data

load('COVID_STL.mat');

% visualize total cases over time divided into four time periods of
% pandemic progression
hold on;
plot(dates(1:68), cases_STL(1:68) / POP_STL * 100, 'red', 'LineWidth', 2);
plot(dates(68:85), cases_STL(68:85) / POP_STL * 100, 'green', ...
    'LineWidth', 2);
plot(dates(85:106), cases_STL(85:106) / POP_STL * 100, 'cyan', ...
    'LineWidth', 2);
plot(dates(106:158), cases_STL(106:158) / POP_STL * 100, 'blue', ...
    'LineWidth', 2);
hold off;
axis tight;
title('COVID Cases by Phases in St. Louis City & County');
legend('Initial Phase', 'Delta Variant Phase', 'Omicron Variant Phase', ...
    'Most Recent Phase', 'Location','northwest');
xlabel('Date');
ylabel('Percent of Total Population');
ytickformat('percentage');

% similarly, visualize total deaths over time
figure;
hold on;
plot(dates(1:68), deaths_STL(1:68) / POP_STL * 100, 'red', 'LineWidth', 2);
plot(dates(68:85), deaths_STL(68:85) / POP_STL * 100, 'green', ...
    'LineWidth', 2);
plot(dates(85:106), deaths_STL(85:106) / POP_STL * 100, 'cyan', ...
    'LineWidth', 2);
plot(dates(106:158), deaths_STL(106:158) / POP_STL * 100, 'blue', ...
    'LineWidth', 2);
hold off;
axis tight;
title('COVID Deaths by Phases in St. Louis City & County');
legend('Initial Phase', 'Delta Variant Phase', 'Omicron Variant Phase', ...
    'Most Recent Phase', 'Location','northwest');
xlabel('Date');
ylabel('Percent of Total Population');
ytickformat('percentage');

% set initial conditions based on given cases & deaths data
% initial phase: 3/18/2020 ~ 6/29/2021
d = deaths_STL(1) / POP_STL;
r = 0;
i = cases_STL(1) / POP_STL;
s = 1 - i - d;
x1 = [s, i, r, d]';

newCases = [];
newDeaths = [];
for i = 1:67
    newCases = [newCases, cases_STL(i + 1) - cases_STL(i)];
    newDeaths = [newDeaths, deaths_STL(i + 1) - deaths_STL(i)];
end

avgNewCases = mean(newCases) / POP_STL;
avgNewDeaths = mean(newDeaths) / POP_STL;

ss = 1 - avgNewCases;   si = 0.7 - avgNewDeaths;    sr = 0;     sd = 0;
is = avgNewCases;       ii = 0;                     ir = 0;     id = 0;
rs = 0;                 ri = 0.3;                   rr = 1;     rd = 0;
ds = 0;                 di = avgNewDeaths;          dr = 0;     dd = 1;

A = [ss, si, sr, sd; is, ii, ir, id; rs, ri, rr, rd; ds, di, dr, dd];

Y = x1; % day 1
for i = 2:67 % days 2 to convergence
    x1 = A * x1;
    Y = [Y, x1];
end

figure;
hold on;
plot(dates(1:67), Y' * 100, 'LineWidth', 2);
plot(dates(1:67), newCases / POP_STL * 100, 'LineWidth', 2);
plot(dates(1:67), deaths_STL(1:67) / POP_STL * 100, 'LineWidth', 2);
hold off
axis tight;
title('SIRD Model Fitting via Manual Parameter Tuning');
legend('Susceptible', 'Infected', 'Recovered', 'Deceased', ...
    'Active Cases', 'Total Deaths');
xlabel('Date');
ylabel('Percent of Total Population');
ytickformat('percentage');

% delta phase: 6/30/2021 ~ 10/26/2021
d = deaths_STL(68) / POP_STL;
r = 0; % ?
i = cases_STL(68) / POP_STL;
s = 1 - i - d;
x2 = [s, i, r, d]';

% omicron phase: 10/27/2021 ~ 3/22/2022
d = deaths_STL(85) / POP_STL;
r = 0; % ?
i = cases_STL(85) / POP_STL;
s = 1 - i - d;
x3 = [s, i, r, d]';