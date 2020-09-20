%% Create Between Subject Table with only Contrasts of Interest

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code';
results_dir = fullfile(basedir,'multistudy','results')

max_subjects = 36;  % maximum numer of subjects in any of the given studies

% list of folders to look through for nps and ratings data
dataset_names = {%'atlas_2013_remi_open_hidden'
                  'becker_2017_pain_reward'
                  'bmrk3'
                  'jepma_2018_ie2'
%                  'koban_2019_scebl_social_pain'
                  'kober_2019_mindful_acceptance_mrp'
                  'lopezsola_2019_handholding_pain'
                 %'ma_2016_pain_citalopram'
                 %'roy_emomod_2009'
                 };
             
dataset_keys = {%'remi'
                  'pain_reward'
                  'bmrk3'
                  'ie2'
%                  'social_pain'
                  'mindful_acceptance'
                  'handholding'
                 %'ma_2016_pain_citalopram'
                 %'roy_emomod_2009'
                 };
             
% initialize cell arrays to hold all studies' data
multistudy_contrasts_data = {};
multistudy_contrasts_names={};
                        
for i=1:size(dataset_names, 1)
    % load dataset from project folder
    cd(fullfile(basedir,dataset_names{i}, 'results'))
    contrasts = load(fullfile(pwd, 'contrast_data_objects.mat'));
    
    %get column headers from image_names and preprend study key
    contrast_names = contrasts.DATA_OBJ_CON{1}.image_names;
    [worthless, len] = size(contrast_names);
    this_data = [];
    for q = 1:len
        this_contrast = strcat(dataset_keys(i),'_', contrast_names{q});
        this_data = contrasts.DATA_OBJ_CON{q};
        [n, k] = size(this_data);
        
        
        % add contrast data and name to fmri_dataset
        fmri_ds = this_data;
        fmri_ds.image_names = this_contrast;
        
        % print size info for this contrast
        disp('Adding data from: ')
        disp(dataset_keys{i})
        disp('Contrast being added: ')
        disp(fmri_ds.image_names)
        disp('Of size: ')
        disp(size(fmri_ds.dat))
        
        % add newly formatted contrast to full dataset
        multistudy_contrasts_data{end+1} = fmri_ds;
        multistudy_contrasts_names{end+1} = fmri_ds.image_names;
        
    end

end


% save multistudy files

multistudy_contrasts.data = multistudy_contrasts_data;
multistudy_contrasts.contrast_names = multistudy_contrasts_names;

savename = strcat('multistudy_contrasts_', date, '.mat')
save(fullfile(results_dir, savename), 'multistudy_contrasts') % save


cd(results_dir)











