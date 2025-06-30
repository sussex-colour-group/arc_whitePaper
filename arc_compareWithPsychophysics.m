function arc_compareWithPsychophysics(data,meta)

%%

% TODO Make it so that it doesn't load additional external files and uses
% the `data` bundle better
% TODO Several bits will break - work through and debug

%%

% clear, clc, close all

% load('MATLABdataExport.mat','MBarray_concat'); % Load file saved out of arc_plotMB
%
% seasonNames = {'Summer','Autumn','Winter','Spring'};
% locations = {'Tromso','Oslo'};

%%

% interval = 5;
% lowerBound = 10:interval:100-interval;
% upperBound = 10+interval:interval:100;

interval = meta.regression.range.interval;
lowerBound = meta.regression.range.lower:interval:100-interval;
upperBound = meta.regression.range.lower+interval:interval:100;

%% Closeness to psychophysics as a function of luminance
% for all data ("global")

if strcmp(meta.regression.type,"global")

    % MBarray = MBarray_concat(1:3,:);
    MBarray = data.NL(1:3,:);

    bounds = zeros(size(lowerBound,2),2);
    for i = 1:size(lowerBound,2)
        bounds(i,1) = prctile(MBarray(3,:),lowerBound(i));
        bounds(i,2) = prctile(MBarray(3,:),upperBound(i));
    end

    LLMmean = zeros(1,size(lowerBound,2));
    SLMmean = zeros(1,size(lowerBound,2));
    LLMstd = zeros(1,size(lowerBound,2));
    SLMstd = zeros(1,size(lowerBound,2));
    for i = 1:size(lowerBound,2)

        MBarray_sub  = MBarray(1:2,...
            MBarray(3,:) >  bounds(i,1) & ...
            MBarray(3,:) <= bounds(i,2));

        LLMmean(i) = mean(MBarray_sub(1,:));
        SLMmean(i) = mean(MBarray_sub(2,:));

        LLMstd(i) = std(MBarray_sub(1,:));
        SLMstd(i) = std(MBarray_sub(2,:));

    end

    % figure,
    % plot(mean([lowerBound;upperBound]),LLMmean);
    % xlabel('percentile')
    % ylabel('LLM')
    %
    % figure,
    % plot(mean([lowerBound;upperBound]),SLMmean);
    % xlabel('percentile')
    % ylabel('SLM')

    % load("/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/whiteResultsTable.mat",'resultsTable'); %psychophysicsData
    % load('C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis/whiteResultsTable.mat','resultsTable') % TODO Use "data" instead

    stdLLM = std(data.PP(1,:),"omitmissing");
    stdSLM = std(data.PP(2,:),"omitmissing");

    psychophysicsMean = [mean(data.PP(1,:),"omitnan"); mean(data.PP(2,:),"omitnan")];

    % figure, hold on

    x = mean([lowerBound;upperBound])';
    y = sqrt((psychophysicsMean(1)/stdLLM - LLMmean/stdLLM).^2 + (psychophysicsMean(2)/stdSLM - SLMmean/stdSLM).^2)';

    plot(x,y,'kx-','DisplayName','Euclidian Distance (scaled by PP std)');

    dy = mean([LLMstd'/stdLLM,SLMstd'/stdSLM],2);
    xfill = [x; flipud(x)];
    yfill = [y-dy; flipud(y+dy)];
    fill(xfill,yfill,...
        [0,0,0],'LineStyle','none','FaceAlpha',0.1,'DisplayName','std');

    xlim([min(lowerBound),max(upperBound)])
    xticks([10,xticks]);

    xlabel('percentile')
    ylabel('nanolambda-psychophysics difference')
    yline(0,'k:','HandleVisibility','off')

    mdl = fitlm(x,y);
    ypred = predict(mdl,x);
    plot(x,ypred,'--','DisplayName','Linear fit');
    % plot(mdl) % this plots the confidence intervals on the model line too
    disp(mdl.Coefficients(2,4)) %WARNING: this is two-tailed (it should be one).

    legend

end

%% Closeness to psychophysics as a function of luminance
% combined, but normalised within each season and location ("contextual")

