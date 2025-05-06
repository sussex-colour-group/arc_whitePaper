function data = transformHSData(inputData)

% modified from arc_ImageAnalysis/plotMeanMB_hyperspec

data = NaN(6,1165); % TODO Check whether this should be hard-coded or not

for i = 1:size(inputData,1)

    if length(inputData(i).name) == 14 % please, dearest future humans, use leading zeros when storing data
        picId = str2num(inputData(i).name(1:4));
    else
        picId = str2num(inputData(i).name(1:3));
    end

    data(1:2,picId) = [inputData(i).meanMB];
end

% season
data(4,[510:740,330:509]) = 1; % Summer
data(4,[952:1165,743:951]) = 3; % Winter

% location
data(5,[330:509,743:951]) = 0; % Tromso
data(5,[510:740,952:1165]) = 1; % Oslo

% data(6,:) = CL

end