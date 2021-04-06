datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/roy_2009_iaps_pain/data/behavioral_physio';

load(fullfile(datadir,'IAPS_pain_fMRI_ratings_and_RIII.mat'));

DAT = canlab_dataset;
DAT.Subj_Level.data = ratings_and_RIII.ratings_neg_vs_pos;
DAT.Subj_Level.names = ratings_and_RIII.subnums;
DAT.Subj_Level.descrip = {'ratings_neg_vs_pos'};

% save
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/roy_emomod_2009/results';
cd(savedir);
save canlab_dataset_roy_emomod_2009 DAT


