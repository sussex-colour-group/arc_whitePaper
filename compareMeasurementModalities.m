function compareMeasurementModalities(data,meta,SW)
% Compare across measurement modalities
% means and CI for Go Pro, Hyperspectral and Nanolambda on one figure to visualise equivalence

data_restructured{1} = data.GoPro;
data_restructured{2} = data.NL_denoised; % Note: this uses the version of the NL data with the dark noise reduction applies
data_restructured{3} = data.HS;

lims(:,1) = [0.66,0.82];
lims(:,2) = [0,2];
lims(:,6) = [0,1];

figure, hold on
tiledlayout(2,3)

for location = [0,1]
    for param = [1,2,6]
        nexttile, hold on

        for i = 1:3
            if SW
                SWindex = data_restructured{i}(4,:) == 1 | data_restructured{i}(4,:) == 3; % index of summer or winter measurements
            else
                SWindex = true(size(data_restructured{i}(4,:)));
            end
            [~,err] = compute95pctCI(data_restructured{i}(param,data_restructured{i}(5,:) == location & SWindex));

            errorbar(i,mean(data_restructured{i}(param,data_restructured{i}(5,:) == location & SWindex),"omitnan"),...
                err,...
                'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
                'DisplayName',[meta.locationNames{location+1}])

        end

        title(meta.paramNames{param})
        ylabel(meta.locationNames{location+1})
        ylim(lims(:,param));

        xticks([1,2,3])
        xlim([0.5,3.5])
        xticklabels({'GoPro','NL','Hyperspec'})
    end
end

% %%%%%%%%%%%% TODO Make work
% if SW 
%     title('Summer and Winter only')
% else
%     title('All seasons')
% end

%% TODOs

% - Compute CL for GoPro and NL
% - Do we want to (roughly) equate over season?

%% split by season

% for location = [0,1]
%     for i = 1:3 
%         for season = 1:4
%         nexttile, hold on
% 
%             [~,xneg] = compute95pctCI(data_restructured{i}(1,data_restructured{i}(5,:) == location & data_restructured{i}(4,:) == season));
%             xpos = xneg;
%             [~,yneg] = compute95pctCI(data_restructured{i}(2,data_restructured{i}(5,:) == location & data_restructured{i}(4,:) == season));
%             ypos = yneg;
% 
%             errorbar(mean(data_restructured{i}(1,data_restructured{i}(5,:) == location & data_restructured{i}(4,:) == season),"omitnan"),...
%                 mean(data_restructured{i}(2,data_restructured{i}(5,:) == location & data_restructured{i}(4,:) == season),"omitnan"),...
%                 yneg,ypos,xneg,xpos,...
%                 'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
%                 'DisplayName',[meta.locationNames{location+1},' - ',meta.seasonNames{season}])
%         end
%     end
% end




