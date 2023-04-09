%% Load data
clear; clc
% Load data from CSV file into a table
Table_Goals_All = readtable('global_goals01_21.csv');
Table_Indicators_All = readtable('global_indicators01_21.csv');
Table_Indicators_codebook = readtable('indicator_codebook.csv')

clc % Keep silent

% Get the table of regions
Table_Regions = table(Table_Indicators_All.country, ...
    Table_Indicators_All.Country, Table_Indicators_All.Region, ...
    'VariableNames', {'country', 'Country', 'Region'});
% Remove duplicate rows while keeping the original order
Table_Regions = unique(Table_Regions, 'rows', 'stable');

% Get the number of regions
n_Regions = height(Table_Regions);

IndicatorName = Table_Indicators_codebook.IndCode;
IndicatorName = string(IndicatorName);

% Get the table of indicators
Table_Indicators = table(IndicatorName, ...
    Table_Indicators_codebook.Indicator, Table_Indicators_codebook.Description, ...
    'VariableNames', {'Goal_Indicator', 'indicator_name', 'description'});

% Save
save('Data_Main.mat', 'Table_Goals_All', 'Table_Indicators_All', ...
    'Table_Regions', 'n_Regions','Table_Indicators');

%% Get Names of the indicators
IndicatorNames = Table_Indicators_All.Properties.VariableNames(7:101);
IndicatorNames = string(IndicatorNames)';
% Define the pattern to search for, in this case, "n_sdg" followed by digits
pattern = 'n_sdg(\d+)';
% Extract the numbers that appear after "n_sdg" in each string using regexp
SDGnumbers = regexp(IndicatorNames, pattern, 'tokens');
% Convert the cell array of cell arrays to a simple cell array
SDGnumbers = [SDGnumbers{:}]';
% Convert the cell array of characters to a numeric array
SDGnumbers = cellfun(@str2double, SDGnumbers);
% Initialize output string array
SDGindicators = strings(size(IndicatorNames));
% Loop over input array and extract last string after "_"
for i = 1:numel(IndicatorNames)
    splitString = strsplit(IndicatorNames(i), '_');
    SDGindicators(i) = splitString(end);
end
% Remove "n_sdg" from each string
SDGnumindicators = erase(IndicatorNames, 'n_');
% FINNALLY, create a table for indicator names
Table_IndicatorNames = table(SDGnumbers, SDGindicators, SDGnumindicators, IndicatorNames, ...
    'VariableNames', {'Goal', 'Indicator', 'Goal_Indicator', 'full'});
clear SDGnumbers SDGindicators SDGnumindicators IndicatorNames IndicatorNames i

Table_indicatorFull=join(Table_IndicatorNames,Table_Indicators,'keys','Goal_Indicator')

% Export table to Excel file
writetable(Table_indicatorFull, 'Table_IndicatorFull.csv');

%% Get the 2021 data
% Get the 2021 data table
Table_Goals_2021 = Table_Goals_All(Table_Goals_All.year==2021,:);
Table_Indicators_2021 = Table_Indicators_All(Table_Indicators_All.year==2021,:);
% Check if the country order is correct for the table we just got
is_equal_Table_Goals = strcmp(Table_Regions.country, Table_Goals_2021.country);
is_equal_Table_Indicators = strcmp(Table_Regions.country, Table_Indicators_2021.country);
if min([min(is_equal_Table_Goals), min(is_equal_Table_Indicators)]) ~= 1 % Wrong
    disp("Country order is wrong. Check!")
end

