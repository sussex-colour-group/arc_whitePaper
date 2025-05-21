function arc_2Dhist_splitByLocation(data,meta)

%%

figure("Position",meta.figSize - [0,0,200,0]);
tiledlayout(2,3,"TileSpacing","compact")

for location = [0,1]
    nexttile, hold on

    x = data.GoPro(1,(data.GoPro(5,:) == location));
    y = data.GoPro(2,(data.GoPro(5,:) == location));
    arc_2Dhist(x,y,meta)

    % title(meta.locationNames{location+1},...
    %     'FontSize',meta.fontSize.big,'FontWeight','normal')
    text(0.92,0.9,meta.locationNames{location+1},...
        'Color',[1,1,1],'HorizontalAlignment','right','Units','normalized','FontSize',meta.fontSize.big);

    if location == 0
        ylabel('S/(L+M)','FontSize',meta.fontSize.small)
    end
end


%% 
nexttile, hold on

xlim([meta.edges{1,1}(1),meta.edges{1,1}(end)]);
ylim([meta.edges{1,2}(1),meta.edges{1,2}(end)]);
axis square
% xlabel('L/(L+M)','FontSize',meta.fontSize.big)
% ylabel('S/(L+M)','FontSize',meta.fontSize.big)

for location = [0,1]

    [~,xneg] = compute95pctCI(data.GoPro(1,data.GoPro(5,:) == location));
    xpos = xneg;
    [~,yneg] = compute95pctCI(data.GoPro(2,data.GoPro(5,:) == location));
    ypos = yneg;

    errorbar(mean(data.GoPro(1,data.GoPro(5,:) == location),"omitnan"),...
        mean(data.GoPro(2,data.GoPro(5,:) == location),"omitnan"),...
        yneg,ypos,xneg,xpos,...
        'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
        'DisplayName',[meta.locationNames{location+1}])
end

for location = [0,1]
    labelH{location+1} = text(mean(data.GoPro(1,data.GoPro(5,:) == location),"omitnan"),...
        mean(data.GoPro(2,data.GoPro(5,:) == location),"omitnan"),...
        [meta.locationNames{location+1},' Mean'],...
        'Color',meta.pltCols{location+1},...
        'FontSize',meta.fontSize.small);

    if location == 0
        set(labelH{location+1},'Position',labelH{location+1}.Position + [0.005,0,0]);
    end
    if location == 1
        set(labelH{location+1},'Position',labelH{location+1}.Position + [0.005,0.1,0]);
        % set(labelH{location+1},'HorizontalAlignment','right');
    end
end

%%

for location = [0,1]
    nexttile, hold on

    x = data.PP(1,(data.PP(5,:) == location));
    y = data.PP(2,(data.PP(5,:) == location));
    arc_2Dhist(x,y,meta)

    % title(meta.locationNames{location+1},...
    %     'FontSize',meta.fontSize.big,'FontWeight','normal')
    text(0.92,0.9,meta.locationNames{location+1},...
        'Color',[1,1,1],'HorizontalAlignment','right','Units','normalized','FontSize',meta.fontSize.big);

    xlabel('L/(L+M)','FontSize',meta.fontSize.small)
    if location == 0
        ylabel('S/(L+M)','FontSize',meta.fontSize.small)
    end
end


%% 
nexttile, hold on

xlim([meta.edges{1,1}(1),meta.edges{1,1}(end)]);
ylim([meta.edges{1,2}(1),meta.edges{1,2}(end)]);
axis square
xlabel('L/(L+M)','FontSize',meta.fontSize.small)
% ylabel('S/(L+M)','FontSize',meta.fontSize.small)

for location = [0,1]

    [~,xneg] = compute95pctCI(data.PP(1,data.PP(5,:) == location));
    xpos = xneg;
    [~,yneg] = compute95pctCI(data.PP(2,data.PP(5,:) == location));
    ypos = yneg;

    errorbar(mean(data.PP(1,data.PP(5,:) == location),"omitnan"),...
        mean(data.PP(2,data.PP(5,:) == location),"omitnan"),...
        yneg,ypos,xneg,xpos,...
        'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
        'DisplayName',[meta.locationNames{location+1}])

    % scatter(mean(data.PP(1,data.PP(5,:) == location),"omitnan"),...
    %     mean(data.PP(2,data.PP(5,:) == location),"omitnan"),...
    %     'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
    %     'DisplayName',[meta.locationNames{location+1}])
end

for location = [0,1]
    labelH{location+1} = text(mean(data.PP(1,data.PP(5,:) == location),"omitnan"),...
        mean(data.PP(2,data.PP(5,:) == location),"omitnan"),...
        [meta.locationNames{location+1},' Mean'],...
        'Color',meta.pltCols{location+1},...
        'FontSize',meta.fontSize.small);

    if location == 0
        set(labelH{location+1},'Position',labelH{location+1}.Position + [0.005,0.07,0]);
    end
    if location == 1
        set(labelH{location+1},'Position',labelH{location+1}.Position + [0.005,0,0]);
        % set(labelH{location+1},'HorizontalAlignment','right');
    end
end

end