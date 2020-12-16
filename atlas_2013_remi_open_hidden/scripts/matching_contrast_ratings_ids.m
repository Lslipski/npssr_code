% this script removes 4 subjects data from contrast_data_objects.mat in the
% atlas remi dataset becauase only 17 subjects ratings were in Bogdan's
% single trials data repository
cd(resultsdir)

load('image_names_and_setup.mat'); %get image names in order from contrast_data_objects.mat

x = load('canlab_dataset_atlas_2013_remi_open_hidden.mat');

ids17 = x.DAT.Subj_Level.id;
for i = 1:size(ids17,2)
    ids17(i) = extractBetween(ids17{i},'remi','_');
end

%get unique 
ids21_all = DAT.imgs(1);
ids21 = cell(1, size(ids21_all{1},1));
for p = 1:size(ids21_all{1},1)
    ids21(p) = extractBetween(ids21_all{1}(p,:),'/remi','_')
end

% get indices of 21 that are in 17
my_indices = [];
for i =1:size(ids21,2)
    i
    for p = 1:size(ids17,2)
        if strcmp(my21, ids17{p})
            my_indices = [my_indices i];
        end
    end
end
            
% load up contrast_data_objects to remove extra subjects
contrast_dat = load('contrast_data_objects.mat');
contrast_dat.DATA_OBJ_CON{1}.removed_images = contrast_dat.DATA_OBJ_CON{1}.removed_images(my_indices);
contrast_dat.DATA_OBJ_CON{1}.files_exist = contrast_dat.DATA_OBJ_CON{1}.files_exist(my_indices);
contrast_dat.DATA_OBJ_CON{1}.dat = contrast_dat.DATA_OBJ_CON{1}.dat(:,my_indices);

DATA_OBJ_CON = {contrast_dat.DATA_OBJ_CON{1}};
save('contrast_data_objects.mat','DATA_OBJ_CON');
            