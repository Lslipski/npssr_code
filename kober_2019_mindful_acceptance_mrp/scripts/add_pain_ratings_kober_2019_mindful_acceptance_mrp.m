%% Set up paths and load data

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/kober_2019_mindful_acceptance_mrp/'
rawdir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/kober_2019_mindful_acceptance_mrp/behavioral_data/';
datadir = fullfile(basedir, 'results');

cd(datadir)

load canlab_dataset_kober_2019_mindful_acceptance_mrp DAT

mrp = readtable(fullfile(rawdir, 'kober_2019_mindful_acceptance_mrp_behavioral_data.xls')); %this data object has the pain ratings in it

% fix NPS contrast name to denote contrast
DAT.Subj_Level.names{10} = 'con acc heat vs react heat';


%% Add pain ratings to new canlab data object
% label to distinguish behavioral ratings from nps values
ratings_descrip = {'Rating Accept: Neutral Image'
                   'Rating Accept: Negative Image'
                   'Rating Accept: Warm'
                   'Rating Accept: Hot'
                   'Rating React: Neutral Image'
                   'Rating React: Negative Image'
                   'Rating React: Warm'
                   'Rating React: Hot'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; ratings_descrip];

% add short names for each behavioral condition
ratings_names = {'beh_acc_neu_img'
                 'beh_acc_neg_img'
                 'beh_acc_warm'
                 'beh_acc_hot'
                 'beh_rea_neu_img'
                 'beh_rea_neg_img'
                 'beh_rea_warm'
                 'beh_rea_hot'};
DAT.Subj_Level.names = [DAT.Subj_Level.names, ratings_names'];

% add raw ratings data to Subject level data 
DAT.Subj_Level.data = [DAT.Subj_Level.data, table2array(mrp(:,2:9))];

%% add behavioral contrast of interest: accept hot vs react hot

% array is prime(') to fit the size of the subj_level data (matrix algebra
% will require this to apply contrasts to data)
C = [1 -1]';
wh = [14 18]; % for indices of conditions
mydat = get_var(DAT, DAT.Subj_Level.names(wh)); % get subject level data for each of the behavioral conditions
convals = mydat * C; % multiply the data by the contrasts to get behavioral values for each subject for each contrast

%concatenate new contrast values to data field
DAT.Subj_Level.data = [DAT.Subj_Level.data convals];

% add description to description and names
beh_contrast_descrip = {'Contrast Rating: Accept pain vs React pain'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; beh_contrast_descrip];

beh_contrast_name = {'con_beh_acc_hot_vs_rea_hot'};
DAT.Subj_Level.names = [DAT.Subj_Level.names, beh_contrast_name'];


% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% List variable names
get_var(DAT);

% save csv files of data
write_text(DAT)

% SAVE

save canlab_dataset_kober_2019_mindful_acceptance_mrp DAT


