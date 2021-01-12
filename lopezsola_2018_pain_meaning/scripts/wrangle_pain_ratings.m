%% create canlab dataset for pain ratings for Lopezsola_2018_pain_meaning

datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/lopezsola_2018_pain_meaning';
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/lopezsola_2018_pain_meaning/results';
return_dir = pwd;
cd(datadir)

%% load mat file from marika
load('romantic_pain_MP.mat');

mydat = canlab_dataset;
mydat.Subj_Level.id = romantic_pain.subjects';
mydat.Description.Experiment_Name = 'Marika Lopez-Sola pain meaning 2018';
mydat.Subj_Level.names = 'pain ratings';
mydat.Subj_Level.descrip = {'1 average pain rating for each participant corresponding to the pain they felt during trials with prosocial meaning'};

%% create data array with 1 row (average pain rating) for each of 29 subjects
dat = [];
for i = 1:size(romantic_pain.pain,2)
    these_ratings = cell2mat(romantic_pain.pain(i));
    mean_these_ratings = mean(these_ratings);
    dat = [dat mean_these_ratings];
end

mydat.Subj_Level.data = dat';

%% limit to only subjects for whom we have contrasts
% get list of only subjects with a contrast
mysubs = []
subs_w_contrasts = dir('painbetas*.mat');
for i = 1:size(subs_w_contrasts,1)
    mysubs = [mysubs extractBetween(subs_w_contrasts(i).name,'painbetas_', '.mat')]
end

sub_indx = [];
for i = 1:size(mysubs,2)
    sub_indx = [sub_indx; strcmp(mysubs(i),romantic_pain.subjects)];
end
sub_indx = max(sub_indx);
sub_indx = find(sub_indx == 1);

% limit subject IDs
mydat.Subj_Level.id = mydat.Subj_Level.id(sub_indx);
mydat.Subj_Level.data = mydat.Subj_Level.data(sub_indx);


%% save canlab data object
DAT = mydat;
savefile = fullfile(savedir, 'canlab_dataset_lopezsola_2018_pain_meaning.mat');
save(savefile, 'DAT');

cd(return_dir);