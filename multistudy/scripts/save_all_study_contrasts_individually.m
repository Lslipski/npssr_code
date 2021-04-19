%% this scripts saves a single file for each subject's contrast
% First it loads up the multistudy contrast dataframe (specified below)
% Then is loops through each study dataset, resamples to the space of brainmask.nii,
% adjusts the fullpath, and saves contrasts for each subject together in
% one .nii file per subject.

% where to save all the niftis
savedir = '/Users/lukie/Documents/canlab/NPSSR/multistudy_contrasts/'
%% Load Data
curdir = pwd;
datadir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results/'
cd(datadir);
% load  brain contrasts from multistudy_contrasts
load('multistudy_contrasts_05-Apr-2021.mat');
braincons = [1 2 6 3 5 10 9 7 8 11 12]; % corresponding to the pain ratings list order
ms_brain = multistudy_contrasts.data(braincons)
ms_brain_labels = multistudy_contrasts.contrast_names(braincons);


%% save all contrasts one study at a time

%atl = load_atlas('canlab2018_2mm'); 242953
template = fmri_data('/Users/lukie/Documents/canlab/CanlabCore/CanlabCore/canlab_canonical_brains/Canonical_brains_surfaces/brainmask.nii');


for i = 1:length(braincons)
    thisdat = ms_brain{i}; % load data set
    dat_rs = resample_space(thisdat, template); %resample to 242953 space    
    
    thisname = regexprep(thisdat.image_names, ' ', '_');
    [n, k] = size(dat_rs.dat);
    
    % adjust fullpath to correspond to individual file names per sub
    for q = 1:k
        sub = num2str(q,'%02.f');
        stud = num2str(i,'%02.f');
        filen = fullfile(savedir,strcat('study-',stud,'_sub-',sub,'_', thisname,'.img'));

        this_loop_dat = get_wh_image(dat_rs, q);
        this_loop_dat.fullpath = filen;
        write(this_loop_dat)
    end
    
    
end

cd(curdir);











