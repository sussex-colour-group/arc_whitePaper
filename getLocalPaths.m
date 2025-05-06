function localPaths = getLocalPaths

% This file isn't tracked by git, because it will vary per user/OS.
% Fill it in, and remove the error line.
% It's ignored using this technique: https://stackoverflow.com/a/39776107/6464224
% To unignore it run `git update-index --no-skip-worktree getLocalPaths.m`

error("You haven't specified your local paths yet.")

localPaths.GoProRawData = "";
localPaths.GoProProcessedData = "";

localPaths.NLRawData = "";
localPaths.NLProcessedData = "";

localPaths.HSRawData = "";
localPaths.HSProcessedData = "";

localPaths.saveLocation = "";

end