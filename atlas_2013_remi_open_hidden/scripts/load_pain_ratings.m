% load pain ratings file from Bogdan's single trials repo
datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/atlas_2013_remi_open_hidden/';
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/atlas_2013_remi_open_hidden/results/';

load(strcat(datadir,'remi_dataset_obj.mat'));

drug_ratings = [];
nodrug_ratings = [];

%loop through 17 subjects
for i = 1:size(dataset_obj.Event_Level.data,2)
    wh_drug_trials = find(dataset_obj.Event_Level.data{i}(:,8) == 1.0);
    my_dat = dataset_obj.Event_Level.data(i);
    mean_drug_rating = nanmean(my_dat{:,1}(wh_drug_trials));
    wh_nodrug_trials = find(dataset_obj.Event_Level.data{i}(:,8) == 0.0);
    mean_nodrug_rating = nanmean(my_dat{:,1}(wh_nodrug_trials));
    
    drug_ratings = [drug_ratings mean_drug_rating];
    nodrug_ratings = [nodrug_ratings mean_nodrug_rating];
    
end

pain_ratings = canlab_dataset;
pain_ratings.Subj_Level.id = dataset_obj.Subj_Level.id;
pain_ratings.Subj_Level.names = {'pain_ratings_drug', 'pain_ratings_no_drug' 'pain_ratings_nodrug_v_drug'};
pain_ratings.Subj_Level.type = {'int' 'int'};
pain_ratings.Description = dataset_obj.Description;
pain_ratings.Description.Event_Level = {}; % not keeping event level data
pain_ratings.Subj_Level.descrip = {'Average pain rating for each subject for 1. trials with remi (pain_ratings_drug) and 2. trials without remi (pain_ratings_no_drug) and 3. drug minus no drug'};
nodrug_v_drug = nodrug_ratings - drug_ratings;
pain_ratings.Subj_Level.data = [drug_ratings', nodrug_ratings' nodrug_v_drug'];

DAT = pain_ratings;

save(strcat(savedir,'canlab_dataset_atlas_2013_remi_open_hidden'), 'DAT');