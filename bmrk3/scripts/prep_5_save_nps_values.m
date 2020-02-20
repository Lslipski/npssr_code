% create empty table
T = table();


% put nps responses into a table. If missing participants, fill with NaN
T = []
for p = 1:size(DAT.npsresponse,2)
    mat = [DAT.npsresponse{p}];
    mat(end+1:20,:)=nan;
    T = [T mat];
end
    

%% This grabs all the subject imaging files and adds them to cimgs
% for i = 1:length(DAT.conditions)
% 
%     if ~isempty(DAT.subfolders) && ~isempty(DAT.subfolders{i})  % if we have subfolders
%         str = fullfile(datadir, DAT.subfolders{i}, DAT.functional_wildcard{i});
%         cimgs{i} = plugin_unzip_images_if_needed(str);
%     else
%         str = fullfile(datadir, DAT.functional_wildcard{i});
%         cimgs{i} = plugin_unzip_images_if_needed(str);
%     end
%     %  CHECK that files exist
%     if isempty(cimgs{i}), fprintf('Looking in: %s\n', str), error('CANNOT FIND IMAGES. Check path names and wildcards.'); end
%     cimgs{i} = cellfun(@check_valid_imagename, cimgs{i}, repmat({1}, size(cimgs{i}, 1), 1), 'UniformOutput', false);
% end


%% get subjids from cimgs, now that the files imported
subjids = imaginedown.dat.image_names;

% add conditions as variable names to the nps values table and save to
% /results subfolder
nps_table = array2table(T,'VariableNames',DAT.conditions)
newnames = 'subjids'
nps_table = addvars(nps_table, subjids', 'NewVariableNames', newnames) % add subject IDs as column

save(fullfile(resultsdir,'npsvals_bmrk3.mat'), 'nps_table') % save
printhdr('Saved npsvalues')
sprintf('Results Directory: %s', resultsdir)