% Get the 2021 data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2021 = Table_Goals_2021(:,8:end); % For goals
RegionIndicators_2021 = Table_Indicators_2021(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2021 = table2array(RegionGoals_2021);
RegionIndicators_2021 = table2array(RegionIndicators_2021);

%% Get the 2021 data for high income and low income countries

%for high income and low income countries
Table_Goals_2021_high = Table_Goals_2021(strcmp(Table_Goals_2021.IncomeGroup, 'HIC'),:);
Table_Indicators_2021_high = Table_Indicators_2021(strcmp(Table_Indicators_2021.IncomeGroup,'HIC'),:);

Table_Goals_2021_low = Table_Goals_2021(strcmp(Table_Goals_2021.IncomeGroup, 'LIC'),:);
Table_Indicators_2021_low = Table_Indicators_2021(strcmp(Table_Indicators_2021.IncomeGroup,'LIC'),:);

% Get the high-income data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2021_high = Table_Goals_2021_high(:,8:end); % For goals
RegionIndicators_2021_high = Table_Indicators_2021_high(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2021_high = table2array(RegionGoals_2021_high);
RegionIndicators_2021_high = table2array(RegionIndicators_2021_high);

% Get the low_income data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2021_low = Table_Goals_2021_low(:,8:end); % For goals
RegionIndicators_2021_low = Table_Indicators_2021_low(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2021_low = table2array(RegionGoals_2021_low);
RegionIndicators_2021_low = table2array(RegionIndicators_2021_low);
%% Get the 2011 data
% Get the 2001 data table
Table_Goals_2011 = Table_Goals_All(Table_Goals_All.year==2011,:);
Table_Indicators_2011 = Table_Indicators_All(Table_Indicators_All.year==2011,:);
% Check if the country order is correct for the table we just got
is_equal_Table_Goals = strcmp(Table_Regions.country, Table_Goals_2011.country);
is_equal_Table_Indicators = strcmp(Table_Regions.country, Table_Indicators_2011.country);
if min([min(is_equal_Table_Goals), min(is_equal_Table_Indicators)]) ~= 1 % Wrong
    disp("Country order is wrong. Check!")
end

% Get the 2011 data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2011 = Table_Goals_2011(:,8:end); % For goals
RegionIndicators_2011 = Table_Indicators_2011(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2011 = table2array(RegionGoals_2011);
RegionIndicators_2011 = table2array(RegionIndicators_2011);

%% Get the 2011 data for high income and low income countries

%for high income and low income countries
Table_Goals_2011_high = Table_Goals_2011(strcmp(Table_Goals_2011.IncomeGroup, 'HIC'),:);
Table_Indicators_2011_high = Table_Indicators_2011(strcmp(Table_Indicators_2011.IncomeGroup,'HIC'),:);

Table_Goals_2011_low = Table_Goals_2011(strcmp(Table_Goals_2011.IncomeGroup, 'LIC'),:);
Table_Indicators_2011_low = Table_Indicators_2011(strcmp(Table_Indicators_2011.IncomeGroup,'LIC'),:);

% Get the high-income data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2011_high = Table_Goals_2011_high(:,8:end); % For goals
RegionIndicators_2011_high = Table_Indicators_2011_high(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2011_high = table2array(RegionGoals_2011_high);
RegionIndicators_2011_high = table2array(RegionIndicators_2011_high);

% Get the low_income data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2011_low = Table_Goals_2011_low(:,8:end); % For goals
RegionIndicators_2011_low = Table_Indicators_2011_low(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2011_low = table2array(RegionGoals_2011_low);
RegionIndicators_2011_low = table2array(RegionIndicators_2011_low);
%% Get the 2001 data
% Get the 2001 data table
Table_Goals_2001 = Table_Goals_All(Table_Goals_All.year==2001,:);
Table_Indicators_2001 = Table_Indicators_All(Table_Indicators_All.year==2001,:);
% Check if the country order is correct for the table we just got
is_equal_Table_Goals = strcmp(Table_Regions.country, Table_Goals_2001.country);
is_equal_Table_Indicators = strcmp(Table_Regions.country, Table_Indicators_2001.country);
if min([min(is_equal_Table_Goals), min(is_equal_Table_Indicators)]) ~= 1 % Wrong
    disp("Country order is wrong. Check!")
end

% Get the 2001 data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2001 = Table_Goals_2001(:,8:end); % For goals
RegionIndicators_2001 = Table_Indicators_2001(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2001 = table2array(RegionGoals_2001);
RegionIndicators_2001 = table2array(RegionIndicators_2001);

%% Get the 2001 data for high income and low income countries

%for high income and low income countries
Table_Goals_2001_high = Table_Goals_2001(strcmp(Table_Goals_2001.IncomeGroup, 'HIC'),:);
Table_Indicators_2001_high = Table_Indicators_2001(strcmp(Table_Indicators_2001.IncomeGroup,'HIC'),:);

Table_Goals_2001_low = Table_Goals_2001(strcmp(Table_Goals_2001.IncomeGroup, 'LIC'),:);
Table_Indicators_2001_low = Table_Indicators_2001(strcmp(Table_Indicators_2001.IncomeGroup,'LIC'),:);

% Get the high-income data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2001_high = Table_Goals_2001_high(:,8:end); % For goals
RegionIndicators_2001_high = Table_Indicators_2001_high(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2001_high = table2array(RegionGoals_2001_high);
RegionIndicators_2001_high = table2array(RegionIndicators_2001_high);

% Get the low_income data matrix to feed into the function 
% Each column is a goal or indicator
% Each row is a country
RegionGoals_2001_low = Table_Goals_2001_low(:,8:end); % For goals
RegionIndicators_2001_low = Table_Indicators_2001_low(:,7:end); % For indicators
% Convert table to matrix
RegionGoals_2001_low = table2array(RegionGoals_2001_low);
RegionIndicators_2001_low = table2array(RegionIndicators_2001_low);
%% Calculate the SDG space network! 2021
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2021 = NetworkSpace(RegionGoals_2021,'Product Space');
Net_Indicator_ProductSpace_2021 = NetworkSpace(RegionIndicators_2021,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2021 = NetworkSpace(RegionGoals_2021,'Correlation');
Net_Indicator_Correlation_2021 = NetworkSpace(RegionIndicators_2021,'Correlation');

% Save the above variables
writematrix(Net_Goal_ProductSpace_2021, "Net_Goal_ProductSpace_2021.csv");
writematrix(Net_Indicator_ProductSpace_2021, "Net_Indicator_ProductSpace_2021.csv");
writematrix(Net_Goal_Correlation_2021, "Net_Goal_Correlation_2021.csv");
writematrix(Net_Indicator_Correlation_2021, "Net_Indicator_Correlation_2021.csv");

%% Calculate the SDG space network! 2021 high income countries
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2021_high = NetworkSpace(RegionGoals_2021_high,'Product Space');
Net_Indicator_ProductSpace_2021_high = NetworkSpace(RegionIndicators_2021_high,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2021_high = NetworkSpace(RegionGoals_2021_high,'Correlation');
Net_Indicator_Correlation_2021_high = NetworkSpace(RegionIndicators_2021_high,'Correlation');

%% Calculate the SDG space network! 2021 low income countries
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2021_low = NetworkSpace(RegionGoals_2021_low,'Product Space');
Net_Indicator_ProductSpace_2021_low = NetworkSpace(RegionIndicators_2021_low,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2021_low = NetworkSpace(RegionGoals_2021_low,'Correlation');
Net_Indicator_Correlation_2021_low = NetworkSpace(RegionIndicators_2021_low,'Correlation');

%% Calculate the SDG space network! 2001 
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2001 = NetworkSpace(RegionGoals_2001,'Product Space');
Net_Indicator_ProductSpace_2001 = NetworkSpace(RegionIndicators_2001,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2001 = NetworkSpace(RegionGoals_2001,'Correlation');
Net_Indicator_Correlation_2001 = NetworkSpace(RegionIndicators_2001,'Correlation');

% Save the above variables
writematrix(Net_Goal_ProductSpace_2001, "Net_Goal_ProductSpace_2001.csv");
writematrix(Net_Indicator_ProductSpace_2001, "Net_Indicator_ProductSpace_2001.csv");
writematrix(Net_Goal_Correlation_2001, "Net_Goal_Correlation_2001.csv");
writematrix(Net_Indicator_Correlation_2001, "Net_Indicator_Correlation_2001.csv");

%% Calculate the SDG space network! 2001 high income countries
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2001_high = NetworkSpace(RegionGoals_2001_high,'Product Space');
Net_Indicator_ProductSpace_2001_high = NetworkSpace(RegionIndicators_2001_high,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2001_high = NetworkSpace(RegionGoals_2001_high,'Correlation');
Net_Indicator_Correlation_2001_high = NetworkSpace(RegionIndicators_2001_high,'Correlation');

%% Calculate the SDG space network! 2001 low income countries
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2001_low = NetworkSpace(RegionGoals_2001_low,'Product Space');
Net_Indicator_ProductSpace_2001_low = NetworkSpace(RegionIndicators_2001_low,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2001_low = NetworkSpace(RegionGoals_2001_low,'Correlation');
Net_Indicator_Correlation_2001_low = NetworkSpace(RegionIndicators_2001_low,'Correlation');
%% Calculate the SDG space network! 2011
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2011 = NetworkSpace(RegionGoals_2011,'Product Space');
Net_Indicator_ProductSpace_2011 = NetworkSpace(RegionIndicators_2011,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2011 = NetworkSpace(RegionGoals_2011,'Correlation');
Net_Indicator_Correlation_2011 = NetworkSpace(RegionIndicators_2011,'Correlation');

%% Calculate the SDG space network! 2011 high and low income countries
% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2011_high = NetworkSpace(RegionGoals_2011_high,'Product Space');
Net_Indicator_ProductSpace_2011_high = NetworkSpace(RegionIndicators_2011_high,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2011_high = NetworkSpace(RegionGoals_2011_high,'Correlation');
Net_Indicator_Correlation_2011_high = NetworkSpace(RegionIndicators_2011_high,'Correlation');

% Here we could have missing data, but the function can do it!
Net_Goal_ProductSpace_2011_low = NetworkSpace(RegionGoals_2011_low,'Product Space');
Net_Indicator_ProductSpace_2011_low = NetworkSpace(RegionIndicators_2011_low,'Product Space');

% Calculate the correlation network, for possible comparison
Net_Goal_Correlation_2011_low = NetworkSpace(RegionGoals_2011_low,'Correlation');
Net_Indicator_Correlation_2011_low = NetworkSpace(RegionIndicators_2011_low,'Correlation');

%% 计算初始年（2001年）的网络密度（新内容）
Cutoff_Net = 0.45; % Network cutoff. 可以根据文章内容改变
Net_RCA_2001 = Net_Goal_ProductSpace_2001
Net_RCA_2001(Net_RCA_2001<Cutoff_Net) = 0;
Net_RCA_Weights_2001 = Net_RCA_2001 / diag( sum(Net_RCA_2001) );
% 对于每个地区每个Goal，计算网络中相连Goal的加权平均
Data_Goals_SDGSpace_2001 = RegionGoals_2001 * Net_RCA_Weights_2001;

% Save into mat
save("SDG_Results_2001.mat","RegionGoals_2001", "Data_Goals_SDGSpace_2001","Net_Indicator_Correlation_2001","Net_Indicator_ProductSpace_2001", ...
    "Net_Goal_Correlation_2001","Net_Goal_ProductSpace_2001","Net_RCA_2001", "Net_RCA_Weights_2001","Net_Goal_Correlation_2001_high",...
    "Net_Goal_ProductSpace_2001_high","Net_Goal_Correlation_2001_low","Net_Goal_ProductSpace_2001_low") 
save("SDG_Results_2021.mat","RegionGoals_2021","Net_Indicator_Correlation_2021","Net_Indicator_ProductSpace_2021","Net_Goal_Correlation_2021",...
    "Net_Goal_ProductSpace_2021","Net_Goal_Correlation_2021_high","Net_Goal_ProductSpace_2021_high",...
    "Net_Goal_Correlation_2021_low","Net_Goal_ProductSpace_2021_low")  
save("SDG_Results_2011.mat","RegionGoals_2011","Net_Indicator_Correlation_2011","Net_Indicator_ProductSpace_2011","Net_Goal_Correlation_2011",...
    "Net_Goal_ProductSpace_2011","Net_Goal_Correlation_2011_high","Net_Goal_ProductSpace_2011_high",...
    "Net_Goal_Correlation_2011_low","Net_Goal_ProductSpace_2011_low")  
%% Further analysis
% 看一个国家某年的SDG和Indicator
country = {'USA'};
year = 2021;
% Extract data
Concerned_Goal = ... 
    Table_Goals_All(strcmp(Table_Goals_All.country,country) & Table_Goals_All.year==year, :);
Concerned_Indicator = ... 
    Table_Indicators_All(strcmp(Table_Indicators_All.country,country) & Table_Indicators_All.year==year, :);






















