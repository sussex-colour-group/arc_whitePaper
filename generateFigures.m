clear, clc, close all

% figure meta
meta.figSize = [100,100,1000,500]; % first two values are location, second two are size
meta.edges = {linspace(0.66,0.82,40) linspace(0,2,40)};

% data meta
meta.seasonNames = {'Summer','Autumn','Winter','Spring'};
meta.locationNames = {'Tromso','Oslo'};

%% Data and save locations

paths = getLocalPaths;

%% 2D histogram plots, split by location and season

meta.figType = "grayscale"; % "grayscale" or "colour"

% Load data

data = load(paths.NLProcessedData,'MBarray_concat'); % order: LLM, SLM, L+M, season, location, CL (`sussex_nanolambda/arc_plotMB.m`)
data = data.MBarray_concat;

arc_2Dhist(data,meta);







