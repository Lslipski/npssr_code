%% study type regression
% this code will load the study coding variables, calculate one NPS and 
% one pain rating effect size per study, and regress the study
% characteristic variables onto those effect sizes.

%% Set paths
regressiondir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/analysis/study_type_regression';
ms_resultsdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';


%% load study code table
T = readtable(fullfile(regressiondir,'study_coding.csv'));

%remove controllability for now (no comparable pain ratings)
T(5,:) = [];

%% load brain/pain effect sizes
% these were calculated in analysis_multistudy.m
pain_d = load(fullfile(ms_resultsdir, 'pain_rating_d.mat'));
nps_d = load(fullfile(ms_resultsdir, 'nps_d.mat'));

%% Run regression models
Xpain = addvars(T,pain_d.d','After','direct');
Xpain.Properties.VariableNames{4} = 'effect_size';
Xpain
mdl_pain = fitlm(Xpain)

Xnps = addvars(T,nps_d.d','After','direct');
Xnps.Properties.VariableNames{4} = 'effect_size';
Xnps
mdl_nps = fitlm(Xnps)







