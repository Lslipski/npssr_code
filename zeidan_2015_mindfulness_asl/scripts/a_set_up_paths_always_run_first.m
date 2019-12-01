% Set up paths
% --------------------------------------------------------

% Base directory for whole study/analysis
basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/zeidan_2015_mindfulness_asl';
datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/2015_Zeidan_Mindfulness_ASL'
cd(basedir)

datadir = fullfile(datadir, 'data');
resultsdir = fullfile(basedir, 'results');
scriptsdir = fullfile(basedir, 'scripts');
figsavedir = fullfile(basedir, 'figures');

addpath(scriptsdir)

if ~exist(resultsdir, 'dir'), mkdir(resultsdir); end
if ~exist(figsavedir, 'dir'), mkdir(figsavedir); end

% You may need this, but now should be in CANlab Private repository
% g = genpath('/Users/tor/Documents/matlab_code_external/spider');
% addpath(g)

% Display helper functions: Called by later scripts

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n%s\n%s\n', dashes, str, dashes);
