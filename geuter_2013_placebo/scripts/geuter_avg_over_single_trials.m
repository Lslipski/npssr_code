% this script loops through .mat condition files for geuter_2013_placebo and
% averages single trials for 3 conditions:
% 1. Control
% 2. weak/cheap placebo
% 3. strong/expensive placebo

datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/geuter_2013_placebo';
painresultsdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/geuter_2013_placebo/results';
brainresultsdir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/geuter_2013_placebo/conditions';
currentdir = pwd;

%% load data
load(fullfile(datadir,'stephan_dataset_obj.mat')); % pain data
load(fullfile(datadir,'stephan_data.mat')); % brain data

% resample space of stephan_data
%x = tmpData;
%tmpData = resample_space(tmpData, x);

n = 40; % 40 subjs in this study

% set up new objects to fill and save
% initialize canlab_data object to store pain ratings for each subject
pain_ratings = canlab_dataset;
pain_ratings.Subj_Level.names = {'Control High_Placebo Low_Placebo High_vs_Control_contrast'};
pain_ratings.Subj_Level.type = 'int';
pain_ratings.Description.Experiment_Name = 'Geuter_2013_Placebo';
pain_ratings.Description.Event_Level = {};

temp_ratings = [];

% initialize empty fmri_data objects for all 3 conditions
brain_control = tmpData;
brain_control.dat = [];
brain_high_placebo  = tmpData;
brain_high_placebo.dat = [];
brain_low_placebo = tmpData;
brain_low_placebo.dat = [];


%% process pain and brain data and save objects to results
for i = 1:n
    i
    % get subject name from pain scores
    thisid = dataset_obj.Subj_Level.id{i};
    
    % average pain scores over 3 conditions of interest for this subj
    thispain = dataset_obj.Event_Level.data{i};
    control_trials = find(thispain(:, 3) == 0.0);
    placebo_high_trials = find(thispain(:, 3) == 1.0 & thispain(:,4) == 0.5);
    placebo_low_trials = find(thispain(:, 3) == 1.0 & thispain(:,4) == -0.5);
    
    % get averages by condition and contrast
    control_avg = nanmean(thispain(control_trials, 1));
    placebo_high_avg = nanmean(thispain(placebo_high_trials, 1));
    placebo_low_avg = nanmean(thispain(placebo_low_trials, 1));
    placebo_high_vs_cont_avg = placebo_high_avg - control_avg;
    
    pain_ratings.Subj_Level.dat(i, 1:4) = [control_avg placebo_high_avg placebo_low_avg placebo_high_vs_cont_avg]; %contrast high vs control
    pain_ratings.Subj_Level.id{i} = thisid
    
    % get the corresponding subject's brain data
    all_ids = tmpData.metadata_table{:,6};
    %this_sub_brain = tmpData.metadata_table(find(contains(all_ids, thisid)),:);
    brain_control_trials = (tmpData.metadata_table.placebo == 0.0) & (contains(all_ids, thisid));
    brain_high_trials = (tmpData.metadata_table.placebo == 1.0) & (tmpData.metadata_table.value == 0.5) & (contains(all_ids, thisid));
    brain_low_trials = (tmpData.metadata_table.placebo == 1.0) & (tmpData.metadata_table.value == -0.5) & (contains(all_ids, thisid));
    
    % average brain data over 3 conditions of interest for this subj
    brain_control_avg = nanmean(tmpData.dat(:, brain_control_trials),2);
    brain_high_placebo_avg = nanmean(tmpData.dat(:, brain_high_trials), 2);
    brain_low_placebo_avg = nanmean(tmpData.dat(:, brain_low_trials), 2);
    
    % add brain avgs to fmri_data objects
    brain_control.dat = [brain_control_avg];
    brain_high_placebo.dat = [brain_high_placebo_avg];
    brain_low_placebo.dat = [brain_low_placebo_avg];
    
    % save nifti for each participant
    brain_control.fullpath = fullfile(brainresultsdir, strcat(thisid, '_control.nii'));
    write(brain_control);
    
    brain_high_placebo.fullpath = fullfile(brainresultsdir, strcat(thisid, '_placebo_high.nii'));
    write(brain_high_placebo);
    
    brain_low_placebo.fullpath = fullfile(brainresultsdir, strcat(thisid, '_placebo_low.nii'));
    write(brain_low_placebo);
    
    
end

% save pain ratings canlab_dataset object
pain_ratings_file = fullfile(painresultsdir, 'canlab_dataset_geuter_2013_placebo.mat');
DAT = pain_ratings;
save(pain_ratings_file, 'DAT');


cd(currentdir)