if strcmp(meta.regression.type,"contextual")

    subsetSize = [];
    for location = [0,1]
        for season = 1:4
            subsetSize(location+1,season) = size(MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==location),2);
        end
    end

    rng(0); % set random number generator for reproducibility

    % conversion to percentiles
    Inorm_concat = [];
    MBarray_concat2 = [];
    LLMmean = NaN(2,4,size(lowerBound,2));
    SLMmean = NaN(2,4,size(lowerBound,2));
    LLMstd  = NaN(2,4,size(lowerBound,2));
    SLMstd  = NaN(2,4,size(lowerBound,2));
    for location = [0,1]
        for season = 1:4

            MBarray = MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==location);

            disp(size(MBarray))
            ds_i = randsample(size(MBarray,2),min(subsetSize(:)),false); %downsample index
            MBarray = MBarray(:,ds_i);
            disp(size(MBarray))

            MBarray_concat2 = [MBarray_concat2,MBarray];

            [~,I] = sort(MBarray(3,:)); % downside of this was of doing it - if there are equal values they are not assigned equal sorted values. This might be a better alternative: https://uk.mathworks.com/matlabcentral/answers/182131-percentile-of-a-value-based-on-array-of-data#comment_1863640 (but it's not working for me currently)
            I2 = zeros(size(I));
            for i = 1:size(I,2) % there must be a better way to do this...
                I2(i) = find(I == i);
            end
            Inorm(location+1,season,:) = (I2-1)/(size(I2,2)-1)*100;

            Inorm_concat = [Inorm_concat,squeeze(Inorm(location+1,season,:))'];

            for j = 1:size(lowerBound,2)

                MBarray_sub  = MBarray(1:2,...
                    Inorm(location+1,season,:) >  lowerBound(j) & ...
                    Inorm(location+1,season,:) <= upperBound(j));

                LLMmean(location+1,season,j) = mean(MBarray_sub(1,:));
                SLMmean(location+1,season,j) = mean(MBarray_sub(2,:));

                LLMstd(location+1,season,j) = std(MBarray_sub(1,:));
                SLMstd(location+1,season,j) = std(MBarray_sub(2,:));
            end
        end
    end

    LLMmean_concat = NaN(1,size(lowerBound,2));
    SLMmean_concat = NaN(1,size(lowerBound,2));
    LLMstd_concat = NaN(1,size(lowerBound,2));
    SLMstd_concat = NaN(1,size(lowerBound,2));

    for i = 1:size(lowerBound,2)
        MBarray_concat_sub  = MBarray_concat2(1:2,...
            Inorm_concat >  lowerBound(i) & ...
            Inorm_concat <= upperBound(i));

        LLMmean_concat(i) = mean(MBarray_concat_sub(1,:));
        SLMmean_concat(i) = mean(MBarray_concat_sub(2,:));

        LLMstd_concat(i) = std(MBarray_concat_sub(1,:));
        SLMstd_concat(i) = std(MBarray_concat_sub(2,:));
    end

    % figure,
    % plot(mean([lowerBound;upperBound]),LLMmean_concat);
    % xlabel('percentile')
    % ylabel('LLM')
    %
    % figure,
    % plot(mean([lowerBound;upperBound]),SLMmean_concat);
    % xlabel('percentile')
    % ylabel('SLM')

    load('C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis/whiteResultsTable.mat','resultsTable')

    stdLLM = std([resultsTable.MeanLLM],"omitmissing");
    stdSLM = std([resultsTable.MeanSLM],"omitmissing");

    psychophysicsMean = [mean([resultsTable.MeanLLM],"omitnan");mean([resultsTable.MeanSLM],"omitnan")];

    % figure, hold on
    x = mean([lowerBound;upperBound])';
    y = sqrt((psychophysicsMean(1)/stdLLM - LLMmean_concat/stdLLM).^2 + (psychophysicsMean(2)/stdSLM - SLMmean_concat/stdSLM).^2)';

    plot(x,y,'kx-','DisplayName','Euclidian Distance (scaled by PP std)');

    dy = mean([LLMstd_concat'/stdLLM,SLMstd_concat'/stdSLM],2);
    xfill = [x; flipud(x)];
    yfill = [y-dy; flipud(y+dy)];
    fill(xfill,yfill,...
        [0,0,0],'LineStyle','none','FaceAlpha',0.1,'DisplayName','std');

    xlabel('percentile')
    ylabel('Euclidian distance between mean NL and mean PP (scaled by PP std)')
    yline(0,'k:','HandleVisibility','off')

    mdl = fitlm(x,y);
    ypred = predict(mdl,x);
    plot(x,ypred,'--','DisplayName','Linear fit');
    % plot(mdl) % this plots the confidence intervals on the model line too
    disp(mdl.Coefficients(2,4)) %WARNING: this is two-tailed (it should be one).

    legend

end

%% Closeness to psychophysics as a function of luminance
% seperate (specific brightness - where the environment is compared to the corresponding psychophysics)

if strcmp(meta.regression.type,"specific")

    % load('/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/psychophysicsMeans.mat','psychophysicsMeans')
    load('C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis/psychophysicsMeans.mat','psychophysicsMeans')
    % TODO Use "data" instead

    plt = false;

    for location = [0,1]
        for season = 1:4

            ppMinusLLM(location+1,season,:) = psychophysicsMeans(1,season,location+1) - squeeze(LLMmean(location+1,season,:));
            ppMinusSLM(location+1,season,:) = psychophysicsMeans(2,season,location+1) - squeeze(SLMmean(location+1,season,:));

            if plt
                figure, hold on
                x = mean([lowerBound;upperBound])';
                y = sqrt((squeeze(ppMinusLLM(location+1,season,:))./stdLLM).^2 + (squeeze(ppMinusSLM(location+1,season,:))./stdSLM).^2);

                plot(x,y,'kx-','DisplayName','Euclidian Distance (scaled by PP std)');

                dy = mean([squeeze(LLMstd(location+1,season,:))/stdLLM,squeeze(SLMstd(location+1,season,:))/stdSLM],2);
                xfill = [x; flipud(x)];
                yfill = [y-dy; flipud(y+dy)];
                fill(xfill,yfill,...
                    [0,0,0],'LineStyle','none','FaceAlpha',0.1,'DisplayName','std');

                xlabel('percentile')
                ylabel('Euclidian distance between mean NL and mean PP (scaled by PP std)')
                yline(0,'k:','HandleVisibility','off')

                mdl = fitlm(x,y);
                ypred = predict(mdl,x);
                plot(x,ypred,'--','DisplayName','Linear fit');
                % plot(mdl) % this plots the confidence intervals on the model line too
                disp(mdl.Coefficients(2,4)) %WARNING: this is two-tailed (it should be one).

                legend
                title([seasonNames{season},', ',locations{location+1}])
            end
        end
    end

end

%% combined (specific brightness - where the environment is compared to the corresponding psychophysics)

if false % TODO reintegrate this
    figure, hold on
    x = mean([lowerBound;upperBound])';
    y = sqrt((squeeze(mean(mean(ppMinusLLM,2)))./stdLLM).^2 + (squeeze(mean(mean(ppMinusSLM,2)))./stdSLM).^2);

    plot(x,y,'kx-','DisplayName','Euclidian Distance (scaled by PP std)');

    dy = mean([squeeze(mean(mean(LLMstd,2)))/stdLLM,squeeze(mean(mean(SLMstd,2)))/stdSLM],2);
    xfill = [x; flipud(x)];
    yfill = [y-dy; flipud(y+dy)];
    fill(xfill,yfill,...
        [0,0,0],'LineStyle','none','FaceAlpha',0.1,'DisplayName','std');

    xlabel('percentile')
    ylabel('Euclidian distance between mean NL and mean PP (scaled by PP std)')
    yline(0,'k:','HandleVisibility','off')

    mdl = fitlm(x,y);
    ypred = predict(mdl,x);
    plot(x,ypred,'--','DisplayName','Linear fit');
    % plot(mdl) % this plots the confidence intervals on the model line too
    disp(mdl.Coefficients(2,4)) %WARNING: this is two-tailed (it should be one).

    legend


    % figure, hold on
    % tiledlayout(1,2)
    % nexttile, hold on
    %
    % plot(mean([lowerBound;upperBound]),squeeze(mean(mean(ppMinusLLM,2))));
    %
    % xlabel('percentile')
    % ylabel('deltaLLM (psychophysics - NL)')
    % yline(0,'k:')
    %
    % mdl = fitlm(mean([lowerBound;upperBound]),squeeze(mean(mean(ppMinusLLM,2))));
    % ypred = predict(mdl,mean([lowerBound;upperBound])');
    % plot(mean([lowerBound;upperBound]),ypred);
    % % mdl.Coefficients(2,4)
    %
    % nexttile, hold on
    % plot(mean([lowerBound;upperBound]),squeeze(mean(mean(ppMinusSLM,2))));
    %
    % xlabel('percentile')
    % ylabel('deltaSLM (psychophysics - NL)')
    % yline(0,'k:')
    %
    % mdl = fitlm(mean([lowerBound;upperBound]),squeeze(mean(mean(ppMinusSLM,2))));
    % ypred = predict(mdl,mean([lowerBound;upperBound])');
    % plot(mean([lowerBound;upperBound]),ypred);
    % % mdl.Coefficients(2,4)

end

%% 2D histograms of percentiles

if false % TODO reintegrate this

    pltCols = {'r','b'};

    lowerBound = 0:10:90;
    upperBound = 10:10:100;

    edges = {linspace(0.66,0.82,40) linspace(0,2,40)};

    for location = [0,1]
        figure, hold on
        tiledlayout(2,5);

        MBarray = MBarray_concat(1:3,MBarray_concat(5,:) == location); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

        for i = 1:length(lowerBound)
            nexttile,
            hold on
            MBarray_sub  = MBarray(1:2,...
                MBarray(3,:) >  prctile(MBarray(3,:),lowerBound(i)) & ...
                MBarray(3,:) <= prctile(MBarray(3,:),upperBound(i)));

            histogram2(MBarray_sub(1,:),MBarray_sub(2,:),...
                'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
                'DisplayStyle','tile','ShowEmptyBins','on');
            colormap('gray')
            axis tight square

            MeanOverCentile(location+1,1,i) = mean(MBarray_sub(1,:));
            MeanOverCentile(location+1,2,i) = mean(MBarray_sub(2,:));
            scatter(MeanOverCentile(location+1,1,i),...
                MeanOverCentile(location+1,2,i),...
                pltCols{location+1},'filled','MarkerEdgeColor',[1,1,1])

            title([locations{location+1},', ',num2str(lowerBound(i)),':',num2str(upperBound(i)),'%'])
        end
    end

    % both locations combined
    MBarray = MBarray_concat(1:3,:); % row4=season, row5=location (0 = Tromso, 1 = Oslo)
    for i = 1:length(lowerBound)
        MBarray_sub  = MBarray(1:2,...
            MBarray(3,:) >  prctile(MBarray(3,:),lowerBound(i)) & ...
            MBarray(3,:) <= prctile(MBarray(3,:),upperBound(i)));

        MeanOverCentile(3,1,i) = mean(MBarray_sub(1,:));
        MeanOverCentile(3,2,i) = mean(MBarray_sub(2,:));
    end

end

%% Plot change over centile

if false % TODO reintegrate this

    % load('/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/psychophysicsMeans.mat','psychophysicsMeans')
    load('C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis\psychophysicsMeans.mat','psychophysicsMeans')
    % psychophysicsMeans = mean(psychophysicsMeans,2);

    figure; hold on
    xlim([edges{1,1}(1),edges{1,1}(end)])
    ylim([edges{1,2}(1),edges{1,2}(end)])
    % legend

    for location = [0,1]
        scatter(psychophysicsMeans(1,:,location+1),...
            psychophysicsMeans(2,:,location+1),...
            'x','MarkerEdgeColor',pltCols{location+1},...
            'DisplayName',locations{location+1});

        % scatter(mean(MBarray_concat(1,MBarray_concat(5,:) == location)),...
        %     mean(MBarray_concat(2,MBarray_concat(5,:) == location)),...
        %     'o','MarkerEdgeColor',pltCols{location+1},...
        %     'DisplayName',locations{location+1});

        % plot(squeeze(MeanOverCentile(location+1,1,3:end)),...
        %     squeeze(MeanOverCentile(location+1,2,3:end)),...
        %     'o-','Color',pltCols{location+1},...
        %     'DisplayName',locations{location+1})
    end

    plot(squeeze(MeanOverCentile(3,1,3:end)),...
        squeeze(MeanOverCentile(3,2,3:end)),...
        'o-','Color','k')

    xlabel('L/(L+M)')
    ylabel('S/(L+M)')
    axis square

end

%% Top 10% split by location and season

if false % TODO reintegrate this

    figure,
    tcl = tiledlayout(2,4);
    title(tcl,'Top 10%, split by location and season')

    locations = {'Tromso','Oslo'};
    lowerBound = 90;
    upperBound = 100;

    for location = [0,1]
        for season = 1:4

            MBarray = MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==location); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            MBarray_sub  = MBarray(1:2,...
                MBarray(3,:) >  prctile(MBarray(3,:),lowerBound) & ...
                MBarray(3,:) <= prctile(MBarray(3,:),upperBound));

            nexttile, hold on
            histogram2(MBarray_sub(1,:),...
                MBarray_sub(2,:),...
                'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
                'DisplayStyle','tile','ShowEmptyBins','on');
            colorbar
            colormap('gray')
            axis tight square
            text(0.72,1.4,[locations{location+1},', ',seasonNames{season}],...
                'Color',[1,1,1]); %,'FontSize',20
        end
    end

end

%%

if false % TODO reintegrate this

    % difference between psychophysics and NL data, split by location

    % load("/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/whiteResultsTable.mat"); %psychophysicsData
    load('C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis/whiteResultsTable.mat','resultsTable')

    pp_LLM = [resultsTable.MeanLLM];
    pp_SLM = [resultsTable.MeanSLM];

    stdLLM = std(pp_LLM,"omitmissing");
    stdSLM = std(pp_SLM,"omitmissing");

    pp_LLM_t = [resultsTable([resultsTable.testLocation] == 0).MeanLLM]; %Tromso
    pp_SLM_t = [resultsTable([resultsTable.testLocation] == 0).MeanSLM]; %Tromso

    pp_LLM_o = [resultsTable([resultsTable.testLocation] == 1).MeanLLM]; %Oslo
    pp_SLM_o = [resultsTable([resultsTable.testLocation] == 1).MeanSLM]; %Oslo

    figure, hold on
    histogram2(pp_LLM_t,pp_SLM_t,...
        'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
        'DisplayStyle','tile','ShowEmptyBins','on');
    colormap('gray')
    axis tight square
    scatter(mean(pp_LLM_t,'omitnan'),mean(pp_SLM_t,'omitnan'),'r','filled','MarkerEdgeColor',[1,1,1])
    title('Tromso - psychophysics')

    figure, hold on
    histogram2(pp_LLM_o,pp_SLM_o,...
        'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
        'DisplayStyle','tile','ShowEmptyBins','on');
    colormap('gray')
    axis tight square
    scatter(mean(pp_LLM_o,'omitnan'),mean(pp_SLM_o,'omitnan'),'b','filled','MarkerEdgeColor',[1,1,1])
    title('Oslo - psychophysics')

end

%%

if false % TODO reintegrate this

    lowerBound = 90;
    upperBound = 100;

    equatedBySeason = true;
    cutoffAcrossLocations = true;

    if ~equatedBySeason
        if cutoffAcrossLocations

            MBarray_t = MBarray_concat(1:3,MBarray_concat(5,:)==0); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            bounds = zeros(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray_t(3,:),lowerBound);
            bounds(2) = prctile(MBarray_t(3,:),upperBound);

            MBarray_t_sub  = MBarray_t(1:2,...
                MBarray_t(3,:) >  bounds(1) & ...
                MBarray_t(3,:) <= bounds(2));

            MBarray_o = MBarray_concat(1:3,MBarray_concat(5,:)==1); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            bounds = zeros(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray_o(3,:),lowerBound);
            bounds(2) = prctile(MBarray_o(3,:),upperBound);

            MBarray_o_sub  = MBarray_o(1:2,...
                MBarray_o(3,:) >  bounds(1) & ...
                MBarray_o(3,:) <= bounds(2));
        else
            bounds = zeros(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray_concat(3,:),lowerBound);
            bounds(2) = prctile(MBarray_concat(3,:),upperBound);

            MBarray_t = MBarray_concat(1:3,MBarray_concat(5,:)==0); % row4=season, row5=location (0 = Tromso, 1 = Oslo)
            MBarray_t_sub  = MBarray_t(1:2,...
                MBarray_t(3,:) >  bounds(1) & ...
                MBarray_t(3,:) <= bounds(2));

            MBarray_o = MBarray_concat(1:3,MBarray_concat(5,:)==1); % row4=season, row5=location (0 = Tromso, 1 = Oslo)
            MBarray_o_sub  = MBarray_o(1:2,...
                MBarray_o(3,:) >  bounds(1) & ...
                MBarray_o(3,:) <= bounds(2));
        end

    else
        MBarray_t_sub = [];
        MBarray_o_sub = [];
        for season = 1:4

            MBarray_t_temp = MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==0); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            bounds = zeros(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray_t_temp(3,:),lowerBound);
            bounds(2) = prctile(MBarray_t_temp(3,:),upperBound);

            MBarray_t_sub  = [MBarray_t_sub,...
                MBarray_t_temp(1:2,...
                MBarray_t_temp(3,:) >  bounds(1) & ...
                MBarray_t_temp(3,:) <= bounds(2))];

            MBarray_o_temp = MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==1); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            bounds = zeros(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray_o_temp(3,:),lowerBound);
            bounds(2) = prctile(MBarray_o_temp(3,:),upperBound);

            MBarray_o_sub  = [MBarray_o_sub,...
                MBarray_o_temp(1:2,...
                MBarray_o_temp(3,:) >  bounds(1) & ...
                MBarray_o_temp(3,:) <= bounds(2))];

        end
    end

    figure, hold on
    histogram2(MBarray_t_sub(1,:),MBarray_t_sub(2,:),...
        'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
        'DisplayStyle','tile','ShowEmptyBins','on');
    colormap('gray')
    axis tight square
    scatter(mean(MBarray_t_sub(1,:),'omitnan'),mean(MBarray_t_sub(2,:),'omitnan'),'rs','filled','MarkerEdgeColor',[1,1,1])
    title(['Tromso - NL (',num2str(lowerBound),'-',num2str(upperBound),')'])

    figure, hold on
    histogram2(MBarray_o_sub(1,:),MBarray_o_sub(2,:),...
        'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
        'DisplayStyle','tile','ShowEmptyBins','on');
    colormap('gray')
    axis tight square
    scatter(mean(MBarray_o_sub(1,:),'omitnan'),mean(MBarray_o_sub(2,:),'omitnan'),'bs','filled','MarkerEdgeColor',[1,1,1])
    title(['Oslo - NL (',num2str(lowerBound),'-',num2str(upperBound),')'])

    figure, hold on
    scatter(mean(pp_LLM_t,'omitnan'),mean(pp_SLM_t,'omitnan'),'r','filled','MarkerEdgeColor',[1,1,1],'DisplayName','pp_t')
    scatter(mean(pp_LLM_o,'omitnan'),mean(pp_SLM_o,'omitnan'),'b','filled','MarkerEdgeColor',[1,1,1],'DisplayName','pp_o')
    scatter(mean(MBarray_t_sub(1,:),'omitnan'),mean(MBarray_t_sub(2,:),'omitnan'),'rs','filled','MarkerEdgeColor',[1,1,1],'DisplayName','nl_t')
    scatter(mean(MBarray_o_sub(1,:),'omitnan'),mean(MBarray_o_sub(2,:),'omitnan'),'bs','filled','MarkerEdgeColor',[1,1,1],'DisplayName','nl_o')
    legend
    xlim([edges{1,1}(1),edges{1,1}(end)])
    ylim([edges{1,2}(1),edges{1,2}(end)])

    rng(0)
    ed = [];
    for i = 1:1000
        randIndex = randsample(size(pp_LLM_t,2),size(pp_LLM_t,2),true);
        pp_LLM_t_bs = pp_LLM_t(randIndex);
        pp_SLM_t_bs = pp_SLM_t(randIndex);

        randIndex = randsample(size(MBarray_t_sub,2),size(MBarray_t_sub,2),true);
        nl_LLM_t_bs = MBarray_t_sub(1,randIndex);
        nl_SLM_t_bs = MBarray_t_sub(2,randIndex);

        randIndex = randsample(size(pp_LLM_o,2),size(pp_LLM_o,2),true);
        pp_LLM_o_bs = pp_LLM_o(randIndex);
        pp_SLM_o_bs = pp_SLM_o(randIndex);

        randIndex = randsample(size(MBarray_o_sub,2),size(MBarray_o_sub,2),true);
        nl_LLM_o_bs = MBarray_o_sub(1,randIndex);
        nl_SLM_o_bs = MBarray_o_sub(2,randIndex);

        % compute euclidian distance
        % direct comparisons
        ed(i,1) = sqrt(...
            (mean(pp_LLM_t_bs,'omitnan')/stdLLM - mean(nl_LLM_t_bs,'omitnan')/stdLLM)^2 + ...
            (mean(pp_SLM_t_bs,'omitnan')/stdSLM - mean(nl_SLM_t_bs,'omitnan')/stdSLM)^2 );

        ed(i,2) = sqrt(...
            (mean(pp_LLM_o_bs,'omitnan')/stdLLM - mean(nl_LLM_o_bs,'omitnan')/stdLLM)^2 + ...
            (mean(pp_SLM_o_bs,'omitnan')/stdSLM - mean(nl_SLM_o_bs,'omitnan')/stdSLM)^2 );

        % cross comparisons
        ed(i,3) = sqrt(...
            (mean(pp_LLM_t_bs,'omitnan')/stdLLM - mean(nl_LLM_o_bs,'omitnan')/stdLLM)^2 + ...
            (mean(pp_SLM_t_bs,'omitnan')/stdSLM - mean(nl_SLM_o_bs,'omitnan')/stdSLM)^2 );

        ed(i,4) = sqrt(...
            (mean(pp_LLM_o_bs,'omitnan')/stdLLM - mean(nl_LLM_t_bs,'omitnan')/stdLLM)^2 + ...
            (mean(pp_SLM_o_bs,'omitnan')/stdSLM - mean(nl_SLM_t_bs,'omitnan')/stdSLM)^2 );

    end

    figure, hold on
    boxplot(ed)
    yline(0,'k:')
    xticklabels({'pp_t vs nl_t','pp_o vs nl_o','pp_t vs nl_o','pp_o vs nl_t'})
    % ylim([0,10])
    ylabel('Scaled euclidian distance between PP and NL')

    % [~,p] = ttest(ed(:,1),ed(:,3))
    % [~,p] = ttest(ed(:,1),ed(:,4))
    %
    % [~,p] = ttest(ed(:,2),ed(:,3))
    % [~,p] = ttest(ed(:,2),ed(:,4))

