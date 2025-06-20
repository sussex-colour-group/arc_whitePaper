function ppVsEnvironment(data_env,data_PP,meta)

meta.edgesZoomedIn = {linspace(0.67,0.715,40) linspace(0.97,1.3,40)};

%%
textRotation = 0;

figure("Position",meta.figSize);

axPositions = [...
    [0.1300, 0.1300, 0.4000, 0.7700];
    [0.5500, NaN,    0.4000, 0.3200];
    [0.5500, 0.1300, 0.4000, 0.3200]];

topMargin = 1 - axPositions(1,2) - axPositions(1,4);
axPositions(2,2) = 1 - (axPositions(2,4) + topMargin);

%% A

% Plot GoPro

axes('Position',axPositions(1,:));
hold on

xlim([meta.edges{1,1}(1),meta.edges{1,1}(end)]);
ylim([meta.edges{1,2}(1),meta.edges{1,2}(end)]);
axis square
xlabel('L/(L+M)','FontSize',meta.fontSize.big)
ylabel('S/(L+M)','FontSize',meta.fontSize.big)

% lgd = legend;
%fontsize(lgd,14,'points')

for location = [0,1]
    for season = 1:4

        [~,xneg] = compute95pctCI(data_env(1,data_env(5,:) == location & data_env(4,:) == season));
        xpos = xneg;
        [~,yneg] = compute95pctCI(data_env(2,data_env(5,:) == location & data_env(4,:) == season));
        ypos = yneg;

        errorbar(mean(data_env(1,data_env(5,:) == location & data_env(4,:) == season),"omitnan"),...
            mean(data_env(2,data_env(5,:) == location & data_env(4,:) == season),"omitnan"),...
            yneg,ypos,xneg,xpos,...
            'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
            'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
    end
end

% Plot PP
for location = [0,1]
    for season = 1:4

        [~,xneg] = compute95pctCI(data_PP(1,data_PP(5,:) == location & data_PP(4,:) == season));
        xpos = xneg;
        [~,yneg] = compute95pctCI(data_PP(2,data_PP(5,:) == location & data_PP(4,:) == season));
        ypos = yneg;

        errorbar(mean(data_PP(1,data_PP(5,:) == location & data_PP(4,:) == season),"omitnan"),...
            mean(data_PP(2,data_PP(5,:) == location & data_PP(4,:) == season),"omitnan"),...
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
text(meta.edgesZoomedIn{1,1}(1) - 0.005, meta.edgesZoomedIn{1,2}(end) + 0.1,...
    'Psychophysics',...
    'HorizontalAlignment','left',...
    'FontSize',meta.fontSize.big)

text(0.707313691507799,0.826982495667245,0,...
    meta.envLabel,...
    'HorizontalAlignment','left',...
    'FontSize',meta.fontSize.big)

for location = [0,1]
    for season = 1:4
        labelH{location+1,season} = text(mean(data_env(1,data_env(5,:) == location & data_env(4,:) == season),"omitnan"),...
            mean(data_env(2,data_env(5,:) == location & data_env(4,:) == season),"omitnan"),...
        [meta.locationNames{location+1},' - ',meta.seasonNames{season}],...
        'Rotation',textRotation,'Color',meta.pltCols{location+1});

        if location == 0
            set(labelH{location+1,season},'Position',labelH{location+1,season}.Position + [0.005,0,0]);
        end
        if location == 1
            set(labelH{location+1,season},'Position',labelH{location+1,season}.Position + [-0.005,0,0]);
            set(labelH{location+1,season},'HorizontalAlignment','right');
        end
    end
end

if isfield(meta,"tweakLabels") && meta.tweakLabels % only move labels when data exists
    set(labelH{2,4},'Position',[0.701131954120445,0.773382145134032,0]); % Oslo Spring
    set(labelH{1,4},'Position',[0.736740234933641,0.607644592475383,0]); % Tromso Spring
    set(labelH{1,2},'Position',[0.740701788923573,0.544625123087298,0]); % Tromso Autumn
end

A_daspect = daspect(gca);
A_xticks = xticks();
A_yticks = yticks();

%% B
% Plot PP again, but small

axes('Position',axPositions(2,:));
hold on

xlim([meta.edgesZoomedIn{1,1}(1),meta.edgesZoomedIn{1,1}(end)]);
ylim([meta.edgesZoomedIn{1,2}(1),meta.edgesZoomedIn{1,2}(end)]);
% axis square
daspect(A_daspect);
% xlabel('L/(L+M)','FontSize',meta.fontSize.big)
% ylabel('S/(L+M)','FontSize',meta.fontSize.big)

% hacky version of "box"
% rectangle('Position',[meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(1),...
%     meta.edgesZoomedIn{1,1}(end) - meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) - meta.edgesZoomedIn{1,2}(1)],...
%     'LineStyle','--');

for location = [0,1]
    for season = 1:4

        [~,xneg] = compute95pctCI(data_PP(1,data_PP(5,:) == location & data_PP(4,:) == season));
        xpos = xneg;
        [~,yneg] = compute95pctCI(data_PP(2,data_PP(5,:) == location & data_PP(4,:) == season));
        ypos = yneg;

        errorbar(mean(data_PP(1,data_PP(5,:) == location & data_PP(4,:) == season),"omitnan"),...
            mean(data_PP(2,data_PP(5,:) == location & data_PP(4,:) == season),"omitnan"),...
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
        labelH{location+1,season} = text(mean(data_PP(1,data_PP(5,:) == location & data_PP(4,:) == season),"omitnan"),...
            mean(data_PP(2,data_PP(5,:) == location & data_PP(4,:) == season),"omitnan"),...
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
set(labelH{1,4},'Position',[0.690951856212633,1.221722798234143,0]); % Tromso Spring
set(labelH{1,3},'Position',[0.692259063412531,1.189483961064295,0]); % Tromso Winter
set(labelH{1,2},'Position',[0.692493286669964,1.166881326771044,0]); % Tromso Autumn


set(labelH{2,1},'Position',[0.695297704491656,1.036165614071213,0]); % Oslo Summer
set(labelH{2,2},'Position',[0.691660357184412,1.101736872871365,0]); % Oslo Autumn

% set(labelH{2,2},'Position',[0.695510754426397,1.119069962572727,0]); % Oslo Autumn
% set(labelH{2,1},'Position',[0.700948391228591,1.071487107703185,0]); % Oslo Summer

title('Testing location',...
    'FontSize',meta.fontSize.big,'FontWeight','normal')

xticks(A_xticks);
yticks(A_yticks);

%% C
% Split by birth season

axes('Position',axPositions(3,:))
hold on

xlim([meta.edgesZoomedIn{1,1}(1),meta.edgesZoomedIn{1,1}(end)]);
ylim([meta.edgesZoomedIn{1,2}(1),meta.edgesZoomedIn{1,2}(end)]);
% axis square
daspect(A_daspect);
xlabel('L/(L+M)','FontSize',meta.fontSize.big)
% ylabel('S/(L+M)','FontSize',meta.fontSize.big)

% hacky version of "box"
% rectangle('Position',[meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(1),...
%     meta.edgesZoomedIn{1,1}(end) - meta.edgesZoomedIn{1,1}(1), meta.edgesZoomedIn{1,2}(end) - meta.edgesZoomedIn{1,2}(1)],...
%     'LineStyle','--');

for aboveBelow = [0,1]

    [~,xneg] = compute95pctCI(data_PP(1,data_PP(5,:) == 0 & data_PP(8,:) == aboveBelow));
    xpos = xneg;
    [~,yneg] = compute95pctCI(data_PP(2,data_PP(5,:) == 0 & data_PP(8,:) == aboveBelow));
    ypos = yneg;

    errorbar(mean(data_PP(1,data_PP(5,:) == 0 & data_PP(8,:) == aboveBelow),"omitnan"),...
        mean(data_PP(2,data_PP(5,:) == 0 & data_PP(8,:) == aboveBelow),"omitnan"),...
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
        labelH{aboveBelow+1} = text(mean(data_PP(1,data_PP(5,:) == 0 & data_PP(8,:) == aboveBelow),"omitnan"),...
            mean(data_PP(2,data_PP(5,:) == 0 & data_PP(8,:) == aboveBelow),"omitnan"),...
        meta.aboveBelowNames{aboveBelow+1},...
        'Rotation',textRotation,'Color',meta.pltCols{1});

        set(labelH{aboveBelow+1},'Position',labelH{aboveBelow+1}.Position + [0.002,0,0])

end

title('Birth Location (Tromsø ppts only)',...
    'FontSize',meta.fontSize.big,'FontWeight','normal')

xticks(A_xticks);
yticks(A_yticks);

%% zoom lines

% axes('Visible','off')
% plot([0,1],[0,1]);
annotation('line',[0.271666666666667,0.614333333333333],...
    [0.5026,0.58]);
annotation('line',[0.271666666666667,0.613666666666667],...
    [0.63,0.9]);

% 0.55,0.58,0.4,0.32

end
