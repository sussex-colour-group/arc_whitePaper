%% Check exclusions

clear, clc, close all

excludedPpts = {'027o','050o','080o','090o','105o','106o','117o','118o','129o',...
    '155o','158o','028t','083t','093t','150t'};

%%

paths = getLocalPaths;

%%

data.PP = load(paths.PPProcessedData);
% data.PP = transformPPData(data.PP.resultsTable);

%% 

excludedInd = false(size(data.PP.resultsTable,2),1);
for i = 1:size(data.PP.resultsTable,2)
    for j = 1:length(excludedPpts)
        if isequal(data.PP.resultsTable(i).ppt, excludedPpts{j})
            excludedInd(i) = true;
        end
    end
end

%%
figure, hold on

scatter([data.PP.resultsTable(~excludedInd).MeanLLM],...
    [data.PP.resultsTable(~excludedInd).MeanSLM],'k');

scatter([data.PP.resultsTable(excludedInd).MeanLLM],...
    [data.PP.resultsTable(excludedInd).MeanSLM],'rs','filled');

xlabel('LLM')
ylabel('SLM')

%%

meta.pltCols = {'r','b'};

figure, hold on

location  = [data.PP.resultsTable.testLocation]';

scatter([data.PP.resultsTable(~excludedInd & location).MeanLLM],...
    [data.PP.resultsTable(~excludedInd & location).MeanSLM],meta.pltCols{1});

scatter([data.PP.resultsTable(excludedInd & location).MeanLLM],...
    [data.PP.resultsTable(excludedInd & location).MeanSLM],meta.pltCols{1},'filled');

scatter([data.PP.resultsTable(~excludedInd & ~location).MeanLLM],...
    [data.PP.resultsTable(~excludedInd & ~location).MeanSLM],meta.pltCols{2});

scatter([data.PP.resultsTable(excludedInd & ~location).MeanLLM],...
    [data.PP.resultsTable(excludedInd & ~location).MeanSLM],meta.pltCols{2},'filled');

xlabel('LLM')
ylabel('SLM')