end

%% difference between psychophysics and NL data, split by location AND season

if false % TODO reintegrate this

    % load("/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/whiteResultsTable.mat"); %psychophysicsData
    load("C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis\whiteResultsTable.mat"); %psychophysicsData

    lowerBound = 90;
    upperBound = 100;

    figure; hold on
    xlim([edges{1,1}(1),edges{1,1}(end)])
    ylim([edges{1,2}(1),edges{1,2}(end)])
    legend
    axis square

    xlabel('L/(L+M)')
    ylabel('S/(L+M)')

    MBarray_null = cell(1,2);
    rng(0)
    for location = [0,1] % null

        subsetSize = [];
        for season = 1:4
            subsetSize(season) = size(MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==location),2);
        end

        MBarray_null_temp = [];
        for season = 1:4
            MBarray_temp = MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==location);
            MBarray_temp2 = MBarray_temp(1:3,randsample(size(MBarray_temp,2),min(subsetSize)));

            bounds_null = NaN(size(lowerBound,2),2);
            bounds_null(1) = prctile(MBarray_temp2(3,:),lowerBound);
            bounds_null(2) = prctile(MBarray_temp2(3,:),upperBound);

            MBarray_sub_null  = MBarray_temp2(1:2,...
                MBarray_temp2(3,:) >  bounds_null(1) & ...
                MBarray_temp2(3,:) <= bounds_null(2));

            MBarray_null_temp = [MBarray_null_temp,MBarray_sub_null];
        end
        MBarray_null{location+1} = MBarray_null_temp;
    end

    seasonOrder = [4,1,2,3]; % re-order just for plotting purposes
    pltCols2 = [1,1,1;0.9,0.9,0.9;0.5,0.5,0.5;0,0,0];

    rng(0)
    nl_LLM_bs_null = [];
    nl_SLM_bs_null = [];
    ed = [];
    for location = [0,1]
        for j = 1:4
            season = seasonOrder(j); % re-order just for plotting purposes

            pp_LLM_sub      = [resultsTable([resultsTable.testLocation] == location & [resultsTable.testSeason] == season).MeanLLM];
            pp_SLM_sub      = [resultsTable([resultsTable.testLocation] == location & [resultsTable.testSeason] == season).MeanSLM];

            MBarray         = MBarray_concat(1:3,MBarray_concat(4,:) == season & MBarray_concat(5,:) == location); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            bounds = NaN(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray(3,:),lowerBound);
            bounds(2) = prctile(MBarray(3,:),upperBound);

            MBarray_sub  = MBarray(1:2,...
                MBarray(3,:) >  bounds(1) & ...
                MBarray(3,:) <= bounds(2));

            scatter(mean(pp_LLM_sub,'omitnan'),mean(pp_SLM_sub,'omitnan'),...
                'x',...
                'DisplayName',['pp - ',locations{location+1},', ',seasonNames{season}],...
                'MarkerEdgeColor',pltCols{location+1},...
                'HandleVisibility','off');

            scatter(mean(MBarray_sub(1,:),'omitnan'),mean(MBarray_sub(2,:),'omitnan'),...
                'o',...
                'DisplayName',[locations{location+1},', ',seasonNames{season}],...
                'MarkerFaceColor',pltCols2(j,:),...
                'MarkerEdgeColor',pltCols{location+1},...
                'LineWidth',1);

            % bootstrap difference
            for i = 1:1000
                randIndex = randsample(size(pp_LLM_sub,2),size(pp_LLM_sub,2),true);
                pp_LLM_bs = pp_LLM_sub(randIndex);
                pp_SLM_bs = pp_SLM_sub(randIndex);

                randIndex = randsample(size(MBarray_sub,2),size(MBarray_sub,2),true);
                nl_LLM_bs = MBarray_sub(1,randIndex);
                nl_SLM_bs = MBarray_sub(2,randIndex);

                % ed(i,location+1,season) = sqrt(...
                %     (mean(pp_LLM_bs,'omitnan') - mean(nl_LLM_bs,'omitnan'))^2 + ...
                %     (mean(pp_SLM_bs,'omitnan') - mean(nl_SLM_bs,'omitnan'))^2 );

                ed(i,location+1,season) = sqrt(...
                    (mean(pp_LLM_bs,'omitnan')/stdLLM - mean(nl_LLM_bs,'omitnan')/stdLLM)^2 + ...
                    (mean(pp_SLM_bs,'omitnan')/stdSLM - mean(nl_SLM_bs,'omitnan')/stdSLM)^2 );

                randIndex = randsample(size(MBarray_null{location+1},2),size(MBarray_null{location+1},2),true);
                nl_LLM_bs_null{location+1}(i,:) = MBarray_null{location+1}(1,randIndex);
                nl_SLM_bs_null{location+1}(i,:) = MBarray_null{location+1}(2,randIndex);

                % ed_null(i,location+1,season) = sqrt(...
                %     (mean(pp_LLM_bs,'omitnan') - mean(nl_LLM_bs_null,'omitnan'))^2 + ...
                %     (mean(pp_SLM_bs,'omitnan') - mean(nl_SLM_bs_null,'omitnan'))^2 );

                ed_null(i,location+1,season) = sqrt(...
                    (mean(pp_LLM_bs,'omitnan')/stdLLM - mean(nl_LLM_bs_null{location+1}(i,:),'omitnan')/stdLLM)^2 + ...
                    (mean(pp_SLM_bs,'omitnan')/stdSLM - mean(nl_SLM_bs_null{location+1}(i,:),'omitnan')/stdSLM)^2 );
            end

            % comparing seasonal pp and null/overall mean
            % plot([mean(MBarray_null{location+1}(1,:),'omitnan'),mean(pp_LLM_sub,'omitnan')],...
            %     [mean(MBarray_null{location+1}(2,:),'omitnan'),mean(pp_SLM_sub,'omitnan')],...
            %     'k','HandleVisibility','off')
        end

        % null/overall mean
        % scatter(mean(MBarray_null{location+1}(1,:),'omitnan'),mean(MBarray_null{location+1}(2,:),'omitnan'),...
        %     '+',...
        %     'DisplayName',['nl - ',locations{location+1},', ','overall'],...
        %     'MarkerEdgeColor',seasonCols(season,:).*[location,1,~location],...
        %     'MarkerFaceColor',seasonCols(season,:).*[location,1,~location],...
        %     'LineWidth',3);
    end

