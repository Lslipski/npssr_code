% create empty table
T = table();


% put nps responses into a table. If missing participants, fill with NaN
T = []
for p = 1:size(DAT.npscontrasts,2) %pull from contrasts which include all conditions + down and up vs. standard
    mat = [DAT.npscontrasts{p}];
    T = [T mat];
end
    

%% get subjids from the imagine down image names (same for all 3 conditions)
data_object_wrangling;
subjids = imaginedown.dat.image_names;

% add conditions as variable names to the nps values table and save to
% /results subfolder
nps_table = array2table(T,'VariableNames',DAT.contrastnames)
newnames = 'subjids'
nps_table = addvars(nps_table, subjids', 'NewVariableNames', newnames) % add subject IDs as column

save(fullfile(resultsdir,'npsvals_bmrk3.mat'), 'nps_table') % save
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
