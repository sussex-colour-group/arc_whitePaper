function [ceruleanLociMB,ceruleanLine] = getCeruleanLine()

addpath(genpath(['arc_ImageAnalysis',filesep,'AnalysisFunctions']));

[coneFundamentals,wl] = SelectConeFundamentals('StockmanMacleodJohnson'); % 10-degree % From `arc_config.m`

% get MB co-ords of 476nm and 576nm
t(1,:,:) =  coneFundamentals; % hack because LMSToMacB needs a 3D matrix
[LLMmatrix,SLMmatrix,~] = LMSToMacB(t);
SL = [LLMmatrix;SLMmatrix];
ceruleanLociMB = SL(:,[find(wl == 476), find(wl == 576)]); % 576nm vs 476nm

% figure, hold on
% plot(LLMmatrix,SLMmatrix,'k-o')
% scatter(ceruleanLociMB(1,1),ceruleanLociMB(2,1),'b','filled','MarkerEdgeColor','k')
% scatter(ceruleanLociMB(1,2),ceruleanLociMB(2,2),'y','filled','MarkerEdgeColor','k')

nPoints = 10000;
ceruleanLine = [linspace(ceruleanLociMB(1,1),ceruleanLociMB(1,2),nPoints);...
    linspace(ceruleanLociMB(2,1),ceruleanLociMB(2,2),nPoints)];
% plot(ceruleanLine(1,:),ceruleanLine(2,:),'k-.')

end