# arc_whitePaper

## Installation
This repo uses git submodules.
To clone it in a way which sets these up without additional commands run: `git clone --recurse-submodules https://github.com/sussex-colour-group/arc_whitePaper`

## Data
- Preprocessed data is included in this repo (such that `generateFigures.m` should run from a clean clone alone, without any additional data needing to be added)
- Raw data is available from: https://osf.io/z576y/ and scripts are provided (`arc_whitePaper/data/processed/scripts`) which process the raw data into the preprocessed data. 
    - Exceptions:
        - The raw GoPro data is not provided, for privacy and logistical (it's 1.3TB) reasons.
        - The raw questionnaire data is not provided for privacy reasons. (TODO provide additional info)
        - In both of the above cases, pre-processing scripts are provided nonetheless, to aid with transparency of analysis. 

## Dependencies
- Some functions may require PsychToolbox (TODO check)
- Some functions may require additional MATLAB toolboxes (TODO check)
- The code was written and tested on:
    - OS: Ubuntu 24.04.2 LTS, MATLAB: '24.2.0.2806996 (R2024b) Update 3'
    - OS: Windows 10 Pro 22H2, MATLAB: '9.14.0.2286388 (R2023a) Update 3'

## Usage
- Fill in the local paths file, an example is provided below.
- To regenerate the figures run `generateFigures.m`

`getLocalPaths.m` example:
```
function localPaths = getLocalPaths

% This file isn't tracked by git, because it will vary per user/OS.
% Fill it in, and remove the error line.
% It's ignored using this technique: https://stackoverflow.com/a/39776107/6464224
% To set it to be ignored run `git update-index --skip-worktree getLocalPaths.m`
% To unignore it run `git update-index --no-skip-worktree getLocalPaths.m`

localPaths.GoProRawData                     = '/home/danny/Documents/arc_whitePaper/data/raw/GoPro';
localPaths.GoProProcessedData               = '/home/danny/Documents/arc_whitePaper/data/processed/GoPro/GoPro_sub.csv';
localPaths.GoProProcessedData_whiteSniffer  = '/home/danny/Documents/arc_whitePaper/data/raw/GoPro/arc_GoProStats_V1_whiteSniffer.mat';

localPaths.NLRawData                        = '/home/danny/Documents/arc_whitePaper/data/raw/nanoLambda';
localPaths.NLProcessedData                  = '/home/danny/Documents/arc_whitePaper/data/processed/nanoLambda/NL_sub.csv';

localPaths.HSRawData                        = '/home/danny/cisc2/projects/colour_arctic/data/Norway Hyperspectral/Hyperspectral';
localPaths.HSLMSImages                      = '/home/danny/cisc1/projects/colour_arctic/hyperspectralOutputs';
localPaths.HSProcessedData                  = '/home/danny/Documents/arc_whitePaper/data/processed/hyperspectral/hyperspectralMBmeans.mat';

localPaths.PPRawData                        = '/home/danny/Documents/arc_whitePaper/data/raw/psychophysics';
localPaths.PPProcessedData                  = '/home/danny/Documents/arc_whitePaper/data/processed/psychophysics/resultsTable.csv';

localPaths.QuestionnaireRawData             = '/home/danny/Documents/Box/Norway Data Sharing/Questionnaire/data/';

end
```
