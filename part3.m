% Part III: The Effects of Travel

load('COVID_STL.mat');

% SIRD w/ input (open system)
% population 1 = STL (given data)
% population 2 = fictional/hypothesized/arbitrary data

% STL's initial conditions
d = deaths_STL(1) / POP_STL;
r = 0;
i = cases_STL(1) / POP_STL - d;
s = 1 - i - d;
x = [s, i, r, d]';

% simulate all 157 weeks but w/ input
activeCases = [];
newCases = [];
newDeaths = [];
% same assumptions as part2.m
for j = 1:length(cases_STL) - 1
    newCases = [newCases, cases_STL(j + 1) - cases_STL(j)];
    if j == 1
        activeCases = [activeCases, cases_STL(j + 1) - cases_STL(j)];
    else
        activeCases = [activeCases, cases_STL(j + 1) - cases_STL(j) + ...
            round(activeCases(j - 1) * 9 / 10)];
    end
    newDeaths = [newDeaths, deaths_STL(j + 1) - deaths_STL(j)];
end

avgTotalNewCases = mean(newCases) / ...
    (POP_STL - mean(cases_STL) + mean(activeCases));
totalNewDeaths = [];
for j = 1:length(deaths_STL) - 1
    totalNewDeaths = [totalNewDeaths, newDeaths(j) / activeCases(j)];
end
avgTotalNewDeaths = mean(totalNewDeaths);

% STL's dynamics matrix
A = [1 - avgTotalNewCases,  0.09,                       0,  0;
     avgTotalNewCases,      0.9                         0,  0;
     0,                     0.01 - avgTotalNewDeaths,   1,  0;
     0,                     avgTotalNewDeaths,          0,  1];

% other location's initial conditions
u = [1, 0, 0, 0]';

% other location's dynamics matrix (input for STL)
B = [0.97,  0.01,   0,  0;
     0.03,  0.95,   0,  0;
     0,     0.035,  1,  0;
     0,     0.005,  0,  1];

Y = x;
for j = 2:length(newCases)
    x = A * x + B * u;
    Y = [Y, x];
end