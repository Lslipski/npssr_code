% Always run this first before you run other scripts.

% Set base directory
% --------------------------------------------------------

% Base directory for whole study/analysis
basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/';

% Set user options
% --------------------------------------------------------

a2_set_default_options

% Set up paths
% --------------------------------------------------------
cd(basedir)

scriptsdir = fullfile(basedir, 'between_dataset_scripts');
resultsdir = fullfile(basedir, 'results');

addpath(scriptsdir)


% You may need this, but now should be in CANlab Private repository
a2_set_default_options

% Display helper functions: Called by later scripts
% --------------------------------------------------------

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n%s\n%s\n', dashes, str, dashes);
