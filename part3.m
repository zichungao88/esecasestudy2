% Part III: The Effects of Travel

load('COVID_STL.mat');
realDates = dates;
load('COVIDbyCounty.mat');

% population 1 = St. Louis City + County (given data)
% population 2 = Riverside County, CA (taken from Case Study 1)

% simulate 156 weeks (omit the first two weeks b/c COVIDbyCounty.mat from
% Case Study 1 contains 156 instead of 158 weeks)
cases_STL = cases_STL(3:158);
deaths_STL = deaths_STL(3:158);
POP_RVS = CNTY_CENSUS.POPESTIMATE2021(23);
% calculate raw data from given normalized data
cases_RVS = round(CNTY_COVID(23, :) * POP_RVS / 100000);

d1 = deaths_STL(1) / POP_STL;
r1 = 0;
i1 = cases_STL(1) / POP_STL - d1;
s1 = 1 - i1 - d1;
d2 = 0; % assume no initial deaths since no relevant data is given
r2 = 0;
i2 = cases_RVS(1) / POP_RVS;
s2 = 1 - i2;
x = [s1, i1, r1, d1, s2, i2, r2, d2]';
x1 = x(1:4);
x2 = x(5:8);

activeCases1 = [];
newCases1 = [];
newDeaths1 = [];
% same assumptions for STL as part2.m
for j = 1:length(cases_STL) - 1
    newCases1 = [newCases1, cases_STL(j + 1) - cases_STL(j)];
    if j == 1
        activeCases1 = [activeCases1, cases_STL(j + 1) - cases_STL(j)];
    else
        activeCases1 = [activeCases1, cases_STL(j + 1) - cases_STL(j) ...
            + round(activeCases1(j - 1) * 9 / 10)];
    end
    newDeaths1 = [newDeaths1, deaths_STL(j + 1) - deaths_STL(j)];
end
avgTotalNewCases1 = mean(newCases1) / (POP_STL - mean(cases_STL) + ...
    mean(activeCases1));
totalNewDeaths1 = [];
for j = 1:length(deaths_STL) - 1
    totalNewDeaths1 = [totalNewDeaths1, newDeaths1(j) / activeCases1(j)];
end
avgTotalNewDeaths1 = mean(totalNewDeaths1);

activeCases2 = [];
newCases2 = cases_RVS(1:length(cases_RVS) - 1);
for j = 1:length(cases_RVS) - 1
    if j == 1
        activeCases2 = [activeCases2, newCases2(j)];
    else
        activeCases2 = [activeCases2, newCases2(j) + ...
            round(activeCases2(j - 1) * 9 / 10)];
    end
end
cumulativeCases2 = [];
total = 0;
for j = 1:length(cases_RVS)
    total = total + cases_RVS(j);
    cumulativeCases2 = [cumulativeCases2, total];
end
avgTotalNewCases2 = mean(newCases2) / (POP_RVS - ...
    mean(cumulativeCases2) + mean(activeCases2));

% STL matrix
A = [1 - avgTotalNewCases1,     0.09,                           0,  0;
     avgTotalNewCases1,         0.9,                            0,  0;
     0,                         0.01 - avgTotalNewDeaths1,      1,  0;
     0,                         avgTotalNewDeaths1,             0,  1];

% RVS to STL matrix
B = [0.95,                      0.03,                           0,  0;
     0.05,                      0.95,                           0,  0;
     0,                         0.01,                           1,  0;
     0,                         0.01,                           0,  1];

% STL to RVS matrix
C = [0.97,                      0.01,                           0,  0;
     0.03,                      0.98,                           0,  0;
     0,                         0.005,                          1,  0;
     0,                         0.005,                          0,  1];

% RVS matrix
D = [1 - avgTotalNewCases2,     0.1,                            0,  0;
     avgTotalNewCases2,         0.8,                            0,  0;
     0,                         0.095,                          1,  0;
     0,                         0.005,                          0,  1];

E = [A, B; C, D];

Y = x;
Y1 = x1;
Y2 = x2;
for j = 2:length(dates) - 1
    x = (E * x) / 2; % w/ traveling
    Y = [Y, x];
    x1 = A * x1; % STL w/o traveling
    Y1 = [Y1, x1];
    x2 = D * x2; % RVS w/o traveling
    Y2 = [Y2, x2];
end

hold on;
plot(dates(1:length(dates) - 1), Y1(2, :) * 100, 'LineWidth', 2);
plot(dates(1:length(dates) - 1), Y(2, :) * 100, 'LineWidth', 2);
hold off;
axis tight;
ylim([0 inf]);
title('Effects of Travel on St. Louis City & County, MO');
legend('Active Cases w/o Traveling', 'Active Cases w/ Traveling');
xlabel('Date');
ylabel('Percent of Total STL City + County Population');
ytickformat('percentage');
exportgraphics(gca, 'travel_STL.png');

