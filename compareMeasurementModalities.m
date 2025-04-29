%% Compare across measurement modalities
% means and CI for Go Pro, Hyperspectral and Nanolambda on one figure to show equivalence

clear, clc, close all

%% Load summary data (split by location)

% Go Pro (wearable camera)
% Generated in `arc_ImageAnalysis/plotMeanMB`
means_GoPro = load(['arc_ImageAnalysis',filesep,'GoProSummary']);


% Nanolambda (wearable spectrometer)
% Data processed in `sussex_nanolambda/arc_plotMB.m`
load(['sussex_nanolambda',filesep,'MATLABdataExport'],'MBarray_concat');

means_NL.LLM.all = mean(MBarray_concat(1,:));
means_NL.SLM.all = mean(MBarray_concat(2,:));
means_NL.CL.all = mean(MBarray_concat(6,:));

means_NL.LLM.OsloMean = mean(MBarray_concat(1,MBarray_concat(5,:) == 1)); % 0 is Tromso (line ~80 `sussex_nanolambda/arc_plotMB.m`)
means_NL.SLM.OsloMean = mean(MBarray_concat(2,MBarray_concat(5,:) == 1));
means_NL.CL.OsloMean = mean(MBarray_concat(6,MBarray_concat(5,:) == 1));

means_NL.LLM.TromsoMean = mean(MBarray_concat(1,MBarray_concat(5,:) == 0)); % 0 is Tromso (line ~80 `sussex_nanolambda/arc_plotMB.m`)
means_NL.SLM.TromsoMean = mean(MBarray_concat(2,MBarray_concat(5,:) == 0));
means_NL.CL.TromsoMean = mean(MBarray_concat(6,MBarray_concat(5,:) == 0));

% SEM
means_NL.LLM.OsloSEM = std(MBarray_concat(1,MBarray_concat(5,:) == 1))/sqrt(length(MBarray_concat(1,MBarray_concat(5,:) == 1))); % 0 is Tromso (line ~80 `sussex_nanolambda/arc_plotMB.m`)
means_NL.SLM.OsloSEM = std(MBarray_concat(2,MBarray_concat(5,:) == 1))/sqrt(length(MBarray_concat(1,MBarray_concat(5,:) == 1)));
means_NL.CL.OsloSEM = std(MBarray_concat(6,MBarray_concat(5,:) == 1))/sqrt(length(MBarray_concat(1,MBarray_concat(5,:) == 1)));

means_NL.LLM.TromsoSEM = std(MBarray_concat(1,MBarray_concat(5,:) == 0))/sqrt(length(MBarray_concat(1,MBarray_concat(5,:) == 0))); % 0 is Tromso (line ~80 `sussex_nanolambda/arc_plotMB.m`)
means_NL.SLM.TromsoSEM = std(MBarray_concat(2,MBarray_concat(5,:) == 0))/sqrt(length(MBarray_concat(1,MBarray_concat(5,:) == 0)));
means_NL.CL.TromsoSEM = std(MBarray_concat(6,MBarray_concat(5,:) == 0))/sqrt(length(MBarray_concat(1,MBarray_concat(5,:) == 0)));


%%
% Hyperspectral
% See arc_ImageAnalysis/plotMeanMB_hyperspec.m
load(['arc_ImageAnalysis',filesep,'hyperspectralMBmeans.mat'],'d');

HSmeanMB = NaN(2,1165);
for i = 1:size(d,1)

    if length(d(i).name) == 14 % please, dearest future humans, use leading zeros when storing data
        picId = str2num(d(i).name(1:4)); 
    else
        picId = str2num(d(i).name(1:3));
    end

    HSmeanMB(:,picId) = [d(i).meanMB];
end

OsloIndex([510:740,952:1165]) = true;
TromsoIndex([330:509,743:951]) = true;

SummerIndex([510:740,330:509]) = true;
WinterIndex([952:1165,743:951]) = true;

means_HS.LLM.all = mean(HSmeanMB(1,:),"omitnan");
means_HS.SLM.all = mean(HSmeanMB(2,:),"omitnan");
% means_HS.CL.all = mean(HSmeanMB(3,:),"omitnan");

means_HS.LLM.OsloMean = mean(HSmeanMB(1,OsloIndex),"omitnan"); 
means_HS.SLM.OsloMean = mean(HSmeanMB(2,OsloIndex),"omitnan");
% means_HS.CL.OsloMean = mean(HSmeanMB(3,OsloIndex),"omitnan");

