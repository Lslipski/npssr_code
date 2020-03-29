% load dataset from published study 
x = load('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/koban_2019_scebl_social_pain/results/IndivContrasts_fromModel6/results/image_names_and_setup.mat');
fprintf('Loaded dataset.\nConditions:\n');
x.DAT.conditions
fprintf('Contrasts: \n')
x.DAT.contrastnames

T=[];
% put nps condition responses into array
for p = 1:size(x.DAT.npsresponse,2) %pull from contrasts which include all conditions + down and up vs. standard
    mat = [x.DAT.npsresponse{p}];
    T = [T mat];
end
% put nps contrast responses into array. 
for p = 1:size(x.DAT.npscontrasts,2) %pull from contrasts which include all conditions + down and up vs. standard
    mat = [x.DAT.npscontrasts{p}];
    T = [T mat];
end


%% get subjids 
subjids = {'Soc_pathA_Sub1 '
'Soc_pathA_Sub10'
'Soc_pathA_Sub11'
'Soc_pathA_Sub12'
'Soc_pathA_Sub13'
'Soc_pathA_Sub14'
'Soc_pathA_Sub15'
'Soc_pathA_Sub16'
'Soc_pathA_Sub17'
'Soc_pathA_Sub18'
'Soc_pathA_Sub19'
'Soc_pathA_Sub2 '
'Soc_pathA_Sub20'
'Soc_pathA_Sub21'
'Soc_pathA_Sub22'
'Soc_pathA_Sub23'
'Soc_pathA_Sub24'
'Soc_pathA_Sub25'
'Soc_pathA_Sub26'
'Soc_pathA_Sub27'
'Soc_pathA_Sub28'
'Soc_pathA_Sub29'
'Soc_pathA_Sub3 '
'Soc_pathA_Sub30'
'Soc_pathA_Sub31'
'Soc_pathA_Sub32'
'Soc_pathA_Sub33'
'Soc_pathA_Sub34'
'Soc_pathA_Sub35'
'Soc_pathA_Sub36'
'Soc_pathA_Sub4 '
'Soc_pathA_Sub5 '
'Soc_pathA_Sub6 '
'Soc_pathA_Sub7 '
'Soc_pathA_Sub8 '
'Soc_pathA_Sub9 '};

subjids = [subjids];

%% Add subject IDs and nps values to  table

% add nps data first, then add subject IDs as final column.
nps_table = array2table(T,'VariableNames',[x.DAT.conditions x.DAT.contrastnames])
newnames = 'subjids';
nps_table = addvars(nps_table, subjids, 'NewVariableNames', newnames);%, 'NewVariableNames', newnames)

save(fullfile(resultsdir,'npsvals_koban_2019.mat'), 'nps_table') % save
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
