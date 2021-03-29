% this script loops through .mat condition files for atlas_2010_exp and
% averages over low-cue-medium-temp trials and high-cue-medium-temp trials
% to get both conditions. Those sets are each saved in an fmri_data object.
% Then average contrast pain ratings are saved to a canlab_dataset object,
% and both high and low cue (all medium temp) condition images are saved
% for use in the canlab batch scripts.

datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/atlas_2010_exp/single_trial_data';
ratingsdir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/atlas_2010_exp/single_trial_data/ratings';
savedir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/atlas_2010_exp';
resultsdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/atlas_2010_exp/results';
currentdir = pwd;

%% load pain ratings
load(fullfile(ratingsdir,'exp_dataset_obj.mat'));

cd(datadir)
myfiles = dir('exp*');
n = size(myfiles,1);

% initialize empty fmri_data objects for both high and low cue conditions
med_temp_high_cue = fmri_data;
med_temp_high_cue.dat = [];
med_temp_low_cue  = fmri_data;
med_temp_low_cue.dat = [];

% initialize canlab_data object to store pain ratings for each subject
pain_ratings = canlab_dataset;
pain_ratings.Subj_Level.names = {'HiCue_v_LowCue'};
pain_ratings.Subj_Level.type = 'int';
pain_ratings.Description.Experiment_Name = 'Atlas 2010 EXP';
pain_ratings.Description.Event_Level = {};

% loop through each subject
for i = 1:n
    % load brain images for a participant
    load(myfiles(i).name);
    disp(myfiles(i).name)
    mysub = extractBefore(myfiles(i).name, '.mat');
    disp(mysub);
    
    % get the corresponding id in the pain ratings file (dataset_obj)
    myindices = [];
    
    for p = 1:n
        myindices = [myindices strcmp(char(dataset_obj.Subj_Level.id{p}),mysub)];
    end
    myindex = find(myindices);
    myindex
    
    %get that P's pain ratings data
    myrats = dataset_obj.Event_Level.data{myindex};
    dataset_obj.Subj_Level.id(myindex)
    
    % get low, med, and high temperatures
    temps = unique(myrats(:,2));
    mytemp = sort(temps(2));
    med_temp_high_cue_trials = find((myrats(:,2) == mytemp) & (myrats(:,3) == 0.5) & (myrats(:,7) <= 2));
    med_temp_low_cue_trials = find((myrats(:,2) == mytemp) & (myrats(:,3) == -0.5) & (myrats(:,7) <= 2));
    
    % average medium temp high cue ratings
    rats_med_high = mean(myrats(med_temp_high_cue_trials));
    rats_med_low = mean(myrats(med_temp_low_cue_trials));
    rat_contrast = rats_med_high - rats_med_low;

    
    % average medium temp high cue images
    my_med_high = mean(dat.dat(:,med_temp_high_cue_trials),2);
    my_med_low = mean(dat.dat(:,med_temp_low_cue_trials),2);
    
    %save both condition images
    dat.dat = my_med_high;
    dat.fullpath = fullfile(savedir, 'conditions', strcat(mysub, '_medtemp_highcue.nii'));
    write(dat);
    
    dat.dat = my_med_low;
    dat.fullpath = fullfile(savedir, 'conditions',strcat(mysub, '_medtemp_lowcue','.nii'));
    write(dat);
    % update fmri_data objects with new data for archive
%     med_temp_high_cue.dat = [med_temp_high_cue.dat my_med_high];
%     med_temp_low_cue.dat  = [med_temp_low_cue.dat my_med_low];
    
    % save pain ratings to canlab_dataset_obj
    pain_ratings.Subj_Level.data = [pain_ratings.Subj_Level.data rat_contrast];
    pain_ratings.Subj_Level.id{i} = mysub;
    
    
    clear dat;
end

%save both as niftis
% med_temp_high_cue.fullpath = fullfile(savedir, 'contrasts', 'med_temp_high_cue.nii');
% write(med_temp_high_cue);
% med_temp_low_cue.fullpath = fullfile(savedir, 'contrasts', 'med_temp_low_cue.nii');
% write(med_temp_low_cue);


% save pain ratings canlab_dataset object
% pain_ratings_file = fullfile(resultsdir, 'canlab_dataset_atlas_2010_exp.mat');
% DAT = pain_ratings;
% save(pain_ratings_file, 'DAT');




cd(currentdir);









