function arc_2Dhist_splitByLocationAndSeason(data,meta)

figure("Position",meta.figSize);
tiledlayout(2,4,"TileSpacing","compact")

for location = [0,1]
    for season = [4,1,2,3]
        nexttile, hold on

        x = data(1,(data(5,:) == location & data(4,:) == season));
        y = data(2,(data(5,:) == location & data(4,:) == season));
        arc_2Dhist(x,y,meta)
        
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