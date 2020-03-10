% This script sets up the canlab_dataset object for the data in this folder.
% For more information see 'help canlab_dataset' in CanlabCore
%% Set up paths and load data

% Woo et al., Distinct Brain Systems Mediate the Effects of Nociceptive Input and Self-Regulation on Pain

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/bmrk3/';
datadir = fullfile(basedir, 'results');

cd(datadir)

% Customize to load NPS data file
datafilename = fullfile(datadir, 'npsvals_bmrk3.mat');
dat = load(datafilename);

%% Create canlab_dataset object
% -------------------------------------------------------------------------
% This provides a standard data format, and allows the use of more methods,
% such as writing the data object to text for backup/export to other
% software, plotting, analysis tools, and more.

DAT = canlab_dataset;

% Fill in Experiment-level information
% ------------------------------------------------------------------------
DAT.Description.Experiment_Name = 'Woo et al., Distinct Brain Systems Mediate the Effects of Nociceptive Input and Self-Regulation on Pain';
DAT.Description.Missing_Values = NaN;


% Subject ID - put in cell array of strings
DAT.Subj_Level.id = dat.nps_table.subjids;

% Other variables
DAT.Subj_Level.names = dat.nps_table.Properties.VariableNames(1:5);  % Subject is first; omit


% Descriptions, added to DAT.Subj_Level.descrip
% -------------------------------------------------------------------------

descrip = {'IMAGINE_DOWN: NPS values for imagine down '
            'STANDARD: NPS values for standard'
            'IMAGINE_UP: NPS values for imagine up'
            'DOWNvSTANDARD: NPS values for down vs standard'
            'UPvSTANDARD: NPS values for up vs standard'};
        
DAT.Subj_Level.descrip = descrip;

%% ADD DATA to canlab_dataset object
% -------------------------------------------------------------------------
DAT.Subj_Level.data = table2array(dat.nps_table(:,1:5));


% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% check and write dataset

% List variable names
get_var(DAT); %print variables to command windo

write_text(DAT)

%% SAVE

save canlab_dataset_bmrk3 DAT





