% This script sets up the canlab_dataset object for the data in this folder.
% For more information see 'help canlab_dataset' in CanlabCore
%% Set up paths and load data
a_set_up_paths_always_run_first;

cd(basedir)

% Customize to load NPS data file
load('results/npsvals_jepma_2018_ie2.mat')

%% Create canlab_dataset object
% -------------------------------------------------------------------------
% This provides a standard data format, and allows the use of more methods,
% such as writing the data object to text for backup/export to other
% software, plotting, analysis tools, and more.

DAT = canlab_dataset;

% Fill in Experiment-level information
% ------------------------------------------------------------------------
DAT.Description.Experiment_Name = 'Jepma, M., Koban, L., Doorn, J., Jones, M., & Wager, T. D. (2018). Behavioural and neural evidence for self-reinforcing expectancy effects on pain. Nature Human Behaviour, 1?18.';
DAT.Description.Missing_Values = NaN;


% Subject ID - put in cell array of strings
DAT.Subj_Level.id = nps_table.subjids;

% Other variables
DAT.Subj_Level.names = {'low cue'
                        'neutral cue'
                        'high cue'
                        'neut_vs_low'
                        'high_vs_neut'
                        'high_vs_low'}; 


% Descriptions, added to DAT.Subj_Level.descrip
% -------------------------------------------------------------------------

descrip = {'Low Cue Condition'
           'Neutral Cue Condition'
           'High Cue Condition'
           'Contrast: neutral vs. low'
           'Contrast: high vs neutral'
           'Contrast: high vs low'};
        
DAT.Subj_Level.descrip = descrip;

%% ADD DATA to canlab_dataset object
% -------------------------------------------------------------------------
DAT.Subj_Level.data = table2array(nps_table(:,1:6));


% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% check and write dataset

% List variable names
cd(resultsdir);
get_var(DAT); %print variables to command windo

write_text(DAT)

%% SAVE
save canlab_dataset_jepma_2018_ie2 DAT





