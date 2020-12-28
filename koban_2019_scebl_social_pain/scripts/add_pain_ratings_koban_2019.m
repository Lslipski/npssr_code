%% Set up paths and load data

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/koban_2019_scebl_social_pain/'
rawdir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/koban_2019_scebl_social_pain/data/pain_ratings/';
datadir = fullfile(basedir, 'results');

cd(datadir)

load canlab_dataset_koban_2019_scebl_social_pain DAT

painratings = readtable(fullfile(rawdir, 'SCEBL_NPS_painratings.xlsx'));

%% Add pain ratings to new canlab data object
% label to distinguish behavioral ratings from nps values
ratings_descrip = {'Behavioral Ratings CLSL_48'
                   'Behavioral Ratings CLSH_48'
                   'Behavioral Ratings CLSL_49'
                   'Behavioral Ratings CLSH_49'
                   'Behavioral Ratings CHSL_49'
                   'Behavioral Ratings CHSH_49'
                   'Behavioral Ratings CHSL_50'
                   'Behavioral Ratings CHSH_50'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; ratings_descrip];

% add descriptions for each behavioral condition
ratings_names = {'Behavioral_CLSL_48'
                 'Behavioral_CLSH_48'
                 'Behavioral_CLSL_49'
                 'Behavioral_CLSH_49'
                 'Behavioral_CHSL_49'
                 'Behavioral_CHSH_49'
                 'Behavioral_CHSL_50'
                 'Behavioral_CHSH_50'};
DAT.Subj_Level.names = [DAT.Subj_Level.names; ratings_names];

% add raw ratings data to Subject level data 
DAT.Subj_Level.data = [DAT.Subj_Level.data table2array(painratings(:, 3:10))];

%% add contrasts for pain ratings

% array is prime(') to fit the size of the subj_level data (matrix algebra
% will require this to apply contrasts to data)
C = [0 0 -1 1 -1 1 0 0;
     -1 -1 -1 -1 1 1 1 1;]';
condescrips = {'Contrast Behavioral Social cue high > Soc cue low'
            'Contrast Behavioral CS high > CS low'};
connames = {'contrast_ratings_sochilo'
            'contrast_ratings_cuehilo'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; condescrips];
DAT.Subj_Level.names = [DAT.Subj_Level.names; connames];

mydat = get_var(DAT, DAT.Subj_Level.names(13:20)); % get subject level data for each of the behavioral conditions
convals = mydat * C; % multiply the data by the contrasts to get behavioral values for each subject for each contrast

%concatenate new contrast values to data field
DAT.Subj_Level.data = [DAT.Subj_Level.data convals];

% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% List variable names
get_var(DAT);

% save csv files of data
write_text(DAT)

% SAVE

save canlab_dataset_koban_2019_scebl_social_pain DAT


