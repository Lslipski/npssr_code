datadir = '/Volumes/f0040y1/npssr/';
imgsdir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/jepma_2018_ie2'

load(fullfile(imgsdir, 'IE2_34_betadirs_ratings.mat'));

% all 34 subject IDs 
subject_id = [1004
1005
1006
1010
1051
1068
1091
1101
1102
1168
1183
1193
1197
1203
1204
1210
1214
1215
1223
1226
1233
1237
1240
1246
512
957
961
972
973
974
975
977
993
996];

% get unique, ordered list of subjects
uniq_sid = unique(subject_id);

% get the list of 70 ST image names to import
x = [med_vars.imgs{1}]
image_names = {}

% initialize empty fmri_data object to hold all average beta maps
subj_mean_data = fmri_data();
subj_mean_data.dat = []; % clear mask from dat

% this loops over all subject folders, imports images, averages STs, and
% saves 
for p = 1:34
    
    % set data folder for this subject
    datafolder = fullfile(datadir, ['sub' sprintf('%.0f', uniq_sid(p))])
    
    % this loop takes all 70 ST images in a folder then loads into an fmri_data
    % object
    for i = 1:70
        [filepath, name, ext] = fileparts(x(i,:));
        newfile = [name ext];
        image_names{i} = fullfile(datafolder, newfile);
    end

    % create fmri data object of single trial images for this subject
    sub_data_obj = fmri_data(image_names);
    sub_data_obj = mean(sub_data_obj)


    % concatenate new subject data to grand fmri_data object
    if p == 1
        subj_mean_data = sub_data_obj;
    else
        subj_mean_data = cat(subj_mean_data, sub_data_obj);
    end
    
    % save fmri data object with mean ST image for each of 34 subjects
    DAT = subj_mean_data;
    savefilename = fullfile(imgsdir, 'jepma_2018_ie2_ST_34subj.mat');
    save(savefilename, 'DAT')
    
    clear sub_data_obj;
    
    sprintf('Iteration %d', p)

    
end 




% bogdan's sample code:
% ie2_dat_obj; % fmri_data object of single trial images
% subject_id; % list of subject ids, length(subject_id) = size(ie_dat_obj.dat,2)
% uniq_sid = unique(subject_id);
% subj_mean_dat = cell(length(uniq_sid),1);
% for i = 1:length(uniq_sid)
%  this_sid = uniq_sid(i);
%  this_idx = this_sid == subject_id;
%  this_dat = ie2_dat_obj.get_wh_image(this_idx);
%  subj_mean_dat{i} = mean(this_dat);
% end
% subj_mean_dat = cat(subj_mean_dat{:});


