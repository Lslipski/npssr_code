savedir = '/Users/lukie/Documents/canlab/NPSSR/results';
sectionbreak = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';

%% Import data
datadir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results/';
% load all pain ratings for each study
cd(datadir);
load('multistudy_ratings_05-Apr-2021.mat');

% RESCALE by MAD (median abs. deviation) column-wise:
[n, k] = size(ms_ratings.ratings);
ms_ratings_all = ms_ratings.ratings ./ repmat(mad(ms_ratings.ratings), n, 1);

ms_ratings_tab = array2table(ms_ratings_all);
ms_ratings_tab.Properties.VariableNames = ms_ratings.names;

% load corresponding brain contrasts from multistudy_contrasts
load('multistudy_contrasts_05-Apr-2021.mat');
braincons = [1 2 6 3 5 10 9 7 8 11 12]; % corresponding to the pain ratings list order
ms_brain = multistudy_contrasts.data(braincons)
ms_brain_labels = multistudy_contrasts.contrast_names(braincons);

% print ratings and nps lists to make sure they match in order
ms_ratings_tab.Properties.VariableNames'
ms_brain_labels'
clear multistudy_contrasts;

%% Mask and create dataset for nnmf analysis
% Load mask
mask = load_atlas('canlab2018_2mm');

% run QA, unthresholded t-test, and fdr corrected t-test for each data set
for i = 1:size(ms_brain, 2)
    ms_brain{i} = resample_space(ms_brain{i}, mask);
    % plot
    %%% ms_brain_labels
    disp(sectionbreak);
    disp(ms_brain_labels{i});
    disp(sectionbreak);
    plot(ms_brain{i});drawnow; snapnow
    close, close
    
    % uncorrected t-test
    t = ttest(ms_brain{i});
    orthviews(t); title(ms_brain_labels{i}); drawnow; snapnow; close;
    montage(t); drawnow; snapnow; close;
    r = region(t);
    table(r);

    % fdr corrected t-test, d < 0.05
    t = threshold(t, .05, 'fdr', 'k', 10);
    orthviews(t); drawnow; snapnow; close;
    montage(t); drawnow; snapnow; close;
    r = region(t);
    table(r);
    
end



