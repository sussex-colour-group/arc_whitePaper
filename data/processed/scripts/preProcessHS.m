% Process data into the format needed

clc, clear, close all

%% Raw data location:

% TBC, TODO
% (wider project link: https://osf.io/z576y/)

%% Manual steps required:

% - Download data
% - Unzip it
% - Place it in the data/raw/hyperspectral directory (or elsewhere)
% - Modify `getLocalPaths.m` stating where you put it 
% (and where you want the processed files to be saved)

%% define paths

repoHomeDir = ['..',filesep,'..',filesep,'..',filesep];
addpath(repoHomeDir);
addpath([repoHomeDir,'imageanalysis',filesep]);
addpath([repoHomeDir,'hyperspectralAnalysis',filesep]);

localPaths = getLocalPaths();

%% Preprocess data

prompt = ['Are you sure you want to run this chunk?', newline...
    'It requires quite a lot of time and computational resources ', newline];
response = input(prompt,"s");

if strcmp(response,'y')
    
    AnalyseHyperspectral(localPaths.HSRawData,localPaths.HSLMSImages)

end

%% Compute summary stats

% TODO Replace absolute paths
load("/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/whiteResultsTable.mat",'resultsTable'); %psychophysicsData

stdLLM = std([resultsTable.MeanLLM],"omitnan");
stdSLM = std([resultsTable.MeanSLM],"omitnan");

CLfactors = [stdLLM,stdSLM];

computeHS_MB_means(localPaths.HSLMSImages,localPaths.HSProcessedData,CLfactors)



