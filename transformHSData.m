function data = transformHSData(inputData)

% modified from arc_ImageAnalysis/plotMeanMB_hyperspec

for i = 1:size(inputData,1)
    if length(inputData(i).name) == 14 % please, dearest future humans, use leading zeros when storing data
        picId(i) = str2num(inputData(i).name(1:4));
    else
        picId(i) = str2num(inputData(i).name(1:3));
    end
end

data = NaN(6,max(picId));

for i = 1:size(inputData,1)
    data(1:2,picId(i))  = [inputData(i).meanMB];
    data(6,picId(i))    = inputData(i).meanMB_CL;
end

% season
data(4,[510:740,330:509]) = 1; % Summer
data(4,[952:1165,743:951]) = 3; % Winter

% location
data(5,[330:509,743:951]) = 0; % Tromso
data(5,[510:740,952:1165]) = 1; % Oslo

end