% Create Between Subject Table with only Contrasts of Interest

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code';
results_dir = fullfile(basedir,'multistudy','results')

max_subjects = 40;  % maximum numer of subjects in any of the given studies (placebo has 40)

% list of folders to look through for nps and ratings data
dataset_names = {'atlas_2013_remi_open_hidden'
                  'atlas_2010_exp'
                  'becker_2017_pain_reward'
                  'becker_2016_pain_control'
                  'bmrk3'
                  'jepma_2018_ie2'
                  'koban_2019_scebl_social_pain'
                  'kober_2019_mindful_acceptance_mrp'
                  'lopezsola_2019_handholding_pain'
                 %'ma_2016_pain_citalopram'
                 'roy_emomod_2009'
                 'lopezsola_2018_pain_meaning'
                 'geuter_2013_placebo'
                 };
             
dataset_keys = {'remi'
                 'exp'
                 'pain_reward'
                 'pain_control' 
                 'bmrk3'
                 'ie2'
                 'social_pain'
                 'mindful_acceptance'
                 'handholding'
                 %'ma_2016_pain_citalopram'
                 'roy_emomod_2009'
                 'pain_meaning'
                 'placebo'
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
        
    %for q = 1:len        
        if strcmp(dataset_names{i}, 'atlas_2013_remi_open_hidden')
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'atlas_2010_exp')
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'becker_2017_pain_reward')  
            con_to_grab = 2;
        elseif strcmp(dataset_names{i}, 'becker_2016_pain_control')  
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'bmrk3')
            con_to_grab = 6;
        elseif strcmp(dataset_names{i}, 'jepma_2018_ie2')
            con_to_grab = 3;
        elseif strcmp(dataset_names{i}, 'koban_2019_scebl_social_pain')
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'kober_2019_mindful_acceptance_mrp')     
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'lopezsola_2019_handholding_pain')     
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'roy_emomod_2009') 
            con_to_grab = 2;
        elseif strcmp(dataset_names{i}, 'lopezsola_2018_pain_meaning') 
            con_to_grab = 1;
        elseif strcmp(dataset_names{i}, 'geuter_2013_placebo') 
            con_to_grab = 1;

        end
        
        
        this_contrast = char(strcat(dataset_keys(i),'_', contrast_names{con_to_grab}));
        this_data = contrasts.DATA_OBJ_CON{con_to_grab};
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
        multistudy_contrasts_names{end+1} = [fmri_ds.image_names];
        
    %end

end


% save multistudy files

multistudy_contrasts.data = multistudy_contrasts_data;
multistudy_contrasts.contrast_names = multistudy_contrasts_names;

savename = strcat('multistudy_contrasts_', date, '.mat')
save(fullfile(results_dir, savename), 'multistudy_contrasts') % save


cd(results_dir)











