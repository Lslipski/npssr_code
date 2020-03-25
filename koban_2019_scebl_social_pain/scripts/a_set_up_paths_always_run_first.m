% Always run this first before you run other scripts.
%
% NOTES:
% - standard folders and variable names are created by these scripts
%
% - in "prep_" scripts: 
%   image names, conditions, contrasts, colors, global gray/white/CSF
%   values are saved automatically in a DAT structure
% 
% - extracted fmri_data objects are saved in DATA_OBJ variables
% - contrasts are estimated and saved in DATA_OBJ_CON variables
%
% - files with these variables are saved and loaded automatically when you
%   run the scripts
%   meta-data saved in image_names_and_setup.mat
%   image data saved in data_objects.mat
%
% - you only need to run the prep_ scripts once.  After that, use 
%   b_reload_saved_matfiles.m to re-load saved files
% 
% - when all scripts working properly, run z_batch_publish_analyses.m
%   to create html report.  customize by editing z_batch_list_to_publish.m
%
% - saved in results folder:
%   figures
%   html report with figures and stats, in "published_output"

% Set base directory
% --------------------------------------------------------

% Base directory for whole study/analysis
basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/koban_2019_scebl_social_pain';
datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/koban_2019_scebl_social_pain';


% Set user options
% --------------------------------------------------------

a2_set_default_options

% Set up paths
% --------------------------------------------------------

cd(basedir)

resultsdir = fullfile(basedir, 'results');
scriptsdir = fullfile(basedir, 'scripts');
figsavedir = fullfile(resultsdir, 'figures');

addpath(scriptsdir)

if ~exist(resultsdir, 'dir'), mkdir(resultsdir); end
if ~exist(figsavedir, 'dir'), mkdir(figsavedir); end

% Display helper functions: Called by later scripts
% --------------------------------------------------------

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n%s\n%s\n', dashes, str, dashes);
