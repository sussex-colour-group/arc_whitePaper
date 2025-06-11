function pptsToExclude = getExclusions(excludeRecentTravellers)

pptsToExclude = {'036t',... % high STD of responses, see `whiteOutliers.m`
    '006o',... % born outside required area
    '057t',... % empty data file (`arc_WhiteSettings_057_t2.mat`)
    '160t',... % only did one trial (thus, can't compute STD etc)
    '152t'};   % location of residence was outside required area

if excludeRecentTravellers
    recentTravellers = {'027o','050o','080o','090o','105o','106o','117o',...
        '118o','129o','155o','158o','028t','083t','093t','150t'};
    pptsToExclude = [pptsToExclude,recentTravellers];
end

pptsToExclude = unique(pptsToExclude); % remove any duplicates

end