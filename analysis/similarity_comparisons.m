%% Similarity Comparisons
% This code loads data from compute_signature_scores_and_normalizes.m and
% creates plots for visualizing how different pain-regulation strategies
% compare to each other on these various dimensions.
%

%% Load Data for plots
sigtable = readtable('all_contrast_all_signature_scores_27-Apr-2021.csv');
rank_table = readtable('all_ranked_contrast_all_signature_scores_27-Apr-2021.csv');
load('all_contrast_all_signature_scores_object_27-Apr-2021.mat');

%zscore pain ratings if desired
%sigtable.pain_scores = zscore(sigtable.pain_scores);

% divide by Mean Absolute Deviation
[n, k] = size(sigtable(:,1:16));
mad_sigtable = array2table(table2array(sigtable(:,1:16)) ./ repmat(mad(table2array(sigtable(:,1:16))), n, 1));
mad_sigtable.Properties.VariableNames = sigtable.Properties.VariableNames(1:16);
mad_sigtable.study = sigtable.study;

%% VALUES by RANKS NPS
gscatter(sigtable.NPS_dotproduct_zscoreimages, rank_table.NPS_dotproduct_zscoreimages, sigtable.study)
title('NPS Values vs. NPS Ranks')
xlabel('NPS Values')
ylabel('NPS Ranks')
legend('Location','northeastoutside')


%% NPS by SIIPS

% VALUES
gscatter(sigtable.NPS_dotproduct_zscoreimages, sigtable.SIIPS_dotproduct_zscoreimages, sigtable.study)
title('NPS vs. SIIPS Values')
xlabel('NPS')
ylabel('SIIPS')
legend('Location','northeastoutside')

% RANKED
gscatter(rank_table.NPS_dotproduct_zscoreimages, rank_table.SIIPS_dotproduct_zscoreimages, rank_table.study)
title('NPS vs. SIIPS Ranks')
xlabel('NPS')
ylabel('SIIPS')
legend('Location','northeastoutside')

%% NPS by PAIN RATINGS
% VALUES
gscatter(sigtable.NPSpos_dotproduct_zscoreimages, sigtable.pain_scores, sigtable.study)
title('NPS vs. Pain Ratings Values')
xlabel('NPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')

% RANKED
gscatter(rank_table.NPS_dotproduct_zscoreimages, rank_table.pain_scores_zscorebystudy, rank_table.study)
title('NPS vs. Pain Ratings Ranks')
xlabel('NPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')


%% SIIPS by pain ratings
% VALUES
gscatter(sigtable.SIIPS_dotproduct_zscoreimages, sigtable.pain_scores, sigtable.study)
title('SIIPS vs. Pain Ratings Values')
xlabel('SIIPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')

% RANKED
gscatter(rank_table.SIIPS_dotproduct_zscoreimages, rank_table.pain_scores, rank_table.study)
title('SIIPS vs. Pain Ratings Ranks')
xlabel('SIIPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')


%% NPS by PINES

% VALUES
gscatter(sigtable.PINES_dotproduct_zscoreimages, sigtable.pain_scores, sigtable.study)
title('NPS vs. PINES Values')
xlabel('NPS')
ylabel('PINES')
legend('Location','northeastoutside')

% Ranks
gscatter(rank_table.NPS_dotproduct_zscoreimages, rank_table.PINES_dotproduct_zscoreimages, rank_table.study)
title('NPS vs. PINES Ranks')
xlabel('NPS')
ylabel('PINES')
legend('Location','northeastoutside')

%% NPS by VPS

% VALUES
gscatter(sigtable.NPS_dotproduct_zscoreimages, sigtable.VPS_dotproduct_zscoreimages, sigtable.study)
title('NPS vs. VPS Values')
xlabel('NPS')
ylabel('VPS')
legend('Location','northeastoutside')

% Ranks
gscatter(rank_table.NPS_dotproduct_zscoreimages, rank_table.VPS_dotproduct_zscoreimages, rank_table.study)
title('NPS vs. VPS Ranks')
xlabel('NPS')
ylabel('VPS')
legend('Location','northeastoutside')