end

%%

if false % TODO reintegrate this

    figure, hold on
    tiledlayout(2,2)
    for location = [0,1]
        % figure, hold on
        nexttile
        boxplot(squeeze(ed(:,location+1,:)))
        xticklabels(seasonNames)
        title(locations{location+1})
        ylabel('Scaled euclidian distance between seasonal PP and seasonal NL')
        ylim([0,10])

        % nulls

        % figure, hold on
        nexttile
        boxplot(squeeze(ed_null(:,location+1,:)))
        xticklabels(seasonNames)
        title(locations{location+1})
        ylabel('Scaled euclidian distance between seasonal PP and all NL')
        ylim([0,10])
    end

    %

    figure,
    tiledlayout(1,2);
    for location = [0,1]
        nexttile,
        hold on

        histogram2(nl_LLM_bs_null{location+1}(1000,:),nl_SLM_bs_null{location+1}(1000,:),...
            'XBinEdges',edges{1,1},'YBinEdges',edges{1,2},...
            'DisplayStyle','tile','ShowEmptyBins','on');
        colormap('gray')
        axis tight square

        scatter(mean(nl_LLM_bs_null{location+1}(1000,:),'omitnan'),mean(nl_SLM_bs_null{location+1}(1000,:),'omitnan'),...
            'k','filled','MarkerEdgeColor',[1,1,1])

        title(locations{location+1})

    end

