%% Compute Signature Scores and Normalize
% Created by: Luke Slipski 04/22/2021
% This code loads all nifti images (one per subject) for the NPSSR study.
% It then applies all canlab signatures to the (zscored) images
% (apply_all_signatures()), and loads signature scores into a table. It
% then does the same thing using 7 resting state networks as signatures
% from the Buckner lab. It then calculates variables
% (prepended with "MAD_") that correspond to each participant's scores
% divided by the Mean Absolute Deviation WITHIN study. Then subjective pain
% ratings are loaded and all variables are comiled into a single table and
% saved as all_subjects_all_scores_[date].csv

%% set paths load data
datadir = '/Users/lukie/Documents/canlab/NPSSR/multistudy_contrasts';
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';

image_names = filenames(fullfile(datadir, '*img'), 'absolute');
data_obj = fmri_data(image_names);
%% Create all brain signature score tables
% get correct study names for each participant and rename for visualizing
condnames = {};
for i = 1:size(image_names);
    [x,y] = fileparts(image_names{i});
    fname = eraseBetween(y,1,16);
    if contains(fname, 'bmrk3') == 1
        fname = 'Imagination';
    elseif contains(fname, 'exp_high') == 1
        fname = 'Expectation';
    elseif contains(fname, 'handholding') == 1
        fname = 'Handholding';
    elseif contains(fname, 'ie2') == 1
        fname = 'Sym_Cond';
    elseif contains(fname, 'mindful') == 1
        fname = 'Mindfulness';
    elseif contains(fname, 'pain_meaning') == 1
        fname = 'Meaning';
    elseif contains(fname, 'reward') == 1
        fname = 'Reward';
    elseif contains(fname, 'placebo') == 1
        fname = 'Placebo';
    elseif contains(fname, 'remi') == 1
        fname = 'Remi';
    elseif contains(fname, 'emomod') == 1
        fname = 'Emotion';
    elseif contains(fname, 'social') == 1
        fname = 'Social';
    end
    condnames{end+1} = fname;
end

% get all signature scores from default canlab signatures and add studyname
[SIG, sigtable] = apply_all_signatures(data_obj, 'similarity_metric', 'dotproduct', 'image_scaling', 'zscoreimages', 'condition_names', condnames);
sigtable_vars = sigtable{1}.Properties.VariableNames;
sigtable{1}.study = condnames';

% get all signature scores from bucknerlab resting state networks and add
% studyname
[fc, fc_names] = load_image_set('bucknerlab_wholebrain');
fc.image_names = fc_names';
[rsSIG, rssigtable] = apply_all_signatures(data_obj, 'similarity_metric', 'dotproduct', 'image_scaling', 'zscoreimages', 'condition_names', condnames,'image_set',fc);
rssigtable_vars = rssigtable{1}.Properties.VariableNames;
rssigtable{1}.study = condnames';

% prepend MAD_ to all adjusted variable names
MAD_sigtable_vars = sigtable_vars; % sigtable
for i = 1:size(MAD_sigtable_vars,2)
    MAD_sigtable_vars{i} = strcat('MAD_', MAD_sigtable_vars{i});
end

MAD_rssigtable_vars = rssigtable_vars; % rssigtable
for i = 1:size(MAD_rssigtable_vars,2)
    MAD_rssigtable_vars{i} = strcat('MAD_', MAD_rssigtable_vars{i});
end

% create table of signature scores divided by MAD WITHIN each study
MAD_sigtable = zeros(size(sigtable{1},1), (size(sigtable{1},2) - 1));
studies = unique(condnames);
for i = 1:size(studies,2)
    mystudy = find(strcmp(sigtable{1}.study, studies(i)));
    to_scale = sigtable{1}(mystudy,1:(end - 1));
    [n, k] = size(to_scale);
    myscaled = table2array(to_scale )./ repmat(mad(table2array(to_scale)), n, 1);
    MAD_sigtable(mystudy,:) = myscaled;
end
MAD_sigtable = array2table(MAD_sigtable); % convert to table
MAD_sigtable.Properties.VariableNames = MAD_sigtable_vars; % add varnames
MAD_sigtable.study = condnames';

% create table of RS network scores divided by MAD WITHIN each study
MAD_rssigtable = zeros(size(rssigtable{1},1), (size(rssigtable{1},2) - 1));
studies = unique(condnames);
for i = 1:size(studies,2)
    mystudy = find(strcmp(rssigtable{1}.study, studies(i)));
    to_scale = rssigtable{1}(mystudy,1:(end - 1));
    [n, k] = size(to_scale);
    myscaled = table2array(to_scale )./ repmat(mad(table2array(to_scale)), n, 1);
    MAD_rssigtable(mystudy,:) = myscaled;
end
MAD_rssigtable = array2table(MAD_rssigtable); % convert to table
MAD_rssigtable.Properties.VariableNames = MAD_rssigtable_vars;
MAD_rssigtable.study = condnames';

%% Pain Ratings
% load pain ratings for each subject by study
load(fullfile(savedir,'multistudy_ratings_05-Apr-2021.mat'));

% flip signs of pain ratings where appropriate to make contrasts correct
% sign 
sign_switch = [1 2 3 5 8];
for col=1:size(sign_switch,2)
 ms_ratings.ratings(:,sign_switch(col)) = ms_ratings.ratings(:,sign_switch(col)) * -1;
end
%reshape
rats = reshape(ms_ratings.ratings,[],1); % make into vector
rats = rats(~isnan(rats)); % remove nans padded into original table

% divide by MAD
[n, k] = size(ms_ratings.ratings);
MAD_rats = ms_ratings.ratings ./ repmat(mad(ms_ratings.ratings), n, 1);
MAD_rats = reshape(MAD_rats, [], 1);
MAD_rats = MAD_rats(~isnan(MAD_rats));

%% Flip signs of signature scores depending on contrast of interest
sign_switch = {'Sym_Cond', 'Expectation', 'Emotion'}; % Symbolic Cond., Expectation, Emotion;
for i=1:size(sign_switch,2)
    disp(strcat('Flipping sign for study: ', sign_switch{i}));
    wh_rows = find(strcmp(sigtable{1}.study, sign_switch{i}));
    sigtable{1}(wh_rows, 1: end - 1) = array2table(table2array(sigtable{1}(wh_rows, 1: end - 1)) * -1);
    rssigtable{1}(wh_rows, 1: end - 1) = array2table(table2array(rssigtable{1}(wh_rows, 1: end - 1)) * -1);
    MAD_sigtable(wh_rows, 1: end - 1) = array2table(table2array(MAD_sigtable(wh_rows, 1: end - 1)) * -1);
    MAD_rssigtable(wh_rows, 1: end - 1) = array2table(table2array(MAD_rssigtable(wh_rows, 1: end - 1)) * -1);
end


%% Combine all tables
savetable = [sigtable{1}(:,1:end - 1) rssigtable{1}(:,1:end -1) MAD_sigtable(:,1:end - 1) MAD_rssigtable(:,:)];
savetable.pain_scores = rats; % add pain ratings to signatures table
savetable.MAD_pain_scores = MAD_rats; % add MAD normalized pain ratings to signatures table


%% save all signature scores
cd(savedir)
writetable(savetable, strcat('all_signature_and_pain_scores_', date,'.csv'));





