% This script sets up the canlab_dataset object for the data in this folder.
% For more information see 'help canlab_dataset' in CanlabCore
%% Set up paths and load data
basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/koban_2019_scebl_social_pain/';
datadir = fullfile(basedir, 'results');

cd(datadir)

% Customize to load NPS data file
load('npsvals_koban_2019.mat')

%% Create canlab_dataset object
% -------------------------------------------------------------------------
% This provides a standard data format, and allows the use of more methods,
% such as writing the data object to text for backup/export to other
% software, plotting, analysis tools, and more.

DAT = canlab_dataset;

% Fill in Experiment-level information
% ------------------------------------------------------------------------
DAT.Description.Experiment_Name = 'Koban, L., Jepma, M., López-Solà, M., & Wager, T. D. (n.d.). Different brain networks mediate the effects of social and conditioned expectations on pain.';
DAT.Description.Missing_Values = NaN;


% Subject ID - put in cell array of strings
DAT.Subj_Level.id = nps_table.subjids;

% Other variables
DAT.Subj_Level.names = {'Cues CSHigh'
                        'Cues CSLow'
                        'Cues SocHigh'
                        'Cues SocLow'
                        'Pain CSHigh'
                        'Pain CSLow'
                        'Pain SocHigh'
                        'Pain SocLow'
                        'Cues CShilo'
                        'Cues Sochilo'
                        'Pain CShilo'
                        'Pain Sochilo'}; 


% Descriptions, added to DAT.Subj_Level.descrip
% -------------------------------------------------------------------------

descrip = {'NPS Condition response during CS High cue'
           'NPS Condition response during CS Low cue'
           'NPS Condition response during Social High cue'
           'NPS Condition response during Social Low cue'
           'NPS Condition response during CS High pain'
           'NPS Condition response during CS Low pain'
           'NPS Condition response during Social High pain'
           'NPS Condition response during Social Low pain'
           'NPS Contrast response CS High > Low during cue'
           'NPS Contrast response Social High > Low during cue'
           'NPS Contrast response CS High > Low during pain'
           'NPS Contrast response Social High > Low during pain'};
        
DAT.Subj_Level.descrip = descrip;

%% ADD DATA to canlab_dataset object
% -------------------------------------------------------------------------
DAT.Subj_Level.data = table2array(nps_table(:,1:12));


% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% check and write dataset

% List variable names
get_var(DAT); %print variables to command windo

write_text(DAT)

%% SAVE

save canlab_dataset_koban_2019_scebl_social_pain DAT





