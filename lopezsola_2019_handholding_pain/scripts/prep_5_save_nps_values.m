% load dataset from published study 
a_set_up_paths_always_run_first

x = load('/Users/lukie/Documents/canlab/NPSSR/npssr_code/lopezsola_2019_handholding_pain/results/image_names_and_setup.mat');
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
subject_id = {'S418_OC1122'
'S576_OC937'
'S578_OC940'
'S582_OC948'
'S591_OC963'
'S593_OC965'
'S601_OC985'
'S603_OC987'
'S617_OC1029'
'S624_OC1049'
'S626_OC1054'
'S628_OC1064'
'S630_OC1066'
'S632_OC1068'
'S635_OC1071'
'S636_OC1072'
'S638_OC1074'
'S644_OC1080'
'S649_OC1084'
'S653_OC1089'
'S678_OC1113'
'S687_OC1124'
'S689_OC1126'
'S691_OC1128'
'S696_OC1133'
'S698_OC1135'
'S700_OC1137'
'S708_OC1145'
'S711_OC1148'
'S713_OC1150'};

subjids = [subject_id];

%% Add subject IDs and nps values to  table

% add nps data first, then add subject IDs as final column.
nps_table = array2table(T,'VariableNames',[x.DAT.conditions x.DAT.contrastnames]);
newnames = 'subjids';
nps_table = addvars(nps_table, subjids, 'NewVariableNames', newnames);%, 'NewVariableNames', newnames)

save(fullfile(resultsdir,'npsvals_lopezsola_2019_handholding_pain.mat'), 'nps_table') % save
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
