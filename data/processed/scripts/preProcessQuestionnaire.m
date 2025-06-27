% Load the questionnaire data and save it out in a more useable form

clear, clc, close all

repoHomeDir = ['..',filesep,'..',filesep,'..',filesep];
addpath(repoHomeDir);
addpath([repoHomeDir,'arc_PsychophysicsAnalysis',filesep]);

localPaths = getLocalPaths();

%%

dataDir = localPaths.QuestionnaireRawData;
outputDir = ['..',filesep,'..',filesep,'processed',filesep,'questionnaire',filesep];
outputFn = 'arc_SelectQData';

addpath(genpath(['..',filesep,'..',filesep,'..',filesep,'arc_PsychophysicsAnalysis']));

% where are the processed q'aire sheets
% warning: the order matters (the season is hard-coded in
% jm_questionnaire_puller based on the order)
paths = {[dataDir,'Summer 2021',filesep,'summer 21.xlsx'],... %
    [dataDir,'Autumn 2021',filesep,'autumn.xlsx'],... %
    [dataDir,'Winter 2021-22',filesep,'winter 22.xlsx'],...
    [dataDir,'Spring 2022',filesep,'spring.xlsx'],...
    [dataDir,'Summer 2022',filesep,'summer 22.xlsx'],...
    [dataDir,'Winter 2022-23',filesep,'winter 23.xlsx']}; %

columns = {'pcode',...
    'age (years)',...
    'gender recoded',...
    'testing location',...
    'Above or below arctic circle',...
	'which month is your birthday?'};

if ~exist(outputDir,"dir")
    mkdir(outputDir)
end
jm_questionnaire_puller(paths,[outputDir,outputFn,'.csv'],columns)

%% % for generating a "full" csv

% columns = "all";
% jm_questionnaire_puller(paths,[outputDir,outputFn,'_full.csv'],columns)