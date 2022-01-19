load('/Volumes/GoogleDrive/.shortcut-targets-by-id/1mJWy83hfJroegzlDna9MwWT4RmqUYuZH/NPSSR/Data/atlas_2010_exp/canlab_dataset_objects_for_pain_ratings/canlab_dataset_atlas_2010_exp.mat')
t = table(DAT.Subj_Level.id', DAT.Subj_Level.data', 'VariableNames', [{'Subj_id'} DAT.Subj_Level.names]);
load('/Volumes/GoogleDrive/.shortcut-targets-by-id/1mJWy83hfJroegzlDna9MwWT4RmqUYuZH/NPSSR/Data/atlas_2010_exp/fmri_data_objects_for_contrasts/contrast_data_objects.mat')
DATA_OBJ_CON{1}

% Make subject-level table - names of vars will be column names in table
t = table(DAT.Subj_Level.id', DAT.Subj_Level.data, 'VariableNames', {'Subj_id' 'Subj_data'});
t = splitvars(t, 'Subj_data', 'NewVariableNames', DAT.Subj_Level.names);

% (Add descriptive elements)
t.Properties.Description = DAT.Description.Experiment_Name;
t.Properties.VariableDescriptions = [{'Subject ID code'}; DAT.Subj_Level.descrip];

% Standard measure of modulatory effects on pain across studies
t.pain_effect = t.pain_ratings_nodrug_v_drug;
t.pain_effect_normed = t.pain_effect ./ mad(t.pain_effect);
t.pain_effect_rank = rankdata(t.pain_effect) ./ length(t.pain_effect);

t.Properties.VariableDescriptions

%%

% Standard measure of modulatory effects on pain across studies
t.pain_effect = t.Pain_Ratings_Neg_vs_Pos;
t.pain_effect_normed = t.pain_effect ./ mad(t.pain_effect);
t.pain_effect_rank = rankdata(t.pain_effect) ./ length(t.pain_effect);

%% Check Roy NPS values

cd('/Users/torwager/Dropbox (Dartmouth College)/A1_WORKING_ANALYSES/2022_NPSSR_Pain_regulation_multistudy/NPS_treatment_effects_summary/NPSSR_contrast_images/2009_IAPS_emo_mod_pain_Mroy/data/neg_vs_pos')
subjects = canlab_list_subjects(pwd, 'subject*')
subjects = sort_image_filenames(subjects');
f = canlab_list_files(subjects', 'con_0015.img')

%%
f = filenames('sub*img')
f = f([5:end 1:4])
obj = fmri_data(f);
npsvals = apply_nps(obj);
nps2 = apply_mask(obj, load_image_set('nps'), 'pattern_expression');
[npsvals{1} nps2]

% resample NPS to data -- this matches apply_mask and apply_all_signatures,
% not apply_nps
npsobj = load_image_set('nps');
npsobj_rs = resample_space(npsobj, obj);
npsvals = obj.dat' * npsobj_rs.dat

% resample data to NPS
obj_rs = resample_space(obj, npsobj);
npsvals2 = obj_rs.dat' * npsobj.dat

corr(npsvals, npsvals2)

% Check order of image names - these are in the wrong (not numerically
% sorted) order
cd('/Users/torwager/Dropbox (Dartmouth College)/A1_WORKING_ANALYSES/2022_NPSSR_Pain_regulation_multistudy/NPSSR/Data/roy_2009_iaps_pain/results')
load('data_objects.mat')
DATA_OBJ{1}.image_names

plot(DATA_OBJ{2})


% Roy summary:
% Con Images Luke S has seem to match con imgs stored before. Tho original
% name is con_0015, and now renamed con_0005.
% NPS values do not match. It's not just a reordering
% apply_nps and apply_mask = apply_all_signatures give slightly diff values, but correlated 0.99

% saved contrast data objects have no metadata and wrong number of images
% (24), for 12 subjects. This seems to be because img and hdr files are BOTH entered, so images are duplicates.
% should recreate these or fix them. 

% Try to fix
obj2 = DATA_OBJ{2}; % neg vs pos in DAT.conditions
obj2 = get_wh_image(obj2, [2:2:24]);
obj2 = get_wh_image(obj2, [5:12, 1:4]);
obj2.image_names

npsvals = apply_nps(obj2);
nps2 = apply_mask(obj2, load_image_set('nps'), 'pattern_expression');

npsvals = [npsvals{1} nps2]

corr(x)
figure; plot(x)

% This works -- NPS values now match

%%
% d ]= choc_desagreable
% a = choc_agreable
% n = choc_neutre

load('/Users/torwager/Dropbox (Dartmouth College)/A1_WORKING_ANALYSES/2022_NPSSR_Pain_regulation_multistudy/NPS_treatment_effects_summary/NPSSR_contrast_images/2009_IAPS_emo_mod_pain_Mroy/data/beta_images/subject2/AR1_avecratings_18sec_Oct2008/SPM.mat')
char(SPM.xCon.name)

SPM.xCon(10).name  % confirmed neg vs neu shock 'cocs_d_vs_n - All Sessions'
SPM.xCon(11).name  % confirmed 'chocs_n_vs_a - All Sessions' (but direction? should flip?)
SPM.xCon(5).name   % 'chocs_d_vs_a - All Sessions'

% but originally i had contrasts for con 13, 14, 15 (with no .hdrs)
% this seems wrong according to names of contrasts, and Luke's version
% correct contrasts
SPM.xCon(13:15).name

