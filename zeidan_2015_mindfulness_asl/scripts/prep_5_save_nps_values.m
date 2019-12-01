% create empty table
T = table();


% put nps responses into a table. If missing participants, fill with NaN
T = []
for p = 1:size(DAT.npsresponse,2)
    mat = [DAT.npsresponse{p}];
    mat(end+1:20,:)=nan;
    T = [T mat];
end

% add conditions as variable names to the nps values table and save to
% /results subfolder
nps_table = array2table(T,'VariableNames',DAT.conditions)
save(fullfile(resultsdir,'npsvals_mindfulness_zeidan.mat'), 'nps_table')
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
