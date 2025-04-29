%% Compare across measurement modalities
% means and CI for Go Pro, Hyperspectral and Nanolambda on one figure to show equivalence

clear, clc, close all

%% Load summary data (split by location)

% Generated in `arc_ImageAnalysis/plotMeanMB`
means_GoPro = load(['arc_ImageAnalysis',filesep,'GoProSummary']);

% means_HS = 

% means_NL = 

%%

figure, hold on

tiledlayout(2,3)

nexttile
errorbar(1,means_GoPro.LLM.OsloMean,means_GoPro.LLM.OsloSEM,...
    'ko')
title('LLM')
ylabel('Olso')

nexttile
errorbar(1,means_GoPro.SLM.OsloMean,means_GoPro.SLM.OsloSEM,...
    'ko')
title('SLM')

nexttile
errorbar(1,means_GoPro.CL.OsloMean,means_GoPro.CL.OsloSEM,...
    'ko')
title('CL')

%

nexttile
errorbar(1,means_GoPro.LLM.TromsoMean,means_GoPro.LLM.TromsoSEM,...
    'ko')
ylabel('Tromso')

nexttile
errorbar(1,means_GoPro.SLM.TromsoMean,means_GoPro.SLM.TromsoSEM,...
    'ko')

nexttile
errorbar(1,means_GoPro.CL.TromsoMean,means_GoPro.CL.TromsoSEM,...
    'ko')

% TODO Do we want to (roughly) equate over season?



