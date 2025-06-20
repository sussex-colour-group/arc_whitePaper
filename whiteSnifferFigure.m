function whiteSnifferFigure(data,meta)

%%

figure("Position",meta.figSize); hold on
% tiledlayout(2,2)
tiledlayout(1,2)

for location = [0,1]
    n{location+1} = nexttile; 
    hold on

    arc_2Dhist(data.PP(1,data.PP(5,:) == location),...
        data.PP(2,data.PP(5,:) == location),...
        meta);

    [~,xneg] = compute95pctCI(data.PP(1,data.PP(5,:) == location));
    xpos = xneg;
    [~,yneg] = compute95pctCI(data.PP(2,data.PP(5,:) == location));
    ypos = yneg;

    errorbar(mean(data.PP(1,data.PP(5,:) == location),"omitnan"),...
        mean(data.PP(2,data.PP(5,:) == location),"omitnan"),...
        yneg,ypos,xneg,xpos,...
        'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
        'DisplayName',meta.locationNames{location+1})

    xlabel('L/(L+M)','FontSize',meta.fontSize.big)
    ylabel('S/(L+M)','FontSize',meta.fontSize.big)

    title(meta.locationNames{location+1},...
    'FontSize',meta.fontSize.big,'FontWeight','normal')

end

% add outline
threshVal = 0; % 0 includes all the data, 85 seems like an OK value for excluding noise (excludes points in the histmatrix that are below the 85% percentile value)
for location = [0,1]
    histmatrix = histcounts2(data.GoPro(1,data.GoPro(5,:) == location),data.GoPro(2,data.GoPro(5,:) == location),...
        'XBinEdges',meta.edges{1,1},'YBinEdges',meta.edges{1,2})';
    histmatrix = histmatrix > prctile(histmatrix,threshVal,"all");
    histmatrix_big = imresize(histmatrix,100,"nearest");
    B = bwboundaries(histmatrix_big);
    axes('xlim',[1,size(histmatrix_big,1)],'ylim',[1,size(histmatrix_big,2)],...
        "Color","none",...
        "Position",n{location+1}.Position,"Visible","off")
    hold on
    for k = 1:length(B)
        plot(B{k}(:,2), B{k}(:,1),'Color',[1,1,1]) % TODO These values probably need offsetting ever so slightly to actually match, following through the the imresize etc. It might be good enough for visualisation purposes though.
    end
end

set(gcf,"InvertHardcopy","off") % required to make the white line white when saving (wtf matlab?)

%% Visual comparison check

% figure("Position",meta.figSize); hold on
% tiledlayout(1,2)
% 
% meta.figType = "grayscale";
% 
% for location = [0,1]
%     nexttile, hold on
% 
%     arc_2Dhist(data.GoPro(1,data.GoPro(5,:) == location),...
%         data.GoPro(2,data.GoPro(5,:) == location),...
%         meta);  
% 
% end

%% white sniffer fig

% paths.GoProProcessedData_whiteSniffer

end
