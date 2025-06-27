% Process data into the format needed

clc, clear, close all

%% Raw data location:

% https://osf.io/z576y/files/osfstorage/6838c51c33f409690b539714 
% (wider project link: https://osf.io/z576y/)

%% Manual steps required:

% - Download data
% - Unzip it
% - Place it in the data/raw/nanoLambda directory 
% (or wherever you like if you're happy to modify the next line)

%% define paths

dataDir = ['..',filesep,'..',filesep,'raw',filesep,'nanoLambda'];
saveDir = ['..',filesep,'..',filesep,'processed',filesep,'nanoLambda'];

if ~exist(saveDir,"dir")
    mkdir(saveDir)
end

% add the nanolambda scripts to the path
addpath(['..',filesep,'..',filesep,'..',filesep,'sussex_nanoLambda',filesep]);

%% Preprocess data

prompt = ['Are you sure you want to run this chunk?', newline...
    'It requires quite a lot of time and computational resources ', newline];
response = input(prompt,"s");

if strcmp(response,'y')

    % the list of paths (within dataDir) to process
    paths = {['TROMSO',filesep,'Autumn'],['TROMSO',filesep,'Spring'],['TROMSO',filesep,'Summer 21'],['TROMSO',filesep,'SUMMER 22'],['TROMSO',filesep,'Winter 21'],['TROMSO',filesep,'Winter 22'],...
        ['OSLO',filesep,'Autumn 21'],['OSLO',filesep,'Spring 22'],['OSLO',filesep,'Summer 21'],['OSLO',filesep,'Summer 22'],['OSLO',filesep,'Winter 21 og 22'],['OSLO',filesep,'WINTER 22']};

    % extract the data from the original csvs and package it into MATLAB files
    % warning: this takes quite a long time to run (~10 mins)
    arc_NLextract(dataDir,saveDir,paths)

    % concatenate the MATLAB files from above into a pair of big csv files
    % (one for spectra, and one for everything else)
    % warning: this takes quite a long time to run (~10 mins)
    arc_NLconcat(saveDir,saveDir)

end

%% Read in preprocessed data

concatNLdata = readtable([saveDir,filesep,'concatNLdata.csv']);
concatSpecArray = readmatrix([saveDir,filesep,'concatSpecArray.csv']);

%% Remove dodgy sensor data

dodgySensor = 'C3:76:CE:37:CF:28';

filterOut = zeros(size(concatNLdata,1),1);
for j = 1:size(concatNLdata,1)
    filterOut(j) = isequal(concatNLdata(j,:).deviceAddress,{dodgySensor});
end

concatNLdata = concatNLdata(~filterOut,:);
concatSpecArray = concatSpecArray([true;~filterOut],:);

%% Compute MB chromaticities

addpath(genpath(['..',filesep,'..',filesep,'..']));
addpath(genpath(['..',filesep,'..',filesep,'..',filesep,'imageanalysis']));

MBarray = NLspd2MB(concatSpecArray);

% Compute cerulean line index
localPaths = getLocalPaths;
data.PP = readtable(localPaths.PPProcessedData);
stdLLM = std([data.PP.MeanLLM],"omitnan");
stdSLM = std([data.PP.MeanSLM],"omitnan");
CL = MacBtoCL(MBarray(:,[1,2])',[stdLLM,stdSLM]);

%% Package neatly

tidyData = NaN(6,size(concatNLdata,1));

tidyData(1:3,:) = MBarray';

% seasonNames = {'Summer','Autumn','Winter','Spring'};
tidyData(4,contains(concatNLdata.file,'Summer','IgnoreCase',true)) = 1;
tidyData(4,contains(concatNLdata.file,'Autumn','IgnoreCase',true)) = 2;
tidyData(4,contains(concatNLdata.file,'Winter','IgnoreCase',true)) = 3;
tidyData(4,contains(concatNLdata.file,'Spring','IgnoreCase',true)) = 4;

tidyData(5,:) = contains(concatNLdata.file,'OSLO','IgnoreCase',true);

tidyData(6,:) = CL;

writematrix(tidyData,[saveDir,filesep,'NL_sub.csv']);
writematrix(concatNLdata.when,[saveDir,filesep,'NL_when.csv'])
