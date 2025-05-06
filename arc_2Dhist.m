function arc_2Dhist(data,meta)

figure("Position",meta.figSize);
tiledlayout(2,4,"TileSpacing","compact")

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

for location = [0,1]
    for season = [4,1,2,3]
        nexttile, hold on

        if strcmp(meta.figType, "colour")

            histmatrix = histcounts2(data(1,(data(5,:) == location & data(4,:) == season)),...
                data(2,(data(5,:) == location & data(4,:) == season)),...
                'XBinEdges',meta.edges{1,1},'YBinEdges',meta.edges{1,2})';
            LandMColour = 0.01.*((histmatrix.^powernorm)./(max(max((histmatrix.^powernorm)))));
            LMS = MacBToLMS(LLMColour,SLMColour,LandMColour);
            RGBmatrix = ImageLMSToRGB(LMS2RGB,LMS);

            image(RGBmatrix,...
                'Xdata',movmean(meta.edges{1,1},2,"Endpoints","discard"),...
                'Ydata',movmean(meta.edges{1,2},2,"Endpoints","discard"));

        else % grayscale
            histogram2(data(1,(data(5,:) == location & data(4,:) == season)),...
                data(2,(data(5,:) == location & data(4,:) == season)),...
                'XBinedges',meta.edges{1,1},'YBinedges',meta.edges{1,2},...
                'DisplayStyle','tile','ShowEmptyBins','on','EdgeColor','none');
            colormap('gray')
        end

        % colorbar
        axis tight square
        set(gca,'TickDir','out')

        % text(0.76,1.4,[meta.locationNames{location+1},', ',meta.seasonNames{season}],'Color',[1,1,1])
        if season == 4
            ylabel({['\fontsize{',num2str(meta.fontSize.big),'}', meta.locationNames{location+1}];...
                ['\fontsize{',num2str(meta.fontSize.small),'}', 'S/(L+M)']})
        else
            yticks([]);
        end
        if location == 0
            title(meta.seasonNames{season},...
                'FontSize',meta.fontSize.big,'FontWeight','normal')
            xticks([]);
        end
        if location == 1
            xlabel('L/(L+M)','FontSize',meta.fontSize.small)
        end
    end
end
end