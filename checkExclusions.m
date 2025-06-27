%% Check exclusions

clear, clc, close all

excludeRecentTravellers = false;
excludedPpts = getExclusions(excludeRecentTravellers);


%%

paths = getLocalPaths;

%%

data.PP = readtable(paths.PPProcessedData);
% data.PP = transformPPData(data.PP);

%% 

excludedInd = ismember(data.PP.ppt,excludedPpts)';

%%
figure, hold on

scatter([data.PP.MeanLLM(~excludedInd)],...
    [data.PP.MeanSLM(~excludedInd)],'k');

scatter([data.PP.MeanLLM(excludedInd)],...
    [data.PP.MeanSLM(excludedInd)],'rs','filled');

xlabel('LLM')
ylabel('SLM')

%%

meta.pltCols = {'r','b'};

figure, hold on

location  = [data.PP.testLocation]';

scatter([data.PP.MeanLLM(~excludedInd & location)],...
    [data.PP.MeanSLM(~excludedInd & location)],meta.pltCols{1});

scatter([data.PP.MeanLLM(excludedInd & location)],...
    [data.PP.MeanSLM(excludedInd & location)],meta.pltCols{1},'filled');

scatter([data.PP.MeanLLM(~excludedInd & ~location)],...
    [data.PP.MeanSLM(~excludedInd & ~location)],meta.pltCols{2});

scatter([data.PP.MeanLLM(excludedInd & ~location)],...
    [data.PP.MeanSLM(excludedInd & ~location)],meta.pltCols{2},'filled');

xlabel('LLM')
ylabel('SLM')


