cd(datadir)

s = canlab_list_subjects(pwd, 'remi*')
names = canlab_list_files(pwd, s, 'r_swbeta_0002.img.gz')
hotopen = fmri_data(names, 'sample2mask');
names2 = canlab_list_files(pwd, s, 'r_swbeta_0008.img.gz')
hothidden = fmri_data(names2, 'sample2mask');
%%
hot_drug_fx = hotopen;
hot_drug_fx.dat = (hotopen.dat + hothidden.dat) ./ 2;
%plot(hot_drug_fx)
t = ttest(hot_drug_fx);
t = threshold(t, .001,'unc');
nps = apply_nps(hot_drug_fx);
barplot_columns(nps{1});
% save fmri_data objects
% save 4-D nii files for archival purposes
hotopen.fullpath = fullfile(pwd, 'remi_hot_drug_fx_open.nii');
write(hotopen);
hothidden.fullpath = fullfile(pwd, 'remi_hot_drug_fx_hidden.nii');
write(hothidden);
hot_drug_fx.fullpath = fullfile(pwd, 'remi_hot_drug_fx.nii');
