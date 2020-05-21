%% Create Between Subject Table with only Contrasts of Interest

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code';
results_dir = fullfile(basedir,'multistudy','results')

max_subjects = 36;  % maximum numer of subjects in any of the given studies

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
                            [6 12]
                            [8 17]
                            [12 21]
                            [10 19]
                            [3 6]};
                        
if size(dataset_names,1) ~= size(dataset_contrast_indices,1)
    error('You must specify indices for contrasts of interest for all datasets')
end
             
% initialize canlab dataset to hold all studies' data
self_reg_results = canlab_dataset;
self_reg_results_zscored = canlab_dataset;

for i=1:size(dataset_names, 1)
    % load canlab dataset
    cd(fullfile(basedir,dataset_names{i}, 'results'))
    load(fullfile(pwd, strcat('canlab_dataset_', dataset_names{i})))
    [n, k] = size(DAT.Subj_Level.data);
    
    %get contrast names and data
    ds_data_nps = DAT.Subj_Level.data(:, dataset_contrast_indices{i}(1));
    ds_data_beh = DAT.Subj_Level.data(:, dataset_contrast_indices{i}(2));
    ds_names = {DAT.Subj_Level.names{[dataset_contrast_indices{i}]}};
    ds_descrip = {DAT.Subj_Level.descrip{dataset_contrast_indices{i}}};
    
    % get z-scored data
    ds_data_nps_z = zscore(ds_data_nps);
    ds_data_beh_z = zscore(ds_data_beh);
    
    
    % append NaN to datasets with fewer than the max subjects to account
    % for differences in sample size between datasets
    if n < max_subjects
        nan_to_add = NaN(max_subjects - n, 1);
        ds_data_nps = cat(1, ds_data_nps, nan_to_add);
        ds_data_beh = cat(1, ds_data_beh, nan_to_add);
        ds_data_nps_z = cat(1, ds_data_nps_z, nan_to_add);
        ds_data_beh_z = cat(1, ds_data_beh_z, nan_to_add);
    end

    % append to canlab dataset vars non z-scored
    self_reg_results.Subj_Level.data = [self_reg_results.Subj_Level.data ds_data_nps ds_data_beh];
    self_reg_results.Subj_Level.names = [self_reg_results.Subj_Level.names ds_names];
    self_reg_results.Subj_Level.descrip = [self_reg_results.Subj_Level.descrip ds_descrip];
    
    % append to canlab dataset vars z-scored
    self_reg_results_zscored.Subj_Level.data = [self_reg_results_zscored.Subj_Level.data ds_data_nps_z ds_data_beh_z];
    self_reg_results_zscored.Subj_Level.names = [self_reg_results_zscored.Subj_Level.names ds_names];
    self_reg_results_zscored.Subj_Level.descrip = [self_reg_results_zscored.Subj_Level.descrip ds_descrip];

end


% save non zscored canlab dataset
DAT = self_reg_results;
cd(results_dir);
get_var(self_reg_results);
save self_reg_combined DAT

% save zscored canlab dataset
DAT = self_reg_results_zscored;
get_var(self_reg_results_zscored);
save self_reg_combined_zscored DAT
    