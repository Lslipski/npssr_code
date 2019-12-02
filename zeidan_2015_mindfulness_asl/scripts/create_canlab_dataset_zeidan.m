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

% Zeidan F, Emerson NM, Farris SR, et al. Mindfulness Meditation-Based Pain 
% Relief Employs Different Neural Mechanisms Than Placebo and Sham Mindfulness 
% Meditation-Induced Analgesia. J Neurosci. 2015;35(46):15307?15325. doi:10.1523/JNEUROSCI.2542-15.2015

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/zeidan_2015_mindfulness_asl/';
datadir = fullfile(basedir, 'results');

cd(datadir)

% Load npsvals mat file from prep_5
dat = load(fullfile(datadir, 'npsvals_mindfulness_zeidan.mat'));

% grab first column from nps values to get subjids
subjids = table2cell(dat.nps_table(:,1));

%% Create canlab_dataset object
% -------------------------------------------------------------------------
% This provides a standard data format, and allows the use of more methods,
% such as writing the data object to text for backup/export to other
% software, plotting, analysis tools, and more.

DAT = canlab_dataset;

% Fill in Experiment-level information
% ------------------------------------------------------------------------
DAT.Description.Experiment_Name = 'Zeidan F, Emerson NM, Farris SR, et al. Mindfulness Meditation-Based Pain Relief Employs Different Neural Mechanisms Than Placebo and Sham Mindfulness Meditation-Induced Analgesia. J Neurosci. 2015;35(46):15307?15325. doi:10.1523/JNEUROSCI.2542-15.2015';
DAT.Description.Missing_Values = NaN;

%% Fill in variable names
% ------------------------------------------------------------------------

% Names of subject-level data we want to store
% -------------------------------------------------------------------------

DAT.Subj_Level.id = subjid;

% Other variables
DAT.Subj_Level.names = dat.textdata(2:end);  % Subject is first; omit

% Names of trial-level data we want to store
% -------------------------------------------------------------------------
% None

% Descriptions, added to DAT.Subj_Level.descrip
% -------------------------------------------------------------------------

descrip = {'Book Control -- Post Manipulation'
    'Book Control -- Pre Manipulation'
    'Placebo -- Post Manipulation'
    'Placebo -- Pre Manipulation'
    'Sham -- Post Manipulation'
    'Sham -- Pre Manipulation'
    'Mindfulness -- Post Manipulation'
    'Minfulness -- Pre Manipulation'};
        
DAT.Subj_Level.descrip = descrip;

%% ADD DATA to canlab_dataset object
% -------------------------------------------------------------------------
DAT.Subj_Level.data = dat.nps_table(:, 2:end);


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





