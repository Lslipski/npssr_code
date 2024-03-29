datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/jepma_2018_ie2/contrast_and_behavioral_to_use/fmri_objs';
savedir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/jepma_2018_ie2/contrast_and_behavioral_to_use/';

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

% cue_type = {'high_cue', 'neutral_cue', 'low_cue', 'high_temp' 'low_temp'}
cue_type = {'high_temp' 'low_temp'} % added temps later so only running these for now

for p = 1:34
    %for cue = 1:5 % when cue type above is being run on all 5
     for cue = 1:2 % for only running on temps   
        dat = load(fullfile(datadir, [char(cue_type(cue)), '_sub_', sprintf('%.0f', subject_id(p)), '.mat']))
        dat.DAT.fullpath = fullfile(savedir, [char(cue_type(cue)), '_sub_', sprintf('%.0f', subject_id(p)), '.img']);
        write(dat.DAT)
    end
end