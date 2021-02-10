%% this script loads all contrasts and pain ratings of interest for each included dataset
% These Are
% atlas_remi_hot_drug
% atlas_exp_high_v_low
% ie2_high_vs_low_beh
% becker_reward_win_v_lose
% becker_pain_control_vs_uncontrol
% bmrk3_up_vs_neutral_rating
% roy_emomod_ratings_neg_vs_pos (need to flip values)
% lopezsola_handholding_HH_vs_BL
% kober_mindful_acc_hot_vs_rea_hot
% lopezsola_meaning_vs_no_meaning


datadir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results/';


%% load all pain ratings for each study
cd(datadir);
load('multistudy_ratings_02-Feb-2021.mat');

%% RESCALE by MAD (median abs. deviation) column-wise:
[n, k] = size(ms_ratings.ratings);
ms_ratings_all = ms_ratings.ratings ./ repmat(mad(ms_ratings.ratings), n, 1);

ms_ratings_tab = array2table(ms_ratings_all);
ms_ratings_tab.Properties.VariableNames = ms_ratings.names;

%% load corresponding brain contrasts from multistudy_contrasts
load('multistudy_contrasts_28-Jan-2021.mat');
braincons = [1 2 18 4 6 15 24 22 21 20 26]; % corresponding to the pain ratings list
ms_brain = multistudy_contrasts.data(braincons)
ms_brain_labels = multistudy_contrasts.contrast_names(braincons);
clear multistudy_contrasts;
%% calculate nps for each set of brain images
max = 36;
ms_nps = [];
ms_nps_all = [];
for i = 1:size(ms_brain,2)
    mydat = ms_brain(i);
    mynps = cell2mat(apply_nps(mydat));
    to_add = max - size(mynps,1);
    nan_to_add = nan(to_add,1);
    mynps = vertcat(mynps, nan_to_add);
    ms_nps_all = [ms_nps_all mynps];
end

%% RESCALE by MAD (median abs. deviation) column-wise:
[n, k] = size(ms_nps_all);
ms_nps_all = ms_nps_all ./ repmat(mad(ms_nps_all), n, 1);

% convert to table
ms_nps_tab = array2table(ms_nps_all);
ms_nps_tab.Properties.VariableNames = ms_brain_labels;


