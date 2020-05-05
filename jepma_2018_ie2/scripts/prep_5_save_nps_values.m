% load dataset from published study 
a_set_up_paths_always_run_first

x = load('/Users/lukie/Documents/canlab/NPSSR/npssr_code/jepma_2018_ie2/results/image_names_and_setup.mat');
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
subject_id = {'1004'
'1005'
'1006'
'1010'
'1051'
'1068'
'1091'
'1101'
'1102'
'1168'
'1183'
'1193'
'1197'
'1203'
'1204'
'1210'
'1214'
'1215'
'1223'
'1226'
'1233'
'1237'
'1240'
'1246'
'512'
'957'
'961'
'972'
'973'
'974'
'975'
'977'
'993'
'996'};

subjids = [subject_id];

%% Add subject IDs and nps values to  table

% add nps data first, then add subject IDs as final column.
nps_table = array2table(T,'VariableNames',[x.DAT.conditions x.DAT.contrastnames])
newnames = 'subjids';
nps_table = addvars(nps_table, subjids, 'NewVariableNames', newnames);%, 'NewVariableNames', newnames)

save(fullfile(resultsdir,'npsvals_jepma_2018_ie2.mat'), 'nps_table') % save
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
