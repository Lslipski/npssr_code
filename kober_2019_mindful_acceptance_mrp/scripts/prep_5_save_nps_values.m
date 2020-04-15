% Grab NPS values from DAT (created in prep_xxx scripts).
T = [DAT.npsresponse DAT.npscontrasts];

   

%% get subjids from the imagine down image names (same for all 3 conditions)
subjids = {'MRP01'
'MRP02'
'MRP03'
'MRP04'
'MRP05'
'MRP06'
'MRP07'
'MRP08'
'MRP10'
'MRP11'
'MRP12'
'MRP13'
'MRP14'
'MRP16'
'MRP17'
'MRP18'};

% add conditions as variable names to the nps values table and save to
% /results subfolder
nps_table = array2table(T,'VariableNames',[DAT.contrastnames DAT.conditions]);
newnames = 'subjids';
nps_table = addvars(nps_table, subjids', 'NewVariableNames', newnames); % add subject IDs as column


save(fullfile(resultsdir,'npsvals_kober_2019_mindful_acceptance_mrp.mat'), 'nps_table') % save
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
