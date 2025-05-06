clear, clc, close all

% figure meta
meta.figSize = [100,100,1000,500]; % first two values are location, second two are size
meta.edges = {linspace(0.66,0.82,40) linspace(0,2,40)};

% data meta
meta.seasonNames = {'Summer','Autumn','Winter','Spring'};
meta.locationNames = {'Tromso','Oslo'};

%% Data and save locations

% It is expected that each user will have a different set of paths where
% data is saved. To avoid polluting the git history with back and forth
% edits, we use a function called `getLocalPaths` where a user's local
% paths are saved.
% Each user will need to populate their own.
% An empty version is provided in the comments below.
% `getLocalPaths` is in the `.gitignore` file so it won't be committed.

paths = getLocalPaths;

% function localPaths = getLocalPaths
% 
% localPaths.GoProRawData = "";
% localPaths.GoProProcessedData = "";
% 
% localPaths.NLRawData = "";
% localPaths.NLProcessedData = "";
% 
% localPaths.HSRawData = "";
% localPaths.HSProcessedData = "";
% 
% localPaths.saveLocation = "";
% 
% end

%% 2D histogram plots, split by location and season

meta.figType = "grayscale"; % "grayscale" or "colour"

% Load data

data = load(paths.NLProcessedData,'MBarray_concat'); % order: LLM, SLM, L+M, season, location, CL (`sussex_nanolambda/arc_plotMB.m`)
data = data.MBarray_concat;

arc_2Dhist(data,meta);







