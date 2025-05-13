clear, clc, close all

% figure meta
meta.figSize = [100,100,1000,500]; % first two values are location, second two are size
meta.fontSize.big   = 15;
meta.fontSize.small = 10;
meta.edges = {linspace(0.66,0.82,40) linspace(0,2,40)};
meta.edgesZoomedIn = {linspace(0.68,0.705,40) linspace(1,1.3,40)};
meta.pltCols = {'r','b'};

saveLocation = ['.',filesep,'figs',filesep];

% data meta
meta.seasonNames = {'Summer','Autumn','Winter','Spring'};
meta.locationNames = {'Tromso','Oslo'};

%% Data and save locations

paths = getLocalPaths;
addpath(genpath(['.',filesep,'arc_ImageAnalysis',filesep,'AnalysisFunctions']));

%% Load and transform data

data.GoPro = load(paths.GoProProcessedData,'fileList');
data.GoPro = transformGoProData(data.GoPro.fileList);

data.NL = load(paths.NLProcessedData,'MBarray_concat'); % order: LLM, SLM, L+M, season, location, CL (`sussex_nanolambda/arc_plotMB.m`)
data.NL = data.NL.MBarray_concat;

data.HS = load(paths.HSProcessedData,'d'); % order: LLM, SLM, L+M, season, location, CL (`sussex_nanolambda/arc_plotMB.m`)
data.HS = transformHSData(data.HS.d);

data.PP = load(paths.PPProcessedData);
data.PP = transformPPData(data.PP.resultsTable);

%% 2D histogram plots, split by location and season

meta.figType = 'colour'; % 'grayscale' or 'colour'

arc_2Dhist(data.GoPro,meta);
arc_saveFig([saveLocation,'2Dhist_GoPro','_',meta.figType],meta)

arc_2Dhist(data.NL,meta);
arc_saveFig([saveLocation,'2Dhist_NL','_',meta.figType],meta)

arc_2Dhist(data.HS,meta);
arc_saveFig([saveLocation,'2Dhist_HS','_',meta.figType],meta)

%% Psychophysics vs environment

ppVsEnvironment(data,meta);
arc_saveFig([saveLocation,'PPvsE'],meta)



