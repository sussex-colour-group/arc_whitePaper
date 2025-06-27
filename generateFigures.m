clear, clc, close all

% figure meta
meta.figSize = [100,100,1000,500]; % first two values are location, second two are size
meta.fontSize.big   = 15;
meta.fontSize.small = 10;
meta.edges = {linspace(0.66,0.82,40) linspace(0,2,40)};
meta.pltCols = {'r','b'};
meta.figType = 'colour'; % 'grayscale' or 'colour', for the 2D histograms
meta.paramNames = {'LLM', 'SLM', 'L+M', 'test season', 'test location','CL','birth season','birth location'};

saveLocation = ['.',filesep,'figs',filesep];

% data meta
meta.seasonNames = {'Summer','Autumn','Winter','Spring'};
meta.locationNames = {'Tromsø','Oslo'};
meta.aboveBelowNames = {'below','above'};

showStats = true;

%% Data and save locations

paths = getLocalPaths;
addpath(genpath(['.',filesep,'imageanalysis']));
addpath(genpath(['.',filesep,'sussex_nanolambda']));

%% Load and transform data

data.GoPro = readmatrix(paths.GoProProcessedData)'; % order: LLM, SLM, L+M, season, location, CL

data.NL = load(paths.NLProcessedData,'MBarray_concat'); % order: LLM, SLM, L+M, season, location, CL (`sussex_nanolambda/arc_plotMB.m`)
data.NL = data.NL.MBarray_concat;
data.NL_denoised = removeNLdarknoise(data.NL,10);

data.HS = load(paths.HSProcessedData,'d');
data.HS = transformHSData(data.HS.d);

data.PP = load(paths.PPProcessedData,'resultsTable');
[data.PP,data.PP_pptCodes] = transformPPData(data.PP.resultsTable);
data.PP_excludeRecentTravellers = false;
data.PP_pptsToExclude = getExclusions(data.PP_excludeRecentTravellers);
[data.PP,data.PP_pptCodes] = excludePpts(data.PP,data.PP_pptCodes,data.PP_pptsToExclude);

%% 2D histogram plots, split by location and season

arc_2Dhist_splitByLocationAndSeason(data.GoPro,meta);
arc_saveFig([saveLocation,'1_2Dhist_GoPro','_',meta.figType],meta)

for i = [1,2,6] % LLM, SLM, CL
    [~,tbl.GoPro{i},stats.GoPro{i}] = anovan(data.GoPro(i,:),...
        {data.GoPro(4,:), data.GoPro(5,:)},... % test season, test location
        'model','interaction',...
        'Varnames',{meta.paramNames{4}, meta.paramNames{5}},...
        'display','off');
    if showStats
        disp('GoPro')
        disp(meta.paramNames{i})
        disp(tbl.GoPro{i})
    end
    writecell(tbl.GoPro{i},['stats',filesep,'GoPro_',meta.paramNames{i},'.csv']);
end

%% Psychophysics vs environment

meta.envLabel = 'Head Cam';
meta.tweakLabels = true;

ppVsEnvironment(data.GoPro,data.PP,meta);
arc_saveFig([saveLocation,'2_PPvsE'],meta)

% testing location/season effects
for i = [1,2,6] % LLM, SLM, CL
    [~,tbl.PPtesting{i},stats.PPtesting{i}] = anovan(data.PP(i,:),...
        {data.PP(4,:), data.PP(5,:)},... % test season, test location
        'model','interaction',...
        'Varnames',{meta.paramNames{4}, meta.paramNames{5}},...
        'display','off');
    if showStats
        disp('PPtesting')
        disp(meta.paramNames{i})
        disp(tbl.PPtesting{i})
    end
    writecell(tbl.PPtesting{i},['stats',filesep,'PP_testing_',meta.paramNames{i},'.csv']);

    % means and SD of location effect
    for location = [0,1]
        writematrix(mean(data.PP(i,data.PP(5,:) == location),"omitnan"),...
            ['stats',filesep,'PP_testing_',meta.paramNames{i},'_mean_',meta.locationNames{location+1},'.csv']);
        writematrix(std(data.PP(i,data.PP(5,:) == location),"omitnan"),...
            ['stats',filesep,'PP_testing_',meta.paramNames{i},'_std_',meta.locationNames{location+1},'.csv']);
    end
    % alternative:
    % [~,m] = multcompare(stats.PPtesting{i},"Dimension",[1,2],"Display","off") %(gives slightly different results?)
end

% birth location/season effects, Tromso testing location only
for i = [1,2,6] % LLM, SLM, CL
    [~,tbl.PPbirth{i},stats.PPbirth{i}] = anovan(data.PP(i,data.PP(5,:) == 0),...
        {data.PP(7,data.PP(5,:) == 0), data.PP(8,data.PP(5,:) == 0)},... % birth season, birth location
        'model','interaction',...
        'Varnames',{meta.paramNames{7}, meta.paramNames{8}},...
        'display','off');
    if showStats
        disp('PPbirth')
        disp(meta.paramNames{i})
        disp(tbl.PPbirth{i})
    end
    writecell(tbl.PPbirth{i},['stats',filesep,'PP_birth_',meta.paramNames{i},'.csv']);
end



%% White sniffer

whiteSnifferFigure(data,meta); % TODO Add white sniffer bit
arc_saveFig([saveLocation,'3_whiteSniffer'],meta)

%% Bright figure

meta.regression.range.interval = 5;
meta.regression.range.lower = 10; % lower bound
meta.regression.type = "global";

brightFigure(data,meta)
arc_saveFig([saveLocation,'4_brightFigure'],meta)

%% - %% SI

%% 2D histogram plots, split by location and season

arc_2Dhist_splitByLocationAndSeason(data.NL_denoised,meta);
arc_saveFig([saveLocation,'SI1_2Dhist_NL','_',meta.figType],meta)

arc_2Dhist_splitByLocationAndSeason(data.HS,meta);
arc_saveFig([saveLocation,'SI1_2Dhist_HS','_',meta.figType],meta)

% arc_2Dhist_splitByLocation(data,meta);
% arc_saveFig([saveLocation,'2Dhist_GoProVsPP','_',meta.figType],meta)

%% PP vs env but for HS instead of GoPro

meta.tweakLabels = false;

meta.envLabel = 'Hyperspectral';
ppVsEnvironment(data.HS,data.PP,meta);
arc_saveFig([saveLocation,'SI2_PPvsE_HS'],meta)

%
meta.envLabel = 'NanoLambda';
ppVsEnvironment(data.NL_denoised,data.PP,meta);
arc_saveFig([saveLocation,'SI2_PPvsE_NL'],meta)

%% Comparison across modalities

SummerWinterOnly = true;
compareMeasurementModalities(data,meta,SummerWinterOnly)
arc_saveFig([saveLocation,'SI3_compareMeasurementModalities'],meta)

%% NL darknoise

meta.figType = 'colour';
NLDarkNoisePlot(data.NL,meta);
arc_saveFig([saveLocation,'SI4_NLDarkNoise'],meta)

%% Screen calibration figure

%% PP vs env split by season and location, bar comparison