%% Save pain and brain out to visualize with R
% savefile = fullfile(datadir, strcat('tmp_pain_ratings_', date,'_.csv'));
% writetable(ms_ratings_tab, savefile);
% savefile= fullfile(datadir, strcat('tmp_nps_', date, '_.csv'));
% writetable(ms_nps_tab, savefile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin Plotting data. 
% Ratings are in: ms_ratings_all
% NPS vals are in: ms_nps_all

% check we have matching Ns for nps and ratings across studies
sum(~isnan(ms_ratings_all))
sum(~isnan(ms_nps_all))

%% Pain Ratings First
mydat = ms_ratings_all;
connames = ms_ratings_tab.Properties.VariableNames;
con2plot = {'Remifentanil', 'Expectation', 'Symbolic Cond.', 'Reward', 'Imagination', 'Emotion', 'Handholding', 'Mindfulness', 'Meaning'};

% Make all pain reductions negative
sign_switch = [1 2 3 5];
 
 for col=1:size(sign_switch,2)
     mydat(:,sign_switch(col)) = mydat(:,sign_switch(col)) * -1;
 end

% Sort by effect size
% ------------------------------------------------------------------------
d = nanmean(ms_ratings_all) ./ nanstd(ms_ratings_all)
[ds, wh] = sort(abs(d), 'ascend');
mydatpain = mydat(:, wh);
connames = connames(wh);
con2plot = con2plot(wh);

% how many significant?  For colors
% ------------------------------------------------------------------------
t = nanmean(mydat) ./ ste(mydat);
p = 2 * tcdf(abs(t), sum(~isnan(mydat)) - 1, 'upper'); % two-tailed

k2 = sum(p < .05);
[n, k] = size(mydat);

vnames = format_strings_for_legend(con2plot);

xvals = 1:k;
colors = repmat({[.5 .5 .7]}, 1, k - k2);        % non-significant 
colors = [colors custom_colors([.7 0 0], [1 .7 0], k2)']; % significant

create_figure('ratings')
[h1, s1] = barplot_columns(mydatpain,'x', xvals, 'colors', colors, 'nofig');
set(gca, 'XTickLabel', vnames);
ylabel('Avg Pain Rating');
xlabel('Study');
title('Avg Pain Ratings by Regulation Type');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow; %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing

%% NPS Values Second
mydat = ms_nps_all;
connames = ms_brain_labels;
%con2plot = {'Remifentanil', 'Expectation', 'Symbolic Cond.', 'Reward', 'Controllability', 'Imagination', 'Emotion','Handholding', 'Mindfulness','Social', 'Meaning'};
con2plot = {'Symbolic Cond.', 'Meaning', 'Social', 'Emotion', 'Controllability', 'Handholding', 'Expectation', 'Mindfulness', 'Remifentanil', 'Reward', 'Imagination'};

% Make imagination, social, and symbolic cues negative effects to match others
%sign_switch = [2 3 4 5 6 11];
sign_switch = [3 11 2 5 4 6];
 
 for col=1:size(sign_switch,2)
     mydat(:,sign_switch(col)) = mydat(:,sign_switch(col)) * -1;
 end

% Sort by effect size
% ------------------------------------------------------------------------
d = nanmean(mydat) ./ nanstd(mydat)
[ds, wh] = sort(abs(d), 'ascend');
mydat = mydat(:, wh);
connames = connames(wh);
con2plot = con2plot(wh);

% how many significant?  For colors
% ------------------------------------------------------------------------
t = nanmean(mydat) ./ ste(mydat);
p = 2 * tcdf(abs(t), sum(~isnan(mydat)) - 1, 'upper'); % two-tailed

k2 = sum(p < .05);
[n, k] = size(mydat);

vnames = format_strings_for_legend(con2plot);

xvals = 1:k;
colors = repmat({[.5 .5 .7]}, 1, k - k2);        % non-significant 
colors = [colors custom_colors([.7 0 0], [1 .7 0], k2)']; % significant

create_figure('nps')
[h1, s1] = barplot_columns(mydat,'x', xvals, 'colors', colors, 'nofig');
set(gca, 'XTickLabel', vnames);
ylabel('Avg NPS Value');
xlabel('Study');
title('Avg NPS Value by Regulation Type');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow;


%% scatterplot of brain by behavior
%grab pain ratings
mydat = ms_ratings_all;
connames = ms_ratings_tab.Properties.VariableNames;
mynames_pain = {'Remifentanil', 'Expectation', 'Symbolic Cond.', 'Reward', 'Imagination', 'Emotion', 'Handholding', 'Mindfulness', 'Meaning'};

% Make all pain reductions negative
sign_switch = [1 2 3 5];
 
 for col=1:size(sign_switch,2)
     mydat(:,sign_switch(col)) = mydat(:,sign_switch(col)) * -1;
 end

% average pain rating by study
mydatpain_avg = nanmean(mydat);


% grab nps responses
mydat = ms_nps_all;
connames = ms_brain_labels;
%con2plot = {'Remifentanil', 'Expectation', 'Symbolic Cond.', 'Reward', 'Controllability', 'Imagination', 'Emotion','Handholding', 'Mindfulness','Social', 'Meaning'};
con2plot = {'Symbolic Cond.', 'Meaning', 'Social', 'Emotion', 'Controllability', 'Handholding', 'Expectation', 'Mindfulness', 'Remifentanil', 'Reward', 'Imagination'};

sign_switch = [3 11 2 5 4 6];
 
 for col=1:size(sign_switch,2)
     mydat(:,sign_switch(col)) = mydat(:,sign_switch(col)) * -1;
 end

mydat_nps_scatter = mydat(:,[9 7 1 10 11 4 6 8 2]);
mynames_nps = con2plot([9 7 1 10 11 4 6 8 2]);
mydatnps_avg = nanmean(mydat_nps_scatter)

plot_correlation_samefig(mydatpain_avg, mydatnps_avg)

disp('Pain Contrasts: ')
mynames_pain'
disp('NPS Contrasts: ')
mynames_nps'





%% Save NPS Plot
% -------------------------------------------------------------------------
saveas(gcf, fullfile(figuresdir, 'multistudy_7_NPS_violin_with_points.fig'));
saveas(gcf, fullfile(figuresdir, 'multistudy_7_NPS_violin_with_points.png'));
