function [outputData,ppt_codes] = transformPPData(inputData)

outputData = NaN(6,size(inputData,2));

outputData(1,:) = [inputData.MeanLLM];
outputData(2,:) = [inputData.MeanSLM];
% no luminance data - all isoluminant
outputData(4,:) = [inputData.testSeason];
outputData(5,:) = [inputData.testLocation];
% outputData(6,:) = [inputData.CL]; % doesn't seem to be included in the current datafile
outputData(7,:) = [inputData.birthLocation];

ppt_codes = {inputData.ppt};

end