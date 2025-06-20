% Process data into the format needed

clc, clear, close all

%% Raw data location:

% TBC, TODO
% (wider project link: https://osf.io/z576y/)

%% Manual steps required:

% - Download data
% - Unzip it
% - Place it in the data/raw/psychophysics directory (or elsewhere)
% - Modify `getLocalPaths.m` stating where you put it 
% (and where you want the processed files to be saved)

%% define paths

repoHomeDir = ['..',filesep,'..',filesep,'..'];
addpath(repoHomeDir)
addpath([repoHomeDir,filesep,'imageanalysis'])

localPaths = getLocalPaths();
dataDir = localPaths.PPRawData;

%% Load data

filesinfolder = dir([dataDir,filesep,'arc_WhiteSettings*.mat']);

dataForCLConversion = load(localPaths.PPProcessedData,'resultsTable'); % careful this doesn't get circular - for some changes we might need to run this script twice

for i = 1:length(filesinfolder)
    try
        fileName = filesinfolder(i).name;

        resultsTable(i).testLocation = contains(fileName,'_o'); % 1 for Oslo, 0 for Tromso
        resultsTable(i).ppt = fileName([19:21,23]);

        load([dataDir, filesep, fileName],'output','timestart')

        settingsLLM = output(:,3); % LLM
        settingsSLM = output(:,4); % SLM

        resultsTable(i).MeanLLM = mean(settingsLLM);
        resultsTable(i).MeanSLM = mean(settingsSLM);

        if isnan(resultsTable(i).MeanLLM) % TODO The more robust way of doing this would be to edit MacBtoCL to return NaN when given NaN (it currently returns 0)
            resultsTable(i).CL = NaN;
        else
            resultsTable(i).CL = MacBtoCL([resultsTable(i).MeanLLM;resultsTable(i).MeanSLM],...
                [std([dataForCLConversion.resultsTable.MeanLLM],"omitnan"),...
                 std([dataForCLConversion.resultsTable.MeanSLM],"omitnan")]);
        end

        resultsTable(i).stdLLM = std(settingsLLM);
        resultsTable(i).stdSLM = std(settingsSLM);

        resultsTable(i).nSettings = size(output,1);

        [resultsTable(i).LogAxisRatio,...
            resultsTable(i).AxisRatioNormed,...
            ~,...
            ~,...
            resultsTable(i).EllipseAngleUnnormed]...
            =...
            GetAxisRatio(settingsLLM,settingsSLM);

        resultsTable(i).timestart = timestart;

    catch e % https://uk.mathworks.com/matlabcentral/answers/325475-display-error-message-and-execute-catch#answer_255132
        disp(['i = ',num2str(i)]);
        disp(['There was an error!',newline,...
            'The identifier was: ',e.identifier,newline,...
            'The message was: ',e.message]);

        resultsTable(i).MeanLLM = NaN;
        resultsTable(i).MeanSLM = NaN;
        resultsTable(i).CL = NaN;
        resultsTable(i).stdLLM = NaN;
        resultsTable(i).stdSLM = NaN;        
        resultsTable(i).nSettings = NaN;
        resultsTable(i).LogAxisRatio = NaN;
        resultsTable(i).AxisRatioNormed = NaN;
        resultsTable(i).EllipseAngleUnnormed = NaN;
    end
end

%% Load questionnaire data

Qdata   = readtable(['..',filesep,'questionnaire',filesep,'arc_SelectQData.csv']);

% Go through the results table and add in the relevent values from the questionaire
for i = 1:size(resultsTable,2)

    Qdata_ind = find(all(cell2mat(Qdata.pcode) == resultsTable(i).ppt,2));

    resultsTable(i).testSeason = Qdata.seasonIndex(Qdata_ind);
    resultsTable(i).age = Qdata.age_years_(Qdata_ind);

    resultsTable(i).birthLocation = Qdata.AboveOrBelowArcticCircle(Qdata_ind);
    if Qdata(Qdata_ind,:).AboveOrBelowArcticCircle == 2
        resultsTable(i).birthLocation = NaN;
    end

    try
        resultsTable(i).birthNumber = month(datetime(Qdata.whichMonthIsYourBirthday_(Qdata_ind),'InputFormat','MMMM'));
    catch
        disp(Qdata_ind);
        disp(Qdata.whichMonthIsYourBirthday_(Qdata_ind));
        resultsTable(i).birthNumber = NaN;
    end

    if ismember(resultsTable(i).birthNumber,[5,6,7])
        resultsTable(i).birthSeason = 1;
    elseif ismember(resultsTable(i).birthNumber,[8,9,10])
        resultsTable(i).birthSeason = 2;
    elseif ismember(resultsTable(i).birthNumber,[11,12,1])
        resultsTable(i).birthSeason = 3;
    elseif ismember(resultsTable(i).birthNumber,[2,3,4])
        resultsTable(i).birthSeason = 4;
    elseif isnan(resultsTable(i).birthNumber)
        resultsTable(i).birthSeason = NaN;
    else
        disp(i)
        warning('Did not recognise birthNumber')
        resultsTable(i).birthSeason = NaN;
    end
end

%%

save(localPaths.PPProcessedData,'resultsTable');
