function arc_2Dhist(x,y,meta)

if strcmp(meta.figType, "colour") % use hues per bin

    % Modified from `PlotMacBHistogram.m`
    LLMColour = repmat(movmean(meta.edges{1,1},2,"Endpoints","discard"),...
        length(movmean(meta.edges{1,2},2,"Endpoints","discard")),1);
    SLMColour = repmat(movmean(meta.edges{1,2},2,"Endpoints","discard").',1,...
        length(movmean(meta.edges{1,1},2,"Endpoints","discard")));

    RGB = SelectRGBs('NSDFMRI');
    LMS = SelectConeFundamentals('StockmanMacleodJohnson');
    [~,LMS2RGB] = RGBToLMS(LMS,RGB,0);
    powernorm = 0.5;

end

if strcmp(meta.figType, "colour")

    histmatrix = histcounts2(x,y,...
        'XBinEdges',meta.edges{1,1},'YBinEdges',meta.edges{1,2})';
    LandMColour = 0.01.*((histmatrix.^powernorm)./(max(max((histmatrix.^powernorm)))));
    LMS = MacBToLMS(LLMColour,SLMColour,LandMColour);
    RGBmatrix = ImageLMSToRGB(LMS2RGB,LMS);

    image(RGBmatrix,...
        'Xdata',movmean(meta.edges{1,1},2,"Endpoints","discard"),...
        'Ydata',movmean(meta.edges{1,2},2,"Endpoints","discard"));

else % grayscale
    histogram2(x,y,...
        'XBinedges',meta.edges{1,1},'YBinedges',meta.edges{1,2},...
        'DisplayStyle','tile','ShowEmptyBins','on','EdgeColor','none');
    colormap('gray')
end

% colorbar
axis tight square
set(gca,'TickDir','out')

end