% this script uses the apply_siips method to get scalar outputs for each
% participant in each contrast in each study of the
% multistudy_contrasts_scaled 

% set paths
code_dir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/scripts';
results_dir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';
cd(results_dir);

% load multistudy data set
load('multistudy_contrasts_scaled_07-Sep-2020.mat')
dat = multistudy_contrasts_scaled.data;
num_cons = size(dat, 2);

% initialize cell array to hold SIIPS output values of length equal to
% number of contrasts in dat
siips_results = cell(1,num_cons);

% print names of contrasts
% loop through contrasts, apply siips, save results
for i=1:num_cons
    disp(multistudy_contrasts_scaled.contrast_names{i})
    siips_results(i) = apply_siips(dat(i));
end

% save multistudy files

multistudy_siips_results.data = siips_results;
multistudy_siips_results.contrast_names = multistudy_contrasts_scaled.contrast_names;

savename = strcat('multistudy_siips_results_', date, '.mat');
save(fullfile(results_dir, savename), 'multistudy_siips_results'); % save
cd(code_dir);


% disp size of new siips output object
disp(size(siips_results));
disp('Saved to: ');
disp(results_dir);
disp('You are in: ');
disp(code_