end

%% difference between psychophysics and NL data, split by location AND season, fully split

if false % TODO reintegrate this

    % load("/home/danny/cisc2/projects/colour_arctic/code/arc_PsychophysicsAnalysis/whiteResultsTable.mat"); %psychophysicsData
    load('C:\Users\cege-user\Documents\arc_PsychophysicsAnalysis/whiteResultsTable.mat','resultsTable')

    lowerBound = 90;
    upperBound = 100;

    figure; hold on
    xlim([edges{1,1}(1),edges{1,1}(end)])
    ylim([edges{1,2}(1),edges{1,2}(end)])
    legend
    axis square

    xlabel('L/(L+M)')
    ylabel('S/(L+M)')

    iSeasons = 1:4;

    bootstrap_ = true;

    rng(0)
    ed = [];
    for location = [0,1]
        for season = 1:4

            pp_LLM_sub      = [resultsTable([resultsTable.testLocation] == location & [resultsTable.testSeason] == season).MeanLLM];
            pp_SLM_sub      = [resultsTable([resultsTable.testLocation] == location & [resultsTable.testSeason] == season).MeanSLM];

            %

            MBarray         = MBarray_concat(1:3,MBarray_concat(4,:)==season & MBarray_concat(5,:)==location); % row4=season, row5=location (0 = Tromso, 1 = Oslo)

            bounds = NaN(size(lowerBound,2),2);
            bounds(1) = prctile(MBarray(3,:),lowerBound);
            bounds(2) = prctile(MBarray(3,:),upperBound);

            MBarray_sub  = MBarray(1:2,...
                MBarray(3,:) >  bounds(1) & ...
                MBarray(3,:) <= bounds(2));

            if bootstrap_
                % bootstrap difference
                for i = 1:100
                    randIndex = randsample(size(pp_LLM_sub,2),size(pp_LLM_sub,2),true);
                    pp_LLM_bs = pp_LLM_sub(randIndex);
                    pp_SLM_bs = pp_SLM_sub(randIndex);

                    scatter(mean(pp_LLM_bs,'omitnan'),mean(pp_SLM_bs,'omitnan'),...
                        'x',...
                        'DisplayName',['pp - ',locations{location+1},', ',seasonNames{season}])

                    randIndex = randsample(size(MBarray_sub,2),size(MBarray_sub,2),true);
                    nl_LLM_bs = MBarray_sub(1,randIndex);
                    nl_SLM_bs = MBarray_sub(2,randIndex);

                    scatter(mean(nl_LLM_bs,'omitnan'),mean(nl_SLM_bs,'omitnan'),...
                        'DisplayName',['nl - ',locations{location+1},', ',seasonNames{season}])


                    % ed(i,location+1,season) = sqrt(...
                    %     (mean(pp_LLM_bs,'omitnan') - mean(nl_LLM_bs,'omitnan'))^2 + ...
                    %     (mean(pp_SLM_bs,'omitnan') - mean(nl_SLM_bs,'omitnan'))^2 );

                    ed(i,location+1,season,1) = sqrt(...
                        (mean(pp_LLM_bs,'omitnan')/stdLLM - mean(nl_LLM_bs,'omitnan')/stdLLM)^2 + ...
                        (mean(pp_SLM_bs,'omitnan')/stdSLM - mean(nl_SLM_bs,'omitnan')/stdSLM)^2 );

                    for j = 1:3

                        iSeasons2 = iSeasons(iSeasons~=season);

                        MBarray_null = MBarray_concat(1:3,MBarray_concat(4,:)==iSeasons2(j) & MBarray_concat(5,:)==location);

                        bounds = NaN(size(lowerBound,2),2);
                        bounds(1) = prctile(MBarray_null(3,:),lowerBound);
                        bounds(2) = prctile(MBarray_null(3,:),upperBound);

                        MBarray_null  = MBarray_null(1:2,...
                            MBarray_null(3,:) >  bounds(1) & ...
                            MBarray_null(3,:) <= bounds(2));

                        randIndex = randsample(size(MBarray_null,2),size(MBarray_null,2),true);
                        nl_LLM_bs_null = MBarray_null(1,randIndex);
                        nl_SLM_bs_null = MBarray_null(2,randIndex);

                        % ed_null(i,location+1,season) = sqrt(...
                        %     (mean(pp_LLM_bs,'omitnan') - mean(nl_LLM_bs_null,'omitnan'))^2 + ...
                        %     (mean(pp_SLM_bs,'omitnan') - mean(nl_SLM_bs_null,'omitnan'))^2 );

                        ed(i,location+1,season,j+1) = sqrt(...
                            (mean(pp_LLM_bs,'omitnan')/stdLLM - mean(nl_LLM_bs_null,'omitnan')/stdLLM)^2 + ...
                            (mean(pp_SLM_bs,'omitnan')/stdSLM - mean(nl_SLM_bs_null,'omitnan')/stdSLM)^2 );
                    end
                end
            end
        end
    end

