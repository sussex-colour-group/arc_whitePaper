% Process data into the format needed

clc, clear, close all

%% Raw data location:

% TBC, TODO
% (wider project link: https://osf.io/z576y/)

%% Manual steps required:

% - Download data
% - Unzip it
% - Place it in the data/raw/hyperspectral directory 
% (or wherever you like if you're happy to modify the next line)

%% define paths

dataDir = ['..',filesep,'..',filesep,'raw',filesep,'hyperspectral'];
saveDir = ['..',filesep,'..',filesep,'processed',filesep,'hyperspectral'];

% add the nanolambda scripts to the path
addpath(['..',filesep,'..',filesep,'..',filesep,'imageanalysis',filesep]);
addpath(['..',filesep,'..',filesep,'..',filesep,'hyperspectralAnalysis',filesep]);

%% Preprocess data

% prompt = ['Are you sure you want to run this chunk?', newline...
%     'It requires quite a lot of time and computational resources ', newline];
% response = input(prompt,"s");
% 
% if strcmp(response,'y')

inputDir = '/home/danny/cisc2/projects/colour_arctic/data/Norway Hyperspectral/Hyperspectral';
outputDir = '/home/danny/cisc1/projects/colour_arctic/hyperspectralOutputs';

AnalyseHyperspectral(inputDir,outputDir)

% end