means_HS.LLM.TromsoMean = mean(HSmeanMB(1,TromsoIndex),"omitnan"); 
means_HS.SLM.TromsoMean = mean(HSmeanMB(2,TromsoIndex),"omitnan");
% means_HS.CL.TromsoMean = mean(HSmeanMB(3,TromsoIndex),"omitnan");

% SEM
means_HS.LLM.OsloSEM = std(HSmeanMB(1,OsloIndex),"omitnan")/sqrt(sum(OsloIndex)); 
means_HS.SLM.OsloSEM = std(HSmeanMB(2,OsloIndex),"omitnan")/sqrt(sum(OsloIndex)); 
% means_HS.CL.OsloSEM  = std(HSmeanMB(3,OsloIndex),"omitnan")/sqrt(sum(OsloIndex)); 

means_HS.LLM.TromsoSEM = std(HSmeanMB(1,TromsoIndex),"omitnan")/sqrt(sum(TromsoIndex)); 
means_HS.SLM.TromsoSEM = std(HSmeanMB(2,TromsoIndex),"omitnan")/sqrt(sum(TromsoIndex)); 
% means_HS.CL.TromsoSEM  = std(HSmeanMB(3,TromsoIndex),"omitnan")/sqrt(sum(TromsoIndex)); 


%%

figure, hold on

ax_LLM = [0.66,0.82];
ax_SLM = [0,2];

tiledlayout(2,3)

nexttile, hold on
errorbar(1,means_GoPro.LLM.OsloMean,means_GoPro.LLM.OsloSEM,...
    'ko')
errorbar(2,means_NL.LLM.OsloMean,means_NL.LLM.OsloSEM,...
    'ko')
errorbar(3,means_HS.LLM.OsloMean,means_HS.LLM.OsloSEM,...
    'ko')
title('LLM')
ylabel('Olso')
xlim([0.5,3.5])
ylim(ax_LLM);
xticks([1,2,3])
xticklabels({'GoPro','NL','Hyperspec'})

nexttile, hold on
errorbar(1,means_GoPro.SLM.OsloMean,means_GoPro.SLM.OsloSEM,...
    'ko')
errorbar(2,means_NL.SLM.OsloMean,means_NL.SLM.OsloSEM,...
    'ko')
errorbar(3,means_HS.SLM.OsloMean,means_HS.SLM.OsloSEM,...
    'ko')
title('SLM')
xlim([0.5,3.5])
ylim(ax_SLM);
xticks([1,2,3])
xticklabels({'GoPro','NL','Hyperspec'})

nexttile, hold on
errorbar(1,means_GoPro.CL.OsloMean,means_GoPro.CL.OsloSEM,...
    'ko')
errorbar(2,means_NL.CL.OsloMean,means_NL.CL.OsloSEM,...
    'ko')
% errorbar(3,means_HS.CL.OsloMean,means_HS.CL.OsloSEM,...
%     'ko')
title('CL')
xlim([0.5,3.5])
xticks([1,2,3])
xticklabels({'GoPro','NL','Hyperspec'})

% Tromso

nexttile, hold on
errorbar(1,means_GoPro.LLM.TromsoMean,means_GoPro.LLM.TromsoSEM,...
    'ko')
errorbar(2,means_NL.LLM.TromsoMean,means_NL.LLM.OsloSEM,...
    'ko')
errorbar(3,means_HS.LLM.TromsoMean,means_HS.LLM.OsloSEM,...
    'ko')
ylabel('Tromso')
xlim([0.5,3.5])
ylim(ax_LLM);
xticks([1,2,3])
xticklabels({'GoPro','NL','Hyperspec'})

nexttile, hold on
errorbar(1,means_GoPro.SLM.TromsoMean,means_GoPro.SLM.TromsoSEM,...
    'ko')
errorbar(2,means_NL.SLM.TromsoMean,means_NL.SLM.TromsoSEM,...
    'ko')
errorbar(3,means_HS.SLM.TromsoMean,means_HS.SLM.OsloSEM,...
    'ko')
xlim([0.5,3.5])
ylim(ax_SLM);
xticks([1,2,3])
xticklabels({'GoPro','NL','Hyperspec'})

nexttile, hold on
errorbar(1,means_GoPro.CL.TromsoMean,means_GoPro.CL.TromsoSEM,...
    'ko')
errorbar(2,means_NL.CL.TromsoMean,means_NL.CL.TromsoSEM,...
    'ko')
% errorbar(3,means_HS.CL.TromsoMean,means_HS.LLM.OsloSEM,...
%     'ko')
xlim([0.5,3.5])
xticks([1,2,3])
xticklabels({'GoPro','NL','Hyperspec'})

% TODO Do we want to (roughly) equate over season?