end

%%

if false % TODO reintegrate this

    figure, hold on
    tiledlayout(2,1)
    for location = [0,1]
        % figure, hold on
        nexttile
        boxplot([squeeze(ed(:,location+1,1,:)),squeeze(ed(:,location+1,2,:)),squeeze(ed(:,location+1,3,:)),squeeze(ed(:,location+1,4,:))],...
            'color','krrr')
        xline(4.5:4:16)
        title(locations{location+1})
        ylabel({'Scaled euclidian distance','between seasonal PP and seasonal NL'})
        ylim([0,10])

        xtl = {'Summer pp vs Summer nl',...
            'Summer pp vs Autumn nl',...
            'Summer pp vs Winter nl',...
            'Summer pp vs Spring nl',...
            'Autumn pp vs Autumn nl',...
            'Autumn pp vs Summer nl',...
            'Autumn pp vs Winter nl',...
            'Autumn pp vs Spring nl',...
            'Winter pp vs Winter nl',...
            'Winter pp vs Summer nl',...
            'Winter pp vs Autumn nl',...
            'Winter pp vs Spring nl',...
            'Spring pp vs Spring nl',...
            'Spring pp vs Summer nl',...
            'Spring pp vs Autumn nl',...
            'Spring pp vs Winter nl'};
        xticklabels(xtl)
    end

    %% Spectra of top 1% and 10%

    % specArray = [];
    % for i = 1:length(fileList)
    %     specArray = [specArray;fileList(i).concatSpecArray(2:end,:)];
    % end
    %
    % lowerBound = 90;
    % upperBound = 100;
    %
    % bounds = zeros(size(lowerBound,2),2);
    % for i = 1:size(lowerBound,2)
    %     bounds(i,1) = prctile(MBarray(3,:),lowerBound(i));
    %     bounds(i,2) = prctile(MBarray(3,:),upperBound(i));
    % end
    %
    % for i = 1:size(lowerBound,2)
    %     specArray_sub  = specArray(...
    %         MBarray(3,:) >  bounds(i,1) & ...
    %         MBarray(3,:) <= bounds(i,2),...
    %         :);
    % end
    %
    % figure,
    % plot(390:5:760,specArray_sub(1:100:end,:))

end

end
