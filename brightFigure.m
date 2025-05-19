function brightFigure(data,meta)

figure("Position",meta.figSize); hold on
tiledlayout(1,2)

% regression
nexttile, hold on
meta.regressionType = "global";
arc_compareWithPsychophysics(data,meta);

% "rainbow" plot
nexttile, hold on
rainbowFigure(data,meta);

end