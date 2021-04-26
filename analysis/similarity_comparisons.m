%% Similarity Comparisons
% Created by: Luke Slipski 04/22/2021
% This code loads all nifti images (one per subject) for the NPSSR study.
% It then applies all canlab signatures to the images
% (apply_all_signatures()), and loads signature scores into a table. It
% then loads and adds subjective pain ratings by participant to that
% matrix and saves it as all_contrast_all_signature_scores[date]. At the
% end are some exploratory plots to see if studies can be separated based
% on these signature scores.
%


datadir = '/Users/lukie/Documents/canlab/NPSSR/multistudy_contrasts';
savedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';

image_names = filenames(fullfile(datadir, '*img'), 'absolute');
data_obj = fmri_data(image_names);
zdat = zscore(data_obj.dat);

%% raw contrast obj
t = ttest(data_obj);
t= threshold(tdat, .05, 'fdr', 'k', 10); 

% calculate dissimilarity matrix
D = corr(zdat);
[n,k] = size(D);
one = ones(n,k);
dis = one - D;

% Code Snippet
imagesc(dis); % Display correlation matrix as an image
%set(gca, 'XTick', 1:n); % center x-axis ticks on bins
%set(gca, 'YTick', 1:n); % center y-axis ticks on bins
title('Contrast Dissimilarity', 'FontSize', 10); % set title
colormap('jet'); % Choose jet or any other color scheme
colorbar('EASTOUTSIDE'); % 

%% nps
nps_obj = apply_nps(data_obj);
nps_pdist = squareform(pdist(nps_obj{1}));
[n,k] = size(nps_pdist);
one = ones(n,k);
dis = one - nps_pdist;
imagesc(dis)

title('Contrast Dissimilarity', 'FontSize', 10); % set title
colormap('jet'); % Choose jet or any other color scheme
colorbar('EASTOUTSIDE');

[minval, minind] = mink(nps_obj{1}, 50);
[maxval, maxind] = maxk(nps_obj{1}, 50);

sort(image_names(minind))
sort(image_names(maxind))

condnames = {};
for i = 1:size(image_names);
    [x,y] = fileparts(image_names{i});
    fname = eraseBetween(y,1,16);
    condnames{end+1} = fname;
end


[SIG, sigtable] = apply_all_signatures(data_obj, 'similarity_metric', 'dotproduct', 'image_scaling', 'zscoreimages', 'condition_names', condnames);

% load pain ratings and stack into matrix
load(fullfile(savedir,'multistudy_ratings_05-Apr-2021.mat'));
rats = reshape(ms_ratings.ratings,[],1);
rats = rats(~isnan(rats));

% add pain ratings to signatures table
savetable = sigtable{1};
savetable.pain_scores = rats;

% add study labels to signatures table
savetable.study = condnames';

% save all signature scores, comment out because only save once
%cd(savedir)
%writetable(savetable, strcat('all_contrast_all_signature_scores_', date,'_.csv'));


%% Scatter plots with points colored by study
% NPS by SIIPS
gscatter(sigtable{1}.NPS_dotproduct_zscoreimages, sigtable{1}.SIIPS_dotproduct_zscoreimages, SIG.conditionnames')
xlabel('NPS')
ylabel('SIIPS')
legend('Location','northeastoutside')


% NPS by pain ratings
gscatter(sigtable{1}.NPS_dotproduct_zscoreimages, rats, SIG.conditionnames')
xlabel('NPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')

% SIIPS by pain ratings
gscatter(sigtable{1}.SIIPS_dotproduct_zscoreimages, rats, SIG.conditionnames')
xlabel('SIIPS')
ylabel('Pain Rating')
legend('Location','northeastoutside')





