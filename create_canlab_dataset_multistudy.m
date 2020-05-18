%% Create Between Subject Table with only Contrasts of Interest

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code';

% list of folders to look through for nps and ratings data
dataset_names = {'atlas_2013_remi_open_hidden'
                 'becker_2017_pain_reward'
                 'bmrk3'
                 'jepma_2018_ie2'
                 'koban_2019_scebl_social_pain'
                 'kober_2019_mindful_acceptance_mrp'
                 'lopezsola_2019_handholding_pain'
                 %'ma_2016_pain_citalopram'
                 %'roy_emomod_2009'
                 };
 % always specify NPS contrast index THEN behavioral contrast index
dataset_contrast_indices = {[18 15]
                            [12 21]
                            [0 0]
                            [0 0]
                            [0 0]
                            [0 0]
                            [0 0]};
                        
if size(dataset_names,1) ~= size(dataset_contrast_indices,1)
    error('You must specify indices for contrasts of interest for all datasets')
end
             
% initialize canlab dataset to hold all studies' data
self_reg_results = canlab_dataset;
self_reg_results.Subj_Level.data = {};

for i=1:2%size(dataset_names, 1)
    % load canlab dataset, get contrast names and data
    cd(fullfile(basedir,dataset_names{i}, 'results'))
    load(fullfile(pwd, strcat('canlab_dataset_', dataset_names{i})))
    
    ds_data_nps = DAT.Subj_Level.data(:, dataset_contrast_indices{i}(1));
    ds_data_beh = DAT.Subj_Level.data(:, dataset_contrast_indices{i}(2));

    ds_names = {DAT.Subj_Level.names{[dataset_contrast_indices{i}]}}
    ds_descrip = {DAT.Subj_Level.descrip{dataset_contrast_indices{i}}}
    
    self_reg_results.Subj_Level.data = [self_reg_results.Subj_Level.data ds_data_nps ds_data_beh]
    self_reg_results.Subj_Level.names = [self_reg_results.Subj_Level.names ds_names]
    self_reg_results.Subj_Level.descrip = [self_reg_results.Subj_Level.descrip ds_descrip]

    cd ../..

end
    