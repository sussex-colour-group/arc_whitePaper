function ppVsEnvironment(data,meta)

%%
textRotation = 0;

figure("Position",meta.figSize); hold on

tiledlayout(2,3)
nexttile([2,2]), hold on

% tiledlayout(1,3)
% nexttile, hold on

xlim([meta.edges{1,1}(1),meta.edges{1,1}(end)]);
ylim([meta.edges{1,2}(1),meta.edges{1,2}(end)]);
axis square
xlabel('L/(L+M)','FontSize',meta.fontSize.big)
ylabel('S/(L+M)','FontSize',meta.fontSize.big)

% lgd = legend;
%fontsize(lgd,14,'points')

%% A

% Plot GoPro

for location = [0,1]
    for season = 1:4

        [~,xneg] = compute95pctCI(data.GoPro(1,data.GoPro(5,:) == location & data.GoPro(4,:) == season));
        xpos = xneg;
        [~,yneg] = compute95pctCI(data.GoPro(2,data.GoPro(5,:) == location & data.GoPro(4,:) == season));
        ypos = yneg;

        errorbar(mean(data.GoPro(1,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan"),...
            mean(data.GoPro(2,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Plot PP
for location = [0,1]
    for season = 1:4

        [~,xneg] = compute95pctCI(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season));
        xpos = xneg;
        [~,yneg] = compute95pctCI(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season));
        ypos = yneg;

        errorbar(mean(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            mean(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Add cerulean line
[~,ceruleanLine] = getCeruleanLine();
plot(ceruleanLine(1,:),ceruleanLine(2,:),...
    'k:','DisplayName','Cerulean Line');

rectangle('Position',[meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(1),...
    meta.edgesZoomedIn{1,1}(end) - meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) - meta.edgesZoomedIn{1,2}(1)],...
    'LineStyle','--');

% labels
text(meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) + 0.07,...
    'Psychophysics',...
    'HorizontalAlignment','left',...
    'FontSize',meta.fontSize.big)

text(0.76, 0.4457,...
    'Go Pro',...
    'HorizontalAlignment','left',...
    'FontSize',meta.fontSize.big)

for location = [0,1]
    for season = 1:4
        labelH{location+1,season} = text(mean(data.GoPro(1,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan"),...
            mean(data.GoPro(2,data.GoPro(5,:) == location & data.GoPro(4,:) == season),"omitnan"),...
        [meta.locationNames{location+1},' - ',meta.seasonNames{season}],...
        'Rotation',textRotation,'Color',meta.pltCols{location+1});

        if location == 0
            set(labelH{location+1,season},'Position',labelH{location+1,season}.Position + [0.005,0.07,0]);
        end
        if location == 1
            set(labelH{location+1,season},'Position',labelH{location+1,season}.Position + [-0.005,-0.07,0]);
            set(labelH{location+1,season},'HorizontalAlignment','right');
        end
    end
end

set(labelH{2,1},'Position',[0.704019759690174,0.667457153376271,0]); % Oslo Summer
set(labelH{1,4},'Position',[0.732050211032689,0.67219608147075,0]); % Tromso Spring
set(labelH{1,2},'Position',[0.738958718500719,0.615814506986439,0]); % Tromso Autumn

A_daspect = daspect(gca);

%% B
% Plot PP again, but small

nexttile, hold on

xlim([meta.edgesZoomedIn{1,1}(1),meta.edgesZoomedIn{1,1}(end)]);
ylim([meta.edgesZoomedIn{1,2}(1),meta.edgesZoomedIn{1,2}(end)]);
% axis square
daspect(A_daspect);
xlabel('L/(L+M)','FontSize',meta.fontSize.big)
% ylabel('S/(L+M)','FontSize',meta.fontSize.big)

% hacky version of "box"
rectangle('Position',[meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(1),...
    meta.edgesZoomedIn{1,1}(end) - meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) - meta.edgesZoomedIn{1,2}(1)],...
    'LineStyle','--');

for location = [0,1]
    for season = 1:4

        [~,xneg] = compute95pctCI(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season));
        xpos = xneg;
        [~,yneg] = compute95pctCI(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season));
        ypos = yneg;

        errorbar(mean(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            mean(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Add cerulean line
[~,ceruleanLine] = getCeruleanLine();
plot(ceruleanLine(1,:),ceruleanLine(2,:),...
    'k:','DisplayName','Cerulean Line');

clear labelH
for location = [0,1]
    for season = 1:4
        labelH{location+1,season} = text(mean(data.PP(1,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
            mean(data.PP(2,data.PP(5,:) == location & data.PP(4,:) == season),"omitnan"),...
        [meta.locationNames{location+1},' - ',meta.seasonNames{season}],...
        'Rotation',textRotation,'Color',meta.pltCols{location+1});

        set(labelH{location+1,season},'Position',labelH{location+1,season}.Position + [0.002,0,0])

        if location == 1
            set(labelH{location+1,season},'Position',labelH{location+1,season}.Position + [-0.005,0,0])
            set(labelH{location+1,season},'HorizontalAlignment','right');
        end
    end
end

set(labelH{1,1},'Position',[0.689543835145079,1.262732455108744,0]); % Tromso Summer
set(labelH{1,4},'Position',[0.690951856212633,1.241722798234143,0]); % Tromso Spring
set(labelH{1,3},'Position',[0.692259063412531,1.209483961064295,0]); % Tromso Winter
set(labelH{1,2},'Position',[0.692493286669964,1.166881326771044,0]); % Tromso Autumn

% set(labelH{2,2},'Position',[0.695510754426397,1.119069962572727,0]); % Oslo Autumn
% set(labelH{2,1},'Position',[0.700948391228591,1.071487107703185,0]); % Oslo Summer

title('Testing location',...
    'FontSize',meta.fontSize.big,'FontWeight','normal')

%% C
% Split by birth season

nexttile, hold on

xlim([meta.edgesZoomedIn{1,1}(1),meta.edgesZoomedIn{1,1}(end)]);
ylim([meta.edgesZoomedIn{1,2}(1),meta.edgesZoomedIn{1,2}(end)]);
% axis square
daspect(A_daspect);
xlabel('L/(L+M)','FontSize',meta.fontSize.big)
% ylabel('S/(L+M)','FontSize',meta.fontSize.big)

% hacky version of "box"
rectangle('Position',[meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(1),...
    meta.edgesZoomedIn{1,1}(end) - meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) - meta.edgesZoomedIn{1,2}(1)],...
    'LineStyle','--');

for aboveBelow = [0,1]

    [~,xneg] = compute95pctCI(data.PP(1,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow));
    xpos = xneg;
    [~,yneg] = compute95pctCI(data.PP(2,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow));
    ypos = yneg;

    errorbar(mean(data.PP(1,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan"),...
        mean(data.PP(2,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan"),...
        yneg,ypos,xneg,xpos,...
        'x','Color','k','MarkerEdgeColor',meta.pltCols{1},... 
        'DisplayName',['...'])
end

% Add cerulean line
[~,ceruleanLine] = getCeruleanLine();
plot(ceruleanLine(1,:),ceruleanLine(2,:),...
    'k:','DisplayName','Cerulean Line');

%labels
clear labelH
for aboveBelow = [0,1]
        labelH{aboveBelow+1} = text(mean(data.PP(1,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan"),...
            mean(data.PP(2,data.PP(5,:) == 0 & data.PP(7,:) == aboveBelow),"omitnan"),...
        meta.aboveBelowNames{aboveBelow+1},...
        'Rotation',textRotation,'Color',meta.pltCols{1});

        set(labelH{aboveBelow+1},'Position',labelH{aboveBelow+1}.Position + [0.002,0.02,0])

end

title('Birth Location (Tromsø ppts only)',...
    'FontSize',meta.fontSize.big,'FontWeight','normal')

end
