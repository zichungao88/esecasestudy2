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
d = deaths_STL(1) / POP_STL;
r = 0;
i = cases_STL(1) / POP_STL;
s = 1 - i - d;

x = [s, i, r, d];