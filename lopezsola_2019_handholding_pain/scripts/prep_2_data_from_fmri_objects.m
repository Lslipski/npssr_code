%% THIS IS an ad hoc script for organizing an existing set of fmri_data objects into
% a cell array in DATA_OBJ
x = load('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/lopezsola_2019_handholding_pain/LopezSola2019_HeatPainAll_BetaMaps_PisPartnerHH_BisBallholding.mat');

subject_list = {'S418_OC1122'
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

dofullplot = 1;

DATA_OBJ = {};

DATA_OBJ = {x.dat_heatall_B x.dat_heatall_P};

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

% set fullpath and image_names to character arrays, which cat() requires
for i =1:n
    DATA_OBJ{i}.image_names = char(DATA_OBJ{i}.image_names)
    DATA_OBJ{i}.fullpath = char(DATA_OBJ{i}.fullpath)
end


DATA_CAT = cat(DATA_OBJ{:});

clear sz

for i = 1:size(DATA_OBJ, 2), sz(1, i) = size(DATA_OBJ{i}.dat, 2); end
DATA_CAT.images_per_session = sz;
DATA_CAT.removed_images = 0;

%DATA_CAT = preprocess(DATA_CAT, 'remove_csf');
%DATA_CAT = preprocess(DATA_CAT, 'rescale_by_csf');
%DATA_CAT = preprocess(DATA_CAT, 'divide_by_csf_l2norm');

DATA_CAT = rescale(DATA_CAT, 'l2norm_images');     % scaling sensitive to mean and variance.

DATA_CAT = preprocess(DATA_CAT, 'windsorize'); % entire data matrix

DATA_OBJsc = split(DATA_CAT); 

% data% Enforce variable types in objects to save space
for i = 1:length(DATA_OBJsc), DATA_OBJsc{i} = enforce_variable_types(DATA_OBJsc{i}); end

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




