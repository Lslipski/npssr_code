%% Similarity Comparisons
% Created by: Luke Slipski 04/22/2021
% This code loads all nifti images (one per subject) for the NPSSR study.
% It then applies all canlab signatures to the (zscored) images
% (apply_all_signatures()), and loads signature scores into a table. It
% then loads and adds subjective pain ratings by participant to that
% matrix and saves it as all_contrast_all_signature_scores[date]. It then
% calculates and saves a ranked version of the same table.
% end are some exploratory plots to see if studies can be separated based
% on these signature scores.
%


datadir = '/Users/lukie/Documents/canlab/NPSSR/multistudy_contrasts';
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';

image_names = filenames(fullfile(datadir, '*img'), 'absolute');
data_obj = fmri_data(image_names);
zdat = zscore(data_obj.dat);

%% raw contrast obj
% t = ttest(data_obj);
% t= threshold(tdat, .05, 'fdr', 'k', 10); 
% 
% % calculate dissimilarity matrix
% D = corr(zdat);
% [n,k] = size(D);
% one = ones(n,k);
% dis = one - D;
% 
% % Code Snippet
% imagesc(dis); % Display correlation matrix as an image
% %set(gca, 'XTick', 1:n); % center x-axis ticks on bins
% %set(gca, 'YTick', 1:n); % center y-axis ticks on bins
% title('Contrast Dissimilarity', 'FontSize', 10); % set title
% colormap('jet'); % Choose jet or any other color scheme
% colorbar('EASTOUTSIDE'); % 

%% nps
% nps_obj = apply_nps(data_obj);
% nps_pdist = squareform(pdist(nps_obj{1}));
% [n,k] = size(nps_pdist);
% one = ones(n,k);
% dis = one - nps_pdist;
% imagesc(dis)
% 
% title('Contrast Dissimilarity', 'FontSize', 10); % set title
% colormap('jet'); % Choose jet or any other color scheme
% colorbar('EASTOUTSIDE');
% 
% [minval, minind] = mink(nps_obj{1}, 50);
% [maxval, maxind] = maxk(nps_obj{1}, 50);

% sort(image_names(minind))
% sort(image_names(maxind))

condnames = {};
for i = 1:size(image_names);
    [x,y] = fileparts(image_names{i});
    fname = eraseBetween(y,1,16);
    condnames{end+1} = fname;
end


[SIG, sigtable] = apply_all_signatures(data_obj, 'similarity_metric', 'dotproduct', 'image_scaling', 'zscoreimages', 'condition_names', condnames);

% load pain ratings and stack into matrix
load(fullfile(savedir,'multistudy_ratings_05-Apr-2021.mat'));
% flip signs of pain ratings where appropriate to make contrasts correct
% sign 
sign_switch = [1 2 3 5 8];
 
for col=1:size(sign_switch,2)
 ms_ratings.ratings(:,sign_switch(col)) = ms_ratings.ratings(:,sign_switch(col)) * -1;
end

rats = reshape(ms_ratings.ratings,[],1); % make into vector
rats = rats(~isnan(rats)); % remove nans padded into original table


% add pain ratings to signatures table
savetable = sigtable{1};
savetable.pain_scores = rats;


% add study labels to signatures table
savetable.study = condnames';

% save all signature scores, comment out because only save once
cd(savedir)
writetable(savetable, strcat('all_contrast_all_signature_scores_', date,'.csv'));
save(strcat('all_contrast_all_signature_scores_object_', date, '.mat'),'SIG');

ranked = [];
for i = 1:(size(savetable, 2) - 1) % ignore the study name variable for ranking
    thisdat = table2array(savetable(:,i));
    thisrank = rankdata(thisdat);
    ranked = [ranked thisrank];
end

rank_table = array2table(ranked); % make into table
rankvars = savetable.Properties.VariableNames;
rankvars= rankvars(1:size(savetable, 2) - 1); % get rid of study variable
rank_table.Properties.VariableNames = rankvars;
rank_table.study = savetable.study;

% save all RANKED signature scores, comment out because only save once
cd(savedir)
writetable(rank_table, strcat('all_ranked_contrast_all_signature_scores_', date,'.csv'));

%% Load Data for plots
sigtable = readtable('all_contrast_all_signature_scores_27-Apr-2021.csv');
rank_table = readtable('all_ranked_contrast_all_signature_scores_27-Apr-2021.csv');
load('all_contrast_all_signature_scores_object_27-Apr-2021.mat');
%zscore pain ratings if desired
%sigtable.pain_scores = zscore(sigtable.pain_scores);

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
gscatter(sigtable.NPS_dotproduct_zscoreimages, rank_table.pain_scores, sigtable.study)
title('NPS vs. Pain Ratings Values')
xlabel('NPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')

% RANKED
gscatter(rank_table.NPS_dotproduct_zscoreimages, rank_table.pain_scores, rank_table.study)
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
