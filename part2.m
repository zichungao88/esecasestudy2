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
    'Most Recent Phase', 'Location', 'northwest');
xlabel('Date');
ylabel('Percent of Total STL City & County Population');
ytickformat('percentage');
exportgraphics(gca, 'cases.png');

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
    'Most Recent Phase', 'Location', 'northwest');
xlabel('Date');
ylabel('Percent of Total STL City & County Population');
ytickformat('percentage');
exportgraphics(gca, 'deaths.png');

activeCases = []; % new weekly cases + a portion of previous cases
newCases = []; % new weekly cases only
newDeaths = []; % new weekly deaths
% for purposes of model simplicity, we assume that 9 out of 10 active
% cases from the previous week will carry over to current active cases
% in addition to all new cases
for j = 1:157
    newCases = [newCases, cases_STL(j + 1) - cases_STL(j)];
    if j == 1
        activeCases = [activeCases, cases_STL(j + 1) - cases_STL(j)];
    else
        activeCases = [activeCases, cases_STL(j + 1) - cases_STL(j) + ...
            round(activeCases(j - 1) * 9 / 10)];
    end
    newDeaths = [newDeaths, deaths_STL(j + 1) - deaths_STL(j)];
end

%%
% set initial conditions based on given cases & deaths data
% initial phase: 3/18/2020 ~ 6/29/2021
d = deaths_STL(1) / POP_STL;
r = 0;
i = cases_STL(1) / POP_STL - d;
s = 1 - i - d;
x1 = [s, i, r, d]';

% out of all susceptible population
avgInitialNewCases = mean(newCases(1:67)) / ...
    (POP_STL - mean(cases_STL(1:67)) + mean(activeCases(1:67)));
initialNewDeaths = [];
for j = 1:67
    initialNewDeaths = [initialNewDeaths, newDeaths(j) / activeCases(j)];
end
avgInitialNewDeaths = mean(initialNewDeaths);

% no more explicitly defining matrix elements prior to matrix declaration
% as was the case in part1.m due to the excess amount of variables in the
% MATLAB Workspace
A1 = [1 - avgInitialNewCases,   0.09,                       0,  0;
      avgInitialNewCases,       0.9                         0,  0;
      0,                        0.01 - avgInitialNewDeaths, 1,  0;
      0,                        avgInitialNewDeaths,        0,  1];

Y1 = x1; % week 1
for j = 2:67 % weeks 2 to end of inital phase (before delta)
    x1 = A1 * x1;
    Y1 = [Y1, x1];
end

figure;
hold on;
plot(dates(1:67), Y1(2, :) * 100, 'LineWidth', 2); % infected
plot(dates(1:67), Y1(4, :) * 100, 'LineWidth', 2); % deceased
plot(dates(1:67), activeCases(1:67) / POP_STL * 100, 'LineWidth', 2);
plot(dates(1:67), deaths_STL(1:67) / POP_STL * 100, 'LineWidth', 2);
hold off;
axis tight;
ylim([0 inf]);
title('SIRD Model Fitting via Manual Parameter Tuning (Initial Phase)');
legend('Infected', 'Deceased', 'Active Cases', 'Total Deaths');
xlabel('Date');
ylabel('Percent of Total STL City & County Population');
ytickformat('percentage');
exportgraphics(gca, 'initial_phase.png');

%%
% delta phase: 6/30/2021 ~ 10/26/2021
x2 = x1;

avgDeltaNewCases = mean(newCases(68:84)) / ...
    (POP_STL - mean(cases_STL(68:84)) + mean(activeCases(68:84)));
deltaNewDeaths = [];
for j = 68:84
    deltaNewDeaths = [deltaNewDeaths, newDeaths(j) / activeCases(j)];
end
avgDeltaNewDeaths = mean(deltaNewDeaths);

A2 = [1 - avgDeltaNewCases,     0.09,                       0,  0;
      avgDeltaNewCases,         0.9                         0,  0;
      0,                        0.01 - avgDeltaNewDeaths,   1,  0;
      0,                        avgDeltaNewDeaths,          0,  1];

Y2 = x2;
for j = 69:84
    x2 = A2 * x2;
    Y2 = [Y2, x2];
end

figure;
hold on;
plot(dates(68:84), Y2(2, :) * 100, 'LineWidth', 2);
plot(dates(68:84), Y2(4, :) * 100, 'LineWidth', 2);
plot(dates(68:84), activeCases(68:84) / POP_STL * 100, 'LineWidth', 2);
plot(dates(68:84), deaths_STL(68:84) / POP_STL * 100, 'LineWidth', 2);
hold off;
axis tight;
ylim([0 inf]);
title('SIRD Model Fitting via Manual Parameter Tuning (Delta Phase)');
legend('Infected', 'Deceased', 'Active Cases', 'Total Deaths');
xlabel('Date');
ylabel('Percent of Total STL City & County Population');
ytickformat('percentage');
exportgraphics(gca, 'delta_phase.png');

%%
% omicron phase: 10/27/2021 ~ 3/22/2022
x3 = x2;

avgOmicronNewCases = mean(newCases(85:105)) / ...
    (POP_STL - mean(cases_STL(85:105)) + mean(activeCases(85:105)));
omicronNewDeaths = [];
for j = 85:105
    omicronNewDeaths = [omicronNewDeaths, newDeaths(j) / activeCases(j)];
end
avgOmicronNewDeaths = mean(omicronNewDeaths);

A3 = [1 - avgOmicronNewCases,   0.09,                       0,  0;
      avgOmicronNewCases,       0.9                         0,  0;
      0,                        0.01 - avgOmicronNewDeaths, 1,  0;
      0,                        avgOmicronNewDeaths,        0,  1];

Y3 = x3;
for j = 86:105
    x3 = A3 * x3;
    Y3 = [Y3, x3];
end

figure;
hold on;
plot(dates(85:105), Y3(2, :) * 100, 'LineWidth', 2);
plot(dates(85:105), Y3(4, :) * 100, 'LineWidth', 2);
plot(dates(85:105), activeCases(85:105) / POP_STL * 100, 'LineWidth', 2);
plot(dates(85:105), deaths_STL(85:105) / POP_STL * 100, 'LineWidth', 2);

% omicron phase w/ policy (mask mandate) resulting in 25% reduction in
% cases & deaths
x3 = x2;
avgOmicronNewCases = avgOmicronNewCases * 0.75;
avgOmicronNewDeaths = avgOmicronNewDeaths * 0.75;

A3 = [1 - avgOmicronNewCases,   0.09,                       0,  0;
      avgOmicronNewCases,       0.9                         0,  0;
      0,                        0.01 - avgOmicronNewDeaths, 1,  0;
      0,                        avgOmicronNewDeaths,        0,  1];

Y3 = x3;
for j = 86:105
    x3 = A3 * x3;
    Y3 = [Y3, x3];
end

plot(dates(85:105), Y3(2, :) * 100, 'LineWidth', 2);
plot(dates(85:105), Y3(4, :) * 100, 'LineWidth', 2);
hold off;
axis tight;
ylim([0 inf]);
title(['SIRD Model Fitting via Manual Parameter Tuning (Omicron Phase ' ...
    'w/ Mask Mandate)']);
legend('Infected', 'Deceased', 'Active Cases', 'Total Deaths', ...
    'Infected w/ Mask Mandate', 'Deceased w/ Mask Mandate', ...
     'Location', 'northwest');
xlabel('Date');
ylabel('Percent of Total STL City & County Population');
ytickformat('percentage');
exportgraphics(gca, 'omicron_phase.png');