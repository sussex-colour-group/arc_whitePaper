function [data_out,pptCodes_out] = excludePpts(data,pptCodes,pptsToExclude)

% exclude = false(size(pptCodes));
% for i = 1:length(pptCodes)
%     exclude(i) = ismember(pptCodes,pptsToExclude)
% end

exclude = ismember(pptCodes,pptsToExclude);

data_out = data(:,~exclude);
pptCodes_out = pptCodes(:,~exclude);

end