function NLDarkNoisePlot(data,meta)

Inorm = computeInorm(data);

%%

figure("Position",meta.figSize);
tiledlayout(2,3)

%%

% modified from `sussex_nanolambda/investigateDarkNoise.m`

nexttile
histogram(data(3,Inorm < 5),...
    'FaceColor','k')
xlim([-1*10^-7,max(xlim)])
xline(0,'k:')
xlabel('L+M','FontSize',meta.fontSize.small)
ylabel('Count','FontSize',meta.fontSize.small)

nexttile
histogram(data(3,Inorm < 15),'NumBins',100,...
    'FaceColor','k')
xline(0,'k:')
xline(2*10^-6)
xlabel('L+M','FontSize',meta.fontSize.small)
ylabel('Count','FontSize',meta.fontSize.small)

nexttile
scatter(data(3,:),Inorm,'k.');
xlim([0,7*10^-6])
yline(10)
xline(2*10^-6)
xlabel('L+M','FontSize',meta.fontSize.small)
ylabel('Percentile','FontSize',meta.fontSize.small)

%% 2D histograms

meta.edges = {linspace(0.55,0.9,40) linspace(0,4,40)};

datasubset{1} = data;
datasubset{2} = data(:,Inorm < 10);
datasubset{3} = data(:,Inorm >= 10);

for i = 1:3

    nexttile
    hold on

    arc_2Dhist(datasubset{i}(1,:),...
        datasubset{i}(2,:),...
        meta,true);
    pbaspect auto
    xlabel('L/(L+M)','FontSize',meta.fontSize.small)
    ylabel('S/(L+M)','FontSize',meta.fontSize.small)
    xlim([min(meta.edges{1}),max(meta.edges{1})]);
    ylim([min(meta.edges{2}),max(meta.edges{2})]);

    scatter(mean(datasubset{i}(1,:),"omitnan"),...
        mean(datasubset{i}(2,:),"omitnan"),...
        'o','Color','k','MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[0.5,0.5,0.5])

    text(mean(datasubset{i}(1,:),"omitnan") + 0.02,...
        mean(datasubset{i}(2,:),"omitnan"),...
        [num2str(mean(datasubset{i}(1,:),"omitnan"),'%.3f'),', ',num2str(mean(datasubset{i}(2,:),"omitnan"),'%.3f')],...
        'Color','w');
end

end