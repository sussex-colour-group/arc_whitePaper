function rainbowFigure(data,meta)

% extracted/modified from arc_compareWithPsychophysics

lowerBound = 90;
upperBound = 100;

xlim([meta.edges{1,1}(1),meta.edges{1,1}(end)])
ylim([meta.edges{1,2}(1),meta.edges{1,2}(end)])
legend
axis square

xlabel('L/(L+M)')
ylabel('S/(L+M)')

seasonOrder = [4,1,2,3]; % re-order just for plotting purposes % TODO KILL THIS
meta.pltCols2 = [1,1,1;0.9,0.9,0.9;0.5,0.5,0.5;0,0,0];


for location = [0,1]
    for j = 1:4
        season = seasonOrder(j); % re-order just for plotting purposes

        PP_sub      = data.PP(1:2,data.PP(4,:) == season & data.PP(5,:) == location); % row4=season, row5=location (0 = Tromso, 1 = Oslo)
        MBarray     = data.NL(1:3,data.NL(4,:) == season & data.NL(5,:) == location); 

        bounds = NaN(size(lowerBound,2),2);
        bounds(1) = prctile(MBarray(3,:),lowerBound);
        bounds(2) = prctile(MBarray(3,:),upperBound);

        MBarray_sub  = MBarray(1:2,...
            MBarray(3,:) >  bounds(1) & ...
            MBarray(3,:) <= bounds(2));

        scatter(mean(PP_sub(1,:),'omitnan'),mean(PP_sub(2,:),'omitnan'),...
            'x',...
            'DisplayName',['pp - ',meta.locationNames{location+1},', ',meta.seasonNames{season}],...
            'MarkerEdgeColor',meta.pltCols{location+1},...
            'HandleVisibility','off');

        scatter(mean(MBarray_sub(1,:),'omitnan'),mean(MBarray_sub(2,:),'omitnan'),...
            'o',...
            'DisplayName',[meta.locationNames{location+1},', ',meta.seasonNames{season}],...
            'MarkerFaceColor',meta.pltCols2(j,:),...
            'MarkerEdgeColor',meta.pltCols{location+1},...
            'LineWidth',1);
    end
end
