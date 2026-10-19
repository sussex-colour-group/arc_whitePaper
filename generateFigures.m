clear, clc, close all

% figure meta
meta.figSize = [100,100,1000,500]; % first two values are location, second two are size
meta.fontSize.big   = 18;
meta.fontSize.small = 14;
meta.edges = {linspace(0.66,0.82,40) linspace(0,2,40)};
meta.pltCols = {[0 0 .5],[.5 0 0]}; %Tromso blue, Oslo red
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
addpath(genpath(['.',filesep,'nanolambda']));

%% Load and transform data

data.GoPro = readmatrix(paths.GoProProcessedData)'; % order: LLM, SLM, L+M, season, location, CL

data.NL = readmatrix(paths.NLProcessedData)'; % order: LLM, SLM, L+M, season, location, CL (`sussex_nanolambda/arc_plotMB.m`)
data.NL_denoised = removeNLdarknoise(data.NL,10);

data.HS = load(paths.HSProcessedData,'d');
data.HS = transformHSData(data.HS.d);

data.PP = readtable(paths.PPProcessedData);
[data.PP,data.PP_pptCodes] = transformPPData(data.PP);
data.PP_excludeRecentTravellers = false;
data.PP_pptsToExclude = getExclusions(data.PP_excludeRecentTravellers);
[data.PP,data.PP_pptCodes] = excludePpts(data.PP,data.PP_pptCodes,data.PP_pptsToExclude);

%% 2D histogram plots, split by location and season

[minLLM,maxLLM,minSLM,maxSLM,minLUM,maxLUM]=arc_2Dhist_splitByLocationAndSeason(data.GoPro,meta);

%make colour bar
LLM_x=linspace(minLLM,0.7479,30);
SLM_x=linspace(1.5,0.15,30);
t=linspace(0,1,400);
LUM_x=minLUM+(maxLUM-minLUM).*sqrt(t);
LLM_mat=repmat(LLM_x,400,1);
SLM_mat=repmat(SLM_x,400,1);
LUM_mat=[repmat(LUM_x,30,1)].';
RGB = SelectRGBs('NSDFMRI');
LMS = SelectConeFundamentals('StockmanMacleodJohnson');
[~,LMS2RGB] = RGBToLMS(LMS,RGB,0);
LMS = MacBToLMS(LLM_mat,SLM_mat,LUM_mat);
RGBmatrix = ImageLMSToRGB(LMS2RGB,LMS);
colMax=max(RGBmatrix,[],[1 3]);   
RGBmatrix=RGBmatrix./colMax;       
fig = gcf;                 
t = findall(fig,'Type','tiledlayout');
if ~isempty(t)
    t.Units = 'normalized';
    t.OuterPosition = [0 0 1 1];  
end

axCB = axes(fig,'Units','normalized','Position',[0.92 0.35 0.01 0.35]);
image(axCB,'XData',[0 1],'YData',[0 1],'CData',RGBmatrix);  
axCB.YDir='normal';    
axCB.XLim=[0 1];
axCB.YLim=[0 1];
axCB.XTick=[];           
axCB.YAxisLocation ='right';      
axCB.YTick=0:0.25:1;      
axCB.TickDir='out';         
box(axCB,'on');
ytickformat(axCB,'%.1f'); 
ylabel(axCB,'Proportion of pixels','Rotation',90,'VerticalAlignment','bottom');
axCB.YLabel.Units = 'normalized';
axCB.YLabel.Position(1) = 6;  
set(gca,'FontSize',14)
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

meta.envLabel = 'Head-cam';
meta.tweakLabels.env = true;
meta.tweakLabels.PP = true;
meta.fontSizeSmall=18;
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

whiteSnifferFigure(data,meta,paths);
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

meta.tweakLabels.env = false;
meta.tweakLabels.PP = true;

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




