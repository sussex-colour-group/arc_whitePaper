function NLDarkNoisePlot(data,meta)

figure("Position",meta.figSize);
tiledlayout(2,3)

[~,I] = sort(data(3,:));
[~,I2] = sort(I);
Inorm = (I2-1)/(size(I2,2)-1)*100;

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

meta.edges = {linspace(0.55,0.9,40) linspace(0,8,40)};

nexttile
hold on
arc_2Dhist(data(1,:),...
        data(2,:),...
        meta);
daspect('auto')
xlabel('L/(L+M)','FontSize',meta.fontSize.small)
ylabel('S/(L+M)','FontSize',meta.fontSize.small)

nexttile
hold on
arc_2Dhist(data(1,Inorm < 10),...
        data(2,Inorm < 10),...
        meta);
daspect('auto')
xlabel('L/(L+M)','FontSize',meta.fontSize.small)

nexttile
hold on
arc_2Dhist(data(1,Inorm >= 10),...
        data(2,Inorm >= 10),...
        meta);
daspect('auto')
xlabel('L/(L+M)','FontSize',meta.fontSize.small)

end