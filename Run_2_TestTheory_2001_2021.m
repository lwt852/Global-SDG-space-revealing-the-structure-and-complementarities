clear; clc; close all

% 载入数据（之前计算好的）
load("SDG_Results_2001.mat");
load("SDG_Results_2011.mat");
load("SDG_Results_2021.mat");

%换名字省事
Data_Goals_Original_2005=RegionGoals_2001
Data_Goals_Original_2015=RegionGoals_2021
Data_Goals_SDGSpace_2005=Data_Goals_SDGSpace_2001
Net_RCA_2005=Net_RCA_2001
Net_RCA_Weights_2005=Net_RCA_Weights_2001
%% 计算 (stability)
% Goal-level
corr11121_per = (norm(Net_Goal_Correlation_2011-Net_Goal_Correlation_2021))./(norm(Net_Goal_Correlation_2021))
corr0121_per= (norm(Net_Goal_Correlation_2001-Net_Goal_Correlation_2021))./(norm(Net_Goal_Correlation_2021))
rca1121_per= (norm(Net_Goal_ProductSpace_2011-Net_Goal_ProductSpace_2021))./(norm(Net_Goal_ProductSpace_2021))
rca0121_per= (norm(Net_Goal_ProductSpace_2001-Net_Goal_ProductSpace_2021))./(norm(Net_Goal_ProductSpace_2021))

%Goal_level between high-income and low-income countries
corr11121_per_high = (norm(Net_Goal_Correlation_2011_high-Net_Goal_Correlation_2021_high))./(norm(Net_Goal_Correlation_2021_high))
corr0121_per_high= (norm(Net_Goal_Correlation_2001_high-Net_Goal_Correlation_2021_high))./(norm(Net_Goal_Correlation_2021_high))
rca1121_per_high= (norm(Net_Goal_ProductSpace_2011_high-Net_Goal_ProductSpace_2021_high))./(norm(Net_Goal_ProductSpace_2021_high))
rca0121_per_high = (norm(Net_Goal_ProductSpace_2001_high-Net_Goal_ProductSpace_2021_high))./(norm(Net_Goal_ProductSpace_2021_high))

%Goal_level between  low-income countries
corr11121_per_low = (norm(Net_Goal_Correlation_2011_low-Net_Goal_Correlation_2021_low))./(norm(Net_Goal_Correlation_2021_low))
corr0121_per_low= (norm(Net_Goal_Correlation_2001_low-Net_Goal_Correlation_2021_low))./(norm(Net_Goal_Correlation_2021_low))
rca1121_per_low= (norm(Net_Goal_ProductSpace_2011_low-Net_Goal_ProductSpace_2021_low))./(norm(Net_Goal_ProductSpace_2021_low))
rca0121_per_low = (norm(Net_Goal_ProductSpace_2001_low-Net_Goal_ProductSpace_2021_low))./(norm(Net_Goal_ProductSpace_2021_low))

%indicator-level
%corr0111 = norm(Net_Indicator_Correlation_2001-Net_Indicator_Correlation_2011)
%norm_01 = norm(Net_Indicator_Correlation_2001)
% corr11121_per= (norm(Net_Indicator_Correlation_2011-Net_Indicator_Correlation_2021))./(norm(Net_Indicator_Correlation_2021))
% corr0121_per= (norm(Net_Indicator_Correlation_2001-Net_Indicator_Correlation_2021))./(norm(Net_Indicator_Correlation_2021))
% rca1121_per= (norm(Net_Indicator_ProductSpace_2011-Net_Indicator_ProductSpace_2021))./(norm(Net_Indicator_ProductSpace_2021))
% rca0121_per= (norm(Net_Indicator_ProductSpace_2001-Net_Indicator_ProductSpace_2021))./(norm(Net_Indicator_ProductSpace_2021))
%% 计算
% 2005年的SDG增长潜力（根据SDG Space算出的）
Data_Goals_GrowthPotential_2005 = Data_Goals_SDGSpace_2005 - Data_Goals_Original_2005;
% 2005-2015年的SDG实际增长
Data_Goals_Growth_2005_2015 = Data_Goals_Original_2015 - Data_Goals_Original_2005;

% 将各省各SDG矩阵转化成列向量
SDG_GrowthPotential_2005 = Data_Goals_GrowthPotential_2005(:); % 增长潜力
SDG_Level_2005 = Data_Goals_Original_2005(:); % 2005年SDG值
SDG_Growth_2005_2015 = Data_Goals_Growth_2005_2015(:); % 实际增长（2005-2015）

%% 检验"SDG Complementarity Network"的理论：可解释机器学习
% 注：这部分用时较长，如果不画Partial Dependence Plot，可以注释掉

% 建立机器学习模型
%rng default
%Mdl = fitrensemble([SDG_GrowthPotential_2005 SDG_Level_2005],SDG_Growth_2005_2015, ...
%    'OptimizeHyperparameters','auto'); % 自动选择超参数

% 画局部依赖图（Partial Dependence Plot）
f1 = figure;
h1 = plotPartialDependence(Mdl,[1 2], ...
    "UseParallel",true);
h1.XLabel.String = "SDG Growth Potential in 2001";
h1.YLabel.String = "SDG Level in 2001";
h1.ZLabel.String = "SDG Growth from 2001 to 2021";
%h1.Title.String = "Partial Dependence of SDG Growth 2001-2021 " + ...
%    "on Network SDG Growth Potential and SDG Level in 2001";
colormap('cool');
%other colormap choices:jet,hot,gray
c1 = colorbar; % 颜色条
c1.Label.String = 'SDG Score Growth 2001-2021';

%% 检验"SDG Complementarity Network"的理论：散点图
...注：将所有地区的SDG分两部分做散点图和多元线性回归：
...增长潜力较小（小于negtive cutoff）和增长潜力较大（大于positive cutoff）

% Negtive cutoff. For robustness check, please try [-2.5, -5, -15]
Cutoff_GrowthPotential_Neg = 0;
idx_Neg = SDG_GrowthPotential_2005 < Cutoff_GrowthPotential_Neg;
SDG_GrowthPotential_2005_Neg = SDG_GrowthPotential_2005(idx_Neg);
SDG_Level_2005_Neg = SDG_Level_2005(idx_Neg);
SDG_Growth_2005_2015_Neg = SDG_Growth_2005_2015(idx_Neg);
% Posive cutoff. For robustness check, please try [2.5, 5, 15]
Cutoff_GrowthPotential_Pos = 0; 
idx_Pos = SDG_GrowthPotential_2005 > Cutoff_GrowthPotential_Pos;
SDG_GrowthPotential_2005_Pos = SDG_GrowthPotential_2005(idx_Pos);
SDG_Level_2005_Pos = SDG_Level_2005(idx_Pos);
SDG_Growth_2005_2015_Pos = SDG_Growth_2005_2015(idx_Pos);

% 散点图
f2 = figure;
tiledlayout(1,2) % Prepare to draw multiple graphs
YLimit_Scatter = [-40,40]; % Y轴范围

nexttile % 初始年增长潜力较小（小于negtive cutoff）的点
h2 = scatter(SDG_GrowthPotential_2005_Neg,SDG_Growth_2005_2015_Neg,40, ...
    'MarkerEdgeColor',[0 .1 .1], ...
    'MarkerFaceColor',[0 .3 .3], ...
    'LineWidth',1.5);
xlim([-46,Cutoff_GrowthPotential_Neg+1]) % X轴范围
ylim(YLimit_Scatter) % Y轴范围
xlabel("Growth Potential of SDGs in 2001")
ylabel("Growth of SDGs between 2001 and 2021")
h2.MarkerFaceColor = 'b'; % change marker face color to blue
hh2 = lsline; % 加回归线
hh2.Color = 'r';
hh2.LineWidth = 1.7;
hh2.LineStyle = "--";
box on % 加上边框

nexttile % 初始年增长潜力较大（大于positive cutoff）的点
h3 = scatter(SDG_GrowthPotential_2005_Pos,SDG_Growth_2005_2015_Pos,40, ...
    'MarkerEdgeColor',[0 .1 .1], ...
    'MarkerFaceColor',[0 .3 .3], ...
    'LineWidth',1.5);
xlim([Cutoff_GrowthPotential_Pos-0.75,30]) % X轴范围
ylim(YLimit_Scatter) % Y轴范围
xlabel("Growth Potential of SDGs in 2001")
h3.MarkerFaceColor = 'b'; % change marker face color to blue
% ylabel("Growth of SDGs between 2005 and 2015")
hh3 = lsline; % 加回归线
hh3.Color = 'r';
hh3.LineWidth = 1.7;
hh3.LineStyle = "--";
box on % 加上边框

%% 检验"SDG Complementarity Network"的理论：多元线性回归
% SDG_GrowthPotential_2005_Neg为负值时，预测SDG_Growth_2005_2015的多元线性回归模型
LinearModel_Neg = fitlm([SDG_GrowthPotential_2005_Neg SDG_Level_2005_Neg],SDG_Growth_2005_2015_Neg);
% SDG_GrowthPotential_2005_Pos为正值时，预测SDG_Growth_2005_2015的多元线性回归模型
LinearModel_Pos = fitlm([SDG_GrowthPotential_2005_Pos SDG_Level_2005_Pos],SDG_Growth_2005_2015_Pos);

LinearModel = fitlm([SDG_GrowthPotential_2005 SDG_Level_2005],SDG_Growth_2005_2015);

% 展示模型结果
fprintf('———————————————————————————————————————————————————————————————————\n') % 空行
disp("For SDGs with negative network growth potentials in 2005:")
disp(LinearModel_Neg)
fprintf('\n') % 空行
fprintf('———————————————————————————————————————————————————————————————————\n') % 空行
disp("For SDGs with positive network growth potentials in 2005:")
disp(LinearModel_Pos) 

fprintf('———————————————————————————————————————————————————————————————————\n') % 空行
disp("For SDGs with  network growth potentials in 2005:")
disp(LinearModel) 