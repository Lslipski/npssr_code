% This script sets up the canlab_dataset object for the data in this folder.

%% Info about canlab_dataset object
% 
% see help(canlab_dataset)

% The canlab_dataset object contains data at five potential levels of analysis:
% 1. Experiment-level
% 2. Subject_level
% 3. Event_Level
% 4. Sub_Event_Level
% 5. Continuous
%
% 1. Experiment-level describes entire dataset 
%
% 2. Subject-level data contains one value per person per variable.
%    It is entered in DAT.Subj_Level.data and DAT.Subj_Level.textdata
%    In a matrix of N subjects x V variables
%
% 3. Event_Level data contains one value per event/trial per subject per variable.
%    It is entered in DAT.Event_Level.data and DAT.Event_Level.textdata
%    In a cell array with one cell per subject.
%    Each cell contains a matrix of T trials/events x V variables
%
% 4. Sub_Event_Level data contains one or more values per event/trial per subject per variable.
%    It is entered in DAT.Sub_Event_Level.data and DAT.Sub_Event_Level.textdata
%    In a cell array with one cell per subject.
%    Each cell contains a variable-size matrix of K observations x V variables
%
% 5. Continuous data is intended to contain time-series of K samples per subject per variable.
%    It is entered in DAT.Continuous.data and DAT.Continuous.textdata
%    In a cell array with one cell per subject.
%    Each cell contains a variable-size matrix of K samples x V variables
%
% The most important levels for many analyses are the Subject_level and
% Event_level, which provide sufficient data to run multi-level mixed
% effects models.
%
% Documenting meta-data:
% -----------------------------------------------------------------------
% All data levels have fields for variable names, stored in cell arrays:
% DAT.Subj_Level.names
% DAT.Event_Level.names
% etc.
% All data levels also have fields for units of analysis and data type.
% Data type is either 'numeric' or 'text'
% All data levels have fields for long-form descriptions of variables,
% stored in .descrip, in cell arrays with one cell per variable.
% A complete dataset will make use of these important fields.
%
% For more information, see:
%   help(canlab_dataset)
%   disp(DAT.Description.Subj_Level)
%   disp(DAT.Description.Event_Level)

% Conventions for creating objects:
% --------------------------------------------------------------------------------------
% Follow these so your dataset object will work with functions!!
% If you have n subjects and k variables, 
% 1. obj.Subj_Level.id is an n-length cell vector of strings with subject IDs
% 2. obj.Subj_Level.type is a k-length cell vector with 'text' or 'numeric' for each variable
% 3. obj.Subj_Level.data is n x k numeric data, with columns of NaNs if the
%     variable is a text variable
% 4. obj.Subj_Level.textdata is an n x k cell array of text data, with columns of empty cells if the
%     variable is a numeric variable
% 5. If you have fMRI onsets and durations, etc., use the 'fmri' option to
%    create standardized variable names.

%% Set up paths and load data

% zeidan, S., et al., Orbitofrontal cortex mediates pain inhibition by monetary reward. Social Cognitive and Affective Neuroscience, 2016.

basedir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/2016_zeidan_painreward_copes/';
datadir = fullfile(basedir, 'results');

cd(datadir)

% Customize to load data file
datafilename = fullfile(datadir, 'npsvals_MSPainReward.txt');
nheaderlines = 1;
delim = '\t';
dat = importdata(datafilename, delim, nheaderlines);

dat.textdata{2} = dat.textdata{2}(2:end);  % ad hoc: remove extra space (typo)

%dat = textread(datafilename, '%3.6f', 'delimiter', delim, 'headerlines', nheaderlines)
%% Create canlab_dataset object
% -------------------------------------------------------------------------
% This provides a standard data format, and allows the use of more methods,
% such as writing the data object to text for backup/export to other
% software, plotting, analysis tools, and more.

DAT = canlab_dataset;

% Fill in Experiment-level information
% ------------------------------------------------------------------------
DAT.Description.Experiment_Name = 'zeidan, S., et al., Orbitofrontal cortex mediates pain inhibition by monetary reward. Social Cognitive and Affective Neuroscience, 2016.';
DAT.Description.Missing_Values = NaN;

% Fill in variable names
% ------------------------------------------------------------------------

% Names of subject-level data we want to store
% -------------------------------------------------------------------------

% Subject ID - put in cell array of strings
subjid = dat.data(:, 1);
subjid = mat2cell(subjid, ones(length(subjid), 1), 1);
subjid = cellfun(@num2str, subjid, 'UniformOutput', 0);

DAT.Subj_Level.id = subjid;

% Other variables
DAT.Subj_Level.names = dat.textdata(2:end);  % Subject is first; omit

% Names of trial-level data we want to store
% -------------------------------------------------------------------------
% None

% Descriptions, added to DAT.Subj_Level.descrip
% -------------------------------------------------------------------------

descrip = {'LOSEMILD: NPS vals following loss, mild pain'
    'LOSEMOD: NPS vals following loss, moderate pain'
    'LOSENO: NPS vals following loss, no pain'
    'NEUTMILD: NPS vals following no reward/loss, mild pain'
    'NEUTMOD: NPS vals following no reward/loss, moderate pain'
    'NEUTNO: NPS vals following no reward/loss, no pain'
    'WINMILD: NPS vals following win, mild pain'
    'WINMOD: NPS vals following win, moderate pain'
    'WINNO: NPS vals following win, no pain'};
        
DAT.Subj_Level.descrip = descrip;

%% ADD DATA to canlab_dataset object
% -------------------------------------------------------------------------
DAT.Subj_Level.data = dat.data(:, 2:end);


% Create contrasts of interest and save

% Contrasts
% use C' to get into correct shape for DAT
C = [0 .333 -.333 0 .333 -.333 0 .333 -.333;    
     -.333 .333 0 -.333 .333 0 -.333 .333 0;
     -.5 -.5 0 0 0 0 .5 .5 0; 
     .25 .25 0 -.5 -.5 0 .25 .25 0]';
connames = {'Hot - None' 'Hot - Mild' 'HotMild Win-Loss' 'HotMild WinLoss - NoRew'};

wh = 1:9; % for indices of conditions
mydat = get_var(DAT, DAT.Subj_Level.names(wh)); % get subject level data for each of the 9 conditions
convals = mydat * C; % multiply data by contrasts to get values for each subject for each contrast

DAT.Subj_Level.data = [DAT.Subj_Level.data convals]; % concatenate contrast values onto subject level data
DAT.Subj_Level.names = [DAT.Subj_Level.names connames]; % concatenate contrast names onto subject level names

% add descriptions to the subject level description field for the contrasts
DAT.Subj_Level.descrip(end+1) = {'Hot - No pain within-person contrast'}; 
DAT.Subj_Level.descrip(end+1) = {'Hot - Mild within-person contrast'};
DAT.Subj_Level.descrip(end+1) = {'Hot + Mild Reward gain - Loss within-person contrast'};  
DAT.Subj_Level.descrip(end+1) = {'Hot + Mild Reward or loss - No reward within-person contrast'};

% Add variable types

k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% check and write dataset

% List variable names
get_var(DAT); %print variables to command windo

write_text(DAT)

%% SAVE

save canlab_dataset_zeidan DAT





