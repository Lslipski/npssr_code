%% THIS IS an ad hoc script for organizing an existing set of fmri_data objects into
% a cell array in DATA_OBJ

data_object_wrangling()

dofullplot = 1;

DATA_OBJ = {};

DATA_OBJ = {imaginedown.dat standard.dat imagineup.dat};

n = length(DATA_OBJ);

for i = 1:n
    
DAT.imgs{i} = DATA_OBJ{i}.fullpath;

end

% add placeholder wildcards

for i = 1:n
    DAT.functional_wildcard{i} = DAT.conditions{i};
end

% THE REST OF THE SCRIPT IS THE SAME AS THE STANDARD PREP_2 SCRIPT

%% Globals

n = length(DATA_OBJ);

for i = 1:n
    
    % QUALITY CONTROL METRICS
    printstr('QC metrics');
    printstr(dashes);
    
    [group_metrics individual_metrics values gwcsf gwcsfmean gwcsfl2norm] = qc_metrics_second_level(DATA_OBJ{i});
    
    DAT.gray_white_csf{i} = values;
    drawnow; snapnow
    
    % optional: plot
    % -------------------------------------------------------------------
    
    if dofullplot
        fprintf('%s\nPlot of images: %s\n%s\n', dashes, DAT.functional_wildcard{i}, dashes);
        disp(DATA_OBJ{i}.fullpath)
        
        plot(DATA_OBJ{i}); drawnow; snapnow
        
        hist_han = histogram(DATA_OBJ{i}, 'byimage', 'by_tissue_type');
        drawnow; snapnow
        
    end
    
    % derived measures
    
    DATA_OBJ{i} = remove_empty(DATA_OBJ{i});
    DAT.globalmeans{i} = mean(DATA_OBJ{i}.dat)';
    DAT.globalstd{i} = std(DATA_OBJ{i}.dat)';
    
    drawnow, snapnow
end

%% CSF REMOVAL AND RESCALING
printhdr('CSF REMOVAL AND RESCALING');

% scaling by CSF values
% ----------------------------------------------------------------
% Note: Do not train cross-validated models on these scaled objects because
% they perform operations using group information to transform individual
% image values.

DATA_CAT = DATA_OBJ{:};

clear sz

for i = 1:size(DATA_OBJ, 2), sz(1, i) = size(DATA_OBJ{i}.dat, 2); end
DATA_CAT.images_per_session = sz;
DATA_CAT.removed_images = 0;

%DATA_CAT = preprocess(DATA_CAT, 'remove_csf');
%DATA_CAT = preprocess(DATA_CAT, 'rescale_by_csf');
%DATA_CAT = preprocess(DATA_CAT, 'divide_by_csf_l2norm');

DATA_CAT = rescale(DATA_CAT, 'l2norm_images');     % scaling sensitive to mean and variance.

DATA_CAT = preprocess(DATA_CAT, 'windsorize'); % entire data matrix

% DATA_OBJsc = split(DATA_CAT); %removed by Luke, not necessary for bmrk3
% data

if dofullplot
    disp('AFTER WINDSORIZING AND RESCALING BY L2NORM'); %'ADJUSTING FOR WM/CSF');
    
    plot(DATA_CAT); drawnow; snapnow
    
end

clear DATA_CAT


%% SAVE
printhdr('Save results');

savefilename = fullfile(resultsdir, 'image_names_and_setup.mat');
save(savefilename, 'DAT', 'basedir', 'datadir', 'resultsdir', 'scriptsdir', 'figsavedir');

savefilenamedata = fullfile(resultsdir, 'data_objects.mat');
save(savefilenamedata, 'DATA_OBJ');

savefilenamedata = fullfile(resultsdir, 'data_objects_scaled.mat');
save(savefilenamedata, 'DATA_OBJsc');