figure;
hold on;
plot(dates(1:length(dates) - 1), Y2(2, :) * 100, 'LineWidth', 2);
plot(dates(1:length(dates) - 1), Y(6, :) * 100, 'LineWidth', 2);
hold off;
axis tight;
ylim([0 inf]);
title('Effects of Travel on Riverside County, CA');
legend('Active Cases w/o Traveling', 'Active Cases w/ Traveling');
xlabel('Date');
ylabel('Percent of Total Riverside County Population');
ytickformat('percentage');
exportgraphics(gca, 'travel_RVS.png');

%%
% what-if policy on travel restrictions implemented during a surge of new
% cases in the initial phase (week 36) and continue throughout the end of
% the Omicron phase (week 105)

% two regions: same as above (STL & RVS)
% two phases: same as part2.m (Delta & Omicron)

% pre-policy phase: 3/18/2020 ~ 11/17/2020

avgPreNewCases1 = mean(newCases1(1:35)) / (POP_STL - ...
    mean(cases_STL(1:35)) + mean(activeCases1(1:35)));
preNewDeaths1 = [];
for j = 1:35
    preNewDeaths1 = [preNewDeaths1, newDeaths1(j) / activeCases1(j)];
end
avgPreNewDeaths1 = mean(preNewDeaths1);

preActiveCases2 = [];
preNewCases2 = cases_RVS(1:35);
for j = 1:35
    if j == 1
        preActiveCases2 = [preActiveCases2, preNewCases2(j)];
    else
        preActiveCases2 = [preActiveCases2, preNewCases2(j) + ...
            round(preActiveCases2(j - 1) * 9 / 10)];
    end
end
avgPreNewCases2 = mean(preNewCases2) / (POP_RVS - ...
    mean(cumulativeCases2(1:35)) + mean(preActiveCases2));

Y = x;
for j = 2:35
    x = (E * x) / 2;
    Y = [Y, x];
end

%%
% first post-policy phase: 11/18/2020 ~ 6/29/2021

avgPostNewCases1 = mean(newCases1(35:67)) / (POP_STL - ...
    mean(cases_STL(35:67)) + mean(activeCases1(35:67)));
postNewDeaths1 = [];
for j = 35:67
    postNewDeaths1 = [postNewDeaths1, newDeaths1(j) / activeCases1(j)];
end
avgPostNewDeaths1 = mean(postNewDeaths1);

postActiveCases2 = [];
postNewCases2 = cases_RVS(35:67);
for j = 1:33
    if j == 1
        postActiveCases2 = [postActiveCases2, postNewCases2(j)];
    else
        postActiveCases2 = [postActiveCases2, postNewCases2(j) + ...
            round(postActiveCases2(j - 1) * 9 / 10)];
    end
end
avgPostNewCases2 = mean(postNewCases2) / (POP_RVS - ...
    mean(cumulativeCases2(35:67)) + mean(postActiveCases2));

%%
% delta phase: 6/30/2021 ~ 10/26/2021

avgDeltaNewCases1 = mean(newCases1(68:84)) / (POP_STL - ...
    mean(cases_STL(68:84)) + mean(activeCases1(68:84)));
deltaNewDeaths1 = [];
for j = 68:84
    deltaNewDeaths1 = [deltaNewDeaths1, newDeaths1(j) / activeCases1(j)];
end
avgDeltaNewDeaths1 = mean(deltaNewDeaths1);

deltaActiveCases2 = [];
deltaNewCases2 = cases_RVS(68:84);
for j = 1:17
    if j == 1
        deltaActiveCases2 = [deltaActiveCases2, deltaNewCases2(j)];
    else
        deltaActiveCases2 = [deltaActiveCases2, deltaNewCases2(j) + ...
            round(deltaActiveCases2(j - 1) * 9 / 10)];
    end
end
avgDeltaNewCases2 = mean(deltaNewCases2) / (POP_RVS - ...
    mean(cumulativeCases2(68:84)) + mean(deltaActiveCases2));

%%
% omicron phase: 10/27/2021 ~ 3/22/2022

avgOmicronNewCases1 = mean(newCases1(85:105)) / (POP_STL - ...
    mean(cases_STL(85:105)) + mean(activeCases1(85:105)));
omicronNewDeaths1 = [];
for j = 85:105
    omicronNewDeaths1 = [omicronNewDeaths1, newDeaths1(j) / ...
        activeCases1(j)];
end
avgDeltaNewDeaths1 = mean(omicronNewDeaths1);

omicronActiveCases2 = [];
omicronNewCases2 = cases_RVS(85:105);
for j = 1:21
    if j == 1
        omicronActiveCases2 = [omicronActiveCases2, omicronNewCases2(j)];
    else
        omicronActiveCases2 = [omicronActiveCases2, ...
            omicronNewCases2(j) + round(omicronActiveCases2(j - 1) ...
            * 9 / 10)];
    end
end
avgOmicronNewCases2 = mean(omicronNewCases2) / (POP_RVS - ...
    mean(cumulativeCases2(85:105)) + mean(omicronActiveCases2));