% Part II: Fit the Model to Real Data

load('COVID_STL.mat');

hold on;
plot(dates, cases_STL / POP_STL * 100, 'LineWidth', 2);
plot(dates, deaths_STL / POP_STL * 100, 'LineWidth', 2);
hold off;
axis tight;
title('COVID Cases and Deaths in St. Louis City & County');
legend('Cumulative Cases', 'Cumulative Deaths');
xlabel('Date');
ylabel('Percent of Total Population');
ytickformat('percentage');

% set initial conditions based on given cases & deaths data
% initial phase: 3/18/2020 ~ 6/29/2021
d = deaths_STL(1) / POP_STL;
r = 0;
i = cases_STL(1) / POP_STL;
s = 1 - i - d;

x1 = [s, i, r, d];

% delta phase: 6/30/2021 ~ 10/26/2021
d = deaths_STL(68) / POP_STL;
r = 0; % ?
i = cases_STL(68) / POP_STL;
s = 1 - i - d;

x2 = [s, i, r, d];

% omicron phase: 10/27/2021 ~ 3/22/2022
d = deaths_STL(85) / POP_STL;
r = 0; % ?
i = cases_STL(85) / POP_STL;
s = 1 - i - d;

x3 = [s, i, r, d];