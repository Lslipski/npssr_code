%% Similarity Comparisons
% This code loads data from compute_signature_scores_and_normalizes.m and
% creates plots for visualizing how different pain-regulation strategies
% compare to each other on these various dimensions.
%

%% Load Data for plots
datadir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';
cd(datadir)
sigtable = readtable('all_signature_and_pain_scores_03-May-2021.csv');

%% MAD_NPS and MAD_Pain_Scores
gscatter( sigtable.MAD_NPS_dotproduct_zscoreimages,  sigtable.MAD_pain_scores,  study)
title('NPS Values vs. Pain Scores')
xlabel('NPS Values')
ylabel('Pain Scores')
legend('Location','northeastoutside')


%% MAD_NPS and MAD_SIIPS
% VALUES
gscatter( sigtable.MAD_NPS_dotproduct_zscoreimages,  sigtable.MAD_SIIPS_dotproduct_zscoreimages,  study)
title('NPS vs. SIIPS Values')
xlabel('NPS')
ylabel('SIIPS')
legend('Location','northeastoutside')


%% MAD_SIIPS and MAD_Pain_Scores
% VALUES
gscatter( sigtable.MAD_SIIPS_dotproduct_zscoreimages,  sigtable.MAD_pain_scores,  study)
title('SIIPS vs. Pain Ratings Values')
xlabel('SIIPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')


%% MAD_PINES and MAD_Pain_Scores
gscatter( sigtable.MAD_PINES_dotproduct_zscoreimages,  sigtable.MAD_pain_scores,  study)
title('PINES vs. Pain Ratings Values')
xlabel('PINES')
ylabel('Pain Rating')
legend('Location','northeastoutside')


%% MAD_DMN and MAD_Pain Scores
gscatter( sigtable.MAD_Default_dotproduct_zscoreimages,  sigtable.MAD_pain_scores,  study)
title('DMN vs. Pain Ratings Values')
xlabel('DMN')
ylabel('Pain Rating')
legend('Location','northeastoutside')


%% MAD Limbic and MAD_Pain Scores
gscatter(sigtable.MAD_Limbic_dotproduct_zscoreimages,  sigtable.MAD_pain_scores,  study)
title('Limbic vs. Pain Ratings Values')
xlabel('Limbic')
ylabel('Pain Rating')
legend('Location','northeastoutside')

%% Prep Regression
%Y =  MAD_pain_scores;
myvars = {'MAD_pain_scores'
        'MAD_NPS_dotproduct_zscoreimages'
        'MAD_SIIPS_dotproduct_zscoreimages'
        'MAD_PINES_dotproduct_zscoreimages'
        'MAD_VPS_dotproduct_zscoreimages'
        'MAD_VPS_nooccip_dotproduct_zscoreimages'
        'MAD_FM_Multisens_dotproduct_zscoreimages'
        'MAD_FM_pain_dotproduct_zscoreimages'
        'MAD_Rejection_dotproduct_zscoreimages'
        'MAD_Default_dotproduct_zscoreimages'
        'MAD_dAttention_dotproduct_zscoreimages'
        'MAD_Frontoparietal_dotproduct_zscoreimages'
        'MAD_Limbic_dotproduct_zscoreimages'
        'MAD_Somatomotor_dotproduct_zscoreimages'
        'MAD_vAttention_dotproduct_zscoreimages'
        'MAD_Visual_dotproduct_zscoreimages'
        'study'};
    
dat = sigtable(:,myvars);
num_only = sigtable(:,myvars(1:end - 1));
corrplot(num_only)

% It looks like the following are correlated with pain scores above 0.10:
% NPS
% SIIPS
% PINES
% Rejection
% DMN
% vAttention

% Will try these each univariate

%% Univariate models

% NPS only model 
% AIC: 986.62
% p = 0.0063361
lme = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_NPS_dotproduct_zscoreimages + (1 | study)')

% SIIPS only 
% AIC: 988.79
% p =0.021462
lme = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_SIIPS_dotproduct_zscoreimages + (1 | study)')

% PINES only 
% AIC: 992.69
% p = 0.23544
lme = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_PINES_dotproduct_zscoreimages + (1 | study)')

% Rejection only 
% AIC: 991.95
% p = 0.14342
lme = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_Rejection_dotproduct_zscoreimages + (1 | study)')

% DMN only 
% AIC: 989.55 
% p = 0.033421
lme = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_Default_dotproduct_zscoreimages + (1 | study)')

% vAttention only 
% AIC: 987.51 
% p = 0.010391
lme = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_vAttention_dotproduct_zscoreimages + (1 | study)')

%% Multivariate Regression
% I will only include variables that were significantly predictive of pain
% in univariate models:

% NPS, SIIPS, DMN, vAttention
% AIC: 989.64
% No significance
lmer = fitlme(dat, 'MAD_pain_scores ~ 1 + MAD_NPS_dotproduct_zscoreimages + MAD_SIIPS_dotproduct_zscoreimages + MAD_Default_dotproduct_zscoreimages + MAD_vAttention_dotproduct_zscoreimages + (1 | study)')


%% Principal Component Regression
% get pca scores
[wcoeff,score,latent,tsquared,explained]  = pca(table2array(dat(:,2:end - 1))); % ignore pain scores and study
pcrdat = array2table(score);
pcrdat.pain_scores =  sigtable.pain_scores;
pcrdat.study = sigtable.study;

% scree plot
figure()
pareto(explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')

% PCR with first 
pcr = fitlme(pcrdat, 'pain_scores ~ 1 + score1 + score2 + score3 + score4 + score5 + score6 + score7 + (1 | study)')
