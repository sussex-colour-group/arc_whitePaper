function whiteSnifferFigure(data,meta)

figure,
tiledlayout(2,2)

for location = [0,1]
    nexttile, hold on

    arc_2Dhist(data.PP(1,data.PP(5,:) == location),...
        data.PP(2,data.PP(5,:) == location),...
        meta);

    
end

end