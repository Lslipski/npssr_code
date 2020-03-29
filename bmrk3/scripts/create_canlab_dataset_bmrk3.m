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
DAT.Subj_Level.names = dat.nps_table.Properties.VariableNames(1:5); 
DAT.Subj_Level.names = [DAT.Subj_Level.names {'up vs down'}];


% Descriptions, added to DAT.Subj_Level.descrip
% -------------------------------------------------------------------------

descrip = {'IMAGINE_DOWN: NPS values for imagine down '
            'STANDARD: NPS values for standard'
            'IMAGINE_UP: NPS values for imagine up'
            'DOWNvSTANDARD: NPS values for down vs standard'
            'UPvSTANDARD: NPS values for up vs standard'
            'UpvDown: NPS values for up vs down'};
        
DAT.Subj_Level.descrip = descrip;

%% ADD DATA to canlab_dataset object
% -------------------------------------------------------------------------
DAT.Subj_Level.data = table2array(dat.nps_table(:,1:5));

%% Create contrast for up vs. down
C = [-1 1]';
connames = {'Rating: Up vs. Down'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; connames'];

wh = [4 5]; % for indices of conditions down and up vs standard
mydat = get_var(DAT, DAT.Subj_Level.names(wh)); % get subject level data for each of the behavioral conditions
convals = mydat * C;
% add new contrast to subject level data
DAT.Subj_Level.data = [DAT.Subj_Level.data convals];

% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% check and write dataset

% List variable names
get_var(DAT); %print variables to command windo

write_text(DAT)

%% SAVE
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/bmrk3/results';
cd(savedir);
save canlab_dataset_bmrk3 DAT





