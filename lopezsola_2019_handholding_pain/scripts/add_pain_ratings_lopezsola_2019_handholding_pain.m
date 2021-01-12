%% Set up paths and load data
a_set_up_paths_always_run_first;

cd(resultsdir)

%load canlab_dataset_lopezsola_2019_handholding_pain.mat DAT

% only using intensity ratings; unpleasantness ratings are in BG:BH for baseline
% and handholding respectively
cd(datadir)
ratings = xlsread('HH_behav_Jan2016_Marianne_03252019.xlsx',1,'BE:BF');

mydat = canlab_dataset;
%% Add pain ratings to new canlab data object
% label to distinguish behavioral ratings from nps values
ratings_descrip = {'Behavioral Rating Baseline'
                   'Behavioral Rating Handholding'};
               
mydat.Subj_Level.descrip = [mydat.Subj_Level.descrip; ratings_descrip];

% add descriptions for each behavioral condition
ratings_names = {'Beh_baseline'
                 'Beh_handholding'};
mydat.Subj_Level.names = [mydat.Subj_Level.names; ratings_names];

% add raw ratings data to Subject level data 
mydat.Subj_Level.data = [mydat.Subj_Level.data ratings];

%% add contrasts for pain ratings

% array is prime(') to fit the size of the subj_level data (matrix algebra
% will require this to apply contrasts to data)
C = [-1 1]';
condescrips = {'Behavioral Contrast Handholding > Baseline'};
connames = {'beh_con_HH_vs_BL'};
mydat.Subj_Level.descrip = [mydat.Subj_Level.descrip; condescrips];
mydat.Subj_Level.names = [mydat.Subj_Level.names; connames];

condat = mydat.Subj_Level.data; % get subject level data for each of the behavioral conditions
convals = condat * C; % multiply the data by the contrasts to get behavioral values for each subject for each contrast

%concatenate new contrast values to data field
mydat.Subj_Level.data = [mydat.Subj_Level.data convals];

% Add variable types
k = length(mydat.Subj_Level.names); % get subject level name length
mydat.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types

DAT = mydat;
%% List variable names
cd(resultsdir)

get_var(DAT);

% save csv files of data
write_text(DAT)

% SAVE

save canlab_dataset_lopezsola_2019_handholding_pain DAT


