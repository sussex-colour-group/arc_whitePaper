function ppVsEnvironment(data,meta)

figure("Position",meta.figSize); hold on

tiledlayout(2,3)
nexttile([2,2]), hold on

xlim([meta.edges{1,1}(1),meta.edges{1,1}(end)]);
ylim([meta.edges{1,2}(1),meta.edges{1,2}(end)]);
axis square
xlabel('L/(L+M)','FontSize',meta.fontSize.small)
ylabel('S/(L+M)','FontSize',meta.fontSize.small)

% lgd = legend;
%fontsize(lgd,14,'points')

%% A

% Plot GoPro

for location = [0,1]
    for season = 1:4

        xneg = std(data.GoPro(1,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan")...
            /sqrt(length(data.GoPro(1,data.GoPro(5,:) == location & data.GoPro(4,:) == season & ~isnan(data.GoPro(5,:) == location & data.GoPro(4,:) == season))));
        xpos = xneg;
        yneg = std(data.GoPro(2,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan")...
            /sqrt(length(data.GoPro(2,data.GoPro(5,:) == location & data.GoPro(4,:) == season & ~isnan(data.GoPro(5,:) == location & data.GoPro(4,:) == season))));
        ypos = yneg;

        errorbar(mean(data.GoPro(1,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan"),...
            mean(data.GoPro(2,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Plot PP
for location = [0,1]
    for season = 1:4

        xneg = std(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan")...
            /sqrt(length(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season & ~isnan(data.PP(5,:) == location & data.PP(4,:) == season))));
        xpos = xneg;
        yneg = std(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan")...
            /sqrt(length(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season & ~isnan(data.PP(5,:) == location & data.PP(4,:) == season))));
        ypos = yneg;

        errorbar(mean(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            mean(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Add cerulean line
[~,ceruleanLine] = getCeruleanLine();
plot(ceruleanLine(1,:),ceruleanLine(2,:),...
    'k-.','DisplayName','Cerulean Line');

rectangle('Position',[meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(1),...
    meta.edgesZoomedIn{1,1}(end) - meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) - meta.edgesZoomedIn{1,2}(1)])

%% B
% Plot PP again, but small

nexttile, hold on

xlim([meta.edgesZoomedIn{1,1}(1),meta.edgesZoomedIn{1,1}(end)]);
ylim([meta.edgesZoomedIn{1,2}(1),meta.edgesZoomedIn{1,2}(end)]);
axis square
% xlabel('L/(L+M)','FontSize',meta.fontSize.small)
ylabel('S/(L+M)','FontSize',meta.fontSize.small)
box on

for location = [0,1]
    for season = 1:4

        xneg = std(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan")...
            /sqrt(length(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season & ~isnan(data.PP(5,:) == location & data.PP(4,:) == season))));
        xpos = xneg;
        yneg = std(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan")...
            /sqrt(length(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season & ~isnan(data.PP(5,:) == location & data.PP(4,:) == season))));
        ypos = yneg;

        errorbar(mean(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            mean(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Add cerulean line
[~,ceruleanLine] = getCeruleanLine();
plot(ceruleanLine(1,:),ceruleanLine(2,:),...
    'k-.','DisplayName','Cerulean Line');

%% C
% Split by birth season

nexttile, hold on

xlim([meta.edgesZoomedIn{1,1}(1),meta.edgesZoomedIn{1,1}(end)]);
ylim([meta.edgesZoomedIn{1,2}(1),meta.edgesZoomedIn{1,2}(end)]);
axis square
xlabel('L/(L+M)','FontSize',meta.fontSize.small)
ylabel('S/(L+M)','FontSize',meta.fontSize.small)
box on

for aboveBelow = [0,1]

    xneg = std(data.PP(1,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan")...
        /sqrt(length(data.PP(1,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow & ~isnan(data.PP(7,:) == aboveBelow))));
    xpos = xneg;
    yneg = std(data.PP(2,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan")...
        /sqrt(length(data.PP(2,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow & ~isnan(data.PP(7,:) == aboveBelow))));
    ypos = yneg;

    errorbar(mean(data.PP(1,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan"),...
        mean(data.PP(2,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan"),...
        yneg,ypos,xneg,xpos,...
        'x','Color',meta.pltCols{1},...
        'DisplayName',['...'])
end

% Add cerulean line
[~,ceruleanLine] = getCeruleanLine();
plot(ceruleanLine(1,:),ceruleanLine(2,:),...
    'k-.','DisplayName','Cerulean Line');

end
