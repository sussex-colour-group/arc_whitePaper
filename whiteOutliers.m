clear, clc, close all

paths = getLocalPaths;

data.PP = readtable(paths.PPProcessedData);

%%
figure, hold on
histogram([data.PP.stdSLM])
xline(mean([data.PP.stdSLM],"omitnan"),'k','LineWidth',2);
for nSTD = 1:3
    xline(mean([data.PP.stdSLM],"omitnan")...
        + nSTD * std([data.PP.stdSLM],"omitnan"),'r','LineWidth',2);
end
xlabel('SLM std')

figure, hold on
histogram([data.PP.stdLLM])
xline(mean([data.PP.stdLLM],"omitnan"),'k','LineWidth',2);
for nSTD = 1:3
    xline(mean([data.PP.stdLLM],"omitnan")...
        + nSTD * std([data.PP.stdLLM],"omitnan"),'r','LineWidth',2);
end
xlabel('LLM std')

%%

figure, hold on

scatter([data.PP.stdLLM],[data.PP.stdSLM])
xlabel('SLM std')
ylabel('LLM std')

nSTD = 3;
xline(mean([data.PP.stdLLM],"omitnan") +...
    nSTD * std([data.PP.stdLLM],"omitnan"),'r','LineWidth',2);
yline(mean([data.PP.stdSLM],"omitnan") + ...
    nSTD * std([data.PP.stdSLM],"omitnan"),'r','LineWidth',2);

%% Split by location

dataLLM = [data.PP.stdLLM];
dataSLM = [data.PP.stdSLM];
tromsoInd = ~[data.PP.testLocation];

nSTD = 3;

figure, hold on

scatter(dataLLM(tromsoInd),dataSLM(tromsoInd),'b',...
    'DisplayName','Tromso')
xline(mean(dataLLM(tromsoInd),"omitnan") +...
    nSTD * std(dataLLM(tromsoInd),"omitnan"),'b:','LineWidth',2,...
    'HandleVisibility','off');
yline(mean(dataSLM(tromsoInd),"omitnan") + ...
    nSTD * std(dataSLM(tromsoInd),"omitnan"),'b:','LineWidth',2,...
    'HandleVisibility','off');

scatter(dataLLM(~tromsoInd),dataSLM(~tromsoInd),'r',...
    'DisplayName','Olso')
xline(mean(dataLLM(~tromsoInd),"omitnan") +...
    nSTD * std(dataLLM(~tromsoInd),"omitnan"),'r:','LineWidth',2,...
    'HandleVisibility','off');
yline(mean(dataSLM(~tromsoInd),"omitnan") + ...
    nSTD * std(dataSLM(~tromsoInd),"omitnan"),'r:','LineWidth',2,...
    'HandleVisibility','off');

xline(mean([data.PP.stdLLM],"omitnan") +...
    nSTD * std([data.PP.stdLLM],"omitnan"),'k','LineWidth',2,...
    'DisplayName','3std all');
yline(mean([data.PP.stdSLM],"omitnan") + ...
    nSTD * std([data.PP.stdSLM],"omitnan"),'k','LineWidth',2,...
    'HandleVisibility','off');

xlabel('LLM std')
ylabel('SLM std')

legend('Location','northwestoutside')

%% which ppt is above 3SD in both SLM and LLM

nSTD = 3;
LLM_3STD = mean([data.PP.stdLLM],"omitnan") + ...
    nSTD * std([data.PP.stdLLM],"omitnan");

SLM_3STD = mean([data.PP.stdSLM],"omitnan") + ...
    nSTD * std([data.PP.stdSLM],"omitnan");

data.PP.ppt(find([data.PP.stdLLM]>LLM_3STD & [data.PP.stdSLM]>SLM_3STD))

% '036t'

%% scatter the data from that ppt only

figure, hold on
legend('Location','northwestoutside')

load([paths.PPRawData,filesep,'arc_WhiteSettings_036_t.mat'],'output')
settingsLLM = output(:,3);
settingsSLM = output(:,4);
scatter(settingsLLM,settingsSLM,...
    'filled','DisplayName','036t');

% random comparisons
load([paths.PPRawData,filesep,'arc_WhiteSettings_035_t.mat'],'output')
settingsLLM = output(:,3);
settingsSLM = output(:,4);
scatter(settingsLLM,settingsSLM,...
    'filled','DisplayName','035t');

load([paths.PPRawData,filesep,'arc_WhiteSettings_037_t.mat'],'output')
settingsLLM = output(:,3);
settingsSLM = output(:,4);
scatter(settingsLLM,settingsSLM,...
    'filled','DisplayName','037t');

%% Plot trajectories (what was 036_t doing?)

ppts = {'035_t','036_t'};

for i = 1:length(ppts)
    figure, hold on
    load([paths.PPRawData,filesep,'arc_WhiteSettings_',ppts{i},'.mat'],'trajectories')

    for j = 1:length(trajectories)
        plot(trajectories{1,j}(:,1),trajectories{1,j}(:,2))
    end
end

%%

sum(isnan([data.PP.stdLLM]))
data.PP.ppt(find(isnan([data.PP.stdLLM])))

% '057t'
% '160t'

