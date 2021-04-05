% this script is for loading in canlab_datasets from multiple studies and
% combining the relevant sets into a data frame for analysis alongside the
% multistudy contrasts dataframe.
basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code';
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';
max_subjects = 40;  % maximum numer of subjects in any of the given studies
origdir = pwd;


%% jepma_2018_ie2:
%pain ratings stored in
%NPSSR/npssr_code/jepma_2018_ie2/results/canlab_dataset_jepma_2018_ie2.mat
% corresponding brain contrast in dataframe: 'ie2_high vs low' 
cd(fullfile(basedir, '/jepma_2018_ie2/results/'));
load('canlab_dataset_jepma_2018_ie2');
beh_cons = {'high_vs_low_beh'}; %only keeping high vs low for now, not {'neut_vs_low_beh' 'high_vs_neut_beh' }
[n, k] = size(DAT.get_var(beh_cons));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
jepma_pain_ratings = vertcat(DAT.get_var(beh_cons),  to_pad);
jepma_pain_ratings_names = { 'ie2_high_vs_low_beh'};


%% atlas_2013_remi_open_hidden: 
cd(fullfile(basedir, 'atlas_2013_remi_open_hidden/results'));
load('canlab_dataset_atlas_2013_remi_open_hidden.mat');
beh_cons = {'pain_ratings_nodrug_v_drug'};
[n, k] = size(DAT.get_var(beh_cons));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
atlas_remi_pain_ratings = vertcat(DAT.get_var(beh_cons),  to_pad);
atlas_remi_pain_ratings_names = {'atlas_remi_hot_nodrug_v_drug'};

%% atlas_2013_exp: 
cd(fullfile(basedir, 'atlas_2010_exp/results'));
load('canlab_dataset_atlas_2010_exp.mat');
beh_cons = {'HiCue_v_LowCue'};
[n, k] = size(DAT.Subj_Level.data');
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
atlas_exp_pain_ratings = vertcat(DAT.Subj_Level.data',  to_pad);
atlas_exp_pain_ratings_names = {'atlas_exp_high_v_low'};

%% becker_2017_pain_reward
% pain ratings stored in
% NPSSR/npssr_code/becker_2017_pain_reward/results/canlab_dataset_becker_2017_pain_reward.mat
% corresponding brain contrast in dataframe: 'pain_reward_Win v Lose'
cd(fullfile(basedir, 'becker_2017_pain_reward/results'));
load('canlab_dataset_becker_2017_pain_reward.mat');
beh_cons = {'Rating:WINMOD' 'Rating:WINMILD' 'Rating:LOSEMOD' 'Rating:LOSEMILD'};
[n, k] = size(DAT.get_var(beh_cons));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
contrast_of_interest = [1 1 -1 -1]; %only using win vs lose for now
mydat = vertcat(DAT.get_var(beh_cons),  to_pad);
condat = mydat .* contrast_of_interest;
becker_reward_ratings = sum(condat, 2);
becker_reward_ratings_names = {'becker_reward_win_v_lose'};

%% becker_2016_pain_control

%EXCLUDING UNTIL CORRECT PAIN RATING VARIABLE CAN BE DETERMINED

% /Users/lukie/Documents/canlab/NPSSR/npssr_code/becker_2016_pain_control/results/canlab_dataset_becker_2016_control.mat
% corresponding brain contrast in dataframe: 'pain_control_Pain C vs Pain UC' 
cd(fullfile(basedir, 'becker_2016_pain_control/results'));
load('canlab_dataset_becker_2016_control.mat');

[n, k] = size(DAT.Subj_Level.data(:,6));
n = n-1; % not including subject 21
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
becker_2016_pain_control_ratings = vertcat(DAT.Subj_Level.data(:,6),  to_pad);
becker_2016_pain_control_ratings(21,:) = []; % remove subject 21
becker_2016_pain_control_ratings_names = {'becker_pain_control_vs_uncontrol'};

%% bmrk3
% NPSSR/npssr_code/bmrk3/results/canlab_dataset_bmrk3.mat
% corresponding brain contrast in dataframe: 'bmrk3_up vs standard' 
cd(fullfile(basedir, 'bmrk3/results/'));
load('canlab_dataset_bmrk3.mat');
beh_cons = {'up_vs_down_rating'};

[n, k] = size(DAT.get_var(beh_cons));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
bmrk3_pain_ratings = vertcat(DAT.get_var(beh_cons),  to_pad);
bmrk3_pain_ratings_names = { 'bmrk3_up_vs_down_rating'};

%% roy_emomod_2009
% NPSSR/npssr_code/roy_2009_iaps_pain/results/canlab_dataset_roy_emomod_2009.mat
% corresponding brain contrast in dataframe: 'roy_emomod_2009_neg v pos' 
cd(fullfile(basedir, 'roy_emomod_2009/results'));
load('canlab_dataset_roy_emomod_2009.mat');
beh_cons = {'ratings_neg_vs_pos'};

[n, k] = size(DAT.Subj_Level.data');
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);

roy_emomod_pain_ratings = vertcat(DAT.Subj_Level.data',  to_pad);
roy_emomod_pain_ratings_names = { 'roy_emomod_ratings_neg_vs_pos'};
%% koban_2019_scebl_social_pain
% corresponding brain contrast in dataframe:'handholding_handholding vs baseline' 
cd(fullfile(basedir, 'koban_2019_scebl_social_pain/results'));
load('canlab_dataset_koban_2019_scebl_social_pain.mat');
beh_cons = {'contrast_ratings_sochilo'};

[n, k] = size(DAT.Subj_Level.data(:,9));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);

koban_2019_scebl_social_pain_ratings = vertcat(DAT.Subj_Level.data(:,9), to_pad);
koban_2019_scebl_social_pain_ratings_names = {'koban_social_pain_beh_con_sochi_vs_soclo'};

%% lopezsola_2019_handholding_pain
% NPSSR/npssr_code/lopezsola_2019_handholding_pain/results/canlab_dataset_lopezsola_2019_handholding_pain.mat
% corresponding brain contrast in dataframe:'handholding_handholding vs baseline' 
cd(fullfile(basedir, 'lopezsola_2019_handholding_pain/results'));
load('canlab_dataset_lopezsola_2019_handholding_pain.mat');
beh_cons = {'beh_con_HH_vs_BL'};

[n, k] = size(DAT.Subj_Level.data(:,3));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);

lopezsola_handholding_pain_ratings = vertcat(DAT.Subj_Level.data(:,3),  to_pad);
lopezsola_handholding_pain_ratings_names = {'lopezsola_handholding_beh_con_HH_vs_BL'};
%% kober_2019_mindful_acceptance_mrp
% NPSSR/npssr_code/kober_2019_mindful_acceptance_mrp/results/canlab_dataset_kober_2019_mindful_acceptance_mrp.mat
% corresponding brain contrast in dataframe:'mindful_acceptance_acc heat vs react heat'
cd(fullfile(basedir, 'kober_2019_mindful_acceptance_mrp/results'));
load('canlab_dataset_kober_2019_mindful_acceptance_mrp.mat');
beh_cons = {'con_beh_acc_hot_vs_rea_hot'};

[n, k] = size(DAT.get_var(beh_cons));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);

kober_mindful_acc_pain_ratings = vertcat(DAT.get_var(beh_cons),  to_pad);
kober_mindful_acc_pain_ratings_names = { 'kober_mindful_acc_hot_vs_rea_hot'};

%% lopezsola_2018_pain_meaning
% NPSSR/npssr_code/lopezsola_2018_pain_meaning/results/canlab_dataset_lopezsola_2018_pain_meaning.mat
% corresponding brain contrast in dataframe: 'pain_meaning_meaning vs nomeaning'
cd(fullfile(basedir, 'lopezsola_2018_pain_meaning/results'));
load('canlab_dataset_lopezsola_2018_pain_meaning.mat');
beh_cons = {'con_beh_acc_hot_vs_rea_hot'};

% wh_baseline = [1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1];
% wh_meaning = [ 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0];

%mydat = DAT.Subj_Level.data; %first row is participants number
% dat_baseline = mydat .* wh_baseline;
% dat_baseline(dat_baseline == 0) = NaN;
% dat_meaning = mydat .* wh_meaning;
% dat_meaning(dat_meaning == 0) = NaN;

% mean_baseline = mean(dat_baseline,2,'omitnan');
% mean_meaning = mean(dat_meaning, 2,'omitnan');
% mean_meaning = mean_baseline .* -1;
% 
% mycontrast = mean_meaning - mean_baseline;


[n, k] = size(DAT.Subj_Level.data);
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);

lopezsola_meaning_pain_ratings = vertcat(DAT.Subj_Level.data,  to_pad);
lopezsola_meaning_pain_ratings_names = {'lopezsola_meaning_vs_no_meaning'};

%% Geuter 2013 Placebo High vs. Control
cd(fullfile(basedir, '/geuter_2013_placebo/results/'));
load('canlab_dataset_geuter_2013_placebo.mat');
[n, k] = size(DAT.Subj_Level.dat(:,4));
nanpad = max_subjects - n;
to_pad = NaN(nanpad, k);
geuter_pain_ratings = vertcat(DAT.Subj_Level.dat(:,4),  to_pad);
geuter_pain_ratings_names = { 'placebo_high_v_control'};


%% combine pain ratings from all studies (using ms for multistudy)
ms_ratings.ratings = [atlas_remi_pain_ratings ...
    atlas_exp_pain_ratings ...
    jepma_pain_ratings ...
    becker_reward_ratings... %becker_2016_pain_control_ratings
    bmrk3_pain_ratings...
    roy_emomod_pain_ratings ...
    lopezsola_handholding_pain_ratings ...
    koban_2019_scebl_social_pain_ratings ...
    kober_mindful_acc_pain_ratings ... 
    lopezsola_meaning_pain_ratings ...
    geuter_pain_ratings
    ];
ms_ratings.names = [atlas_remi_pain_ratings_names ...
    atlas_exp_pain_ratings_names ...
    jepma_pain_ratings_names ...
    becker_reward_ratings_names... %becker_2016_pain_control_ratings_names 
    bmrk3_pain_ratings_names...
    roy_emomod_pain_ratings_names ...
    lopezsola_handholding_pain_ratings_names ...
    koban_2019_scebl_social_pain_ratings_names...
    kober_mindful_acc_pain_ratings_names ...
    lopezsola_meaning_pain_ratings_names ...
    geuter_pain_ratings_names
    ];

size(ms_ratings.ratings)

% optional save
myfile = fullfile(savedir, strcat('multistudy_ratings_',date,'.mat'));
save(myfile, 'ms_ratings');
cd(origdir);



