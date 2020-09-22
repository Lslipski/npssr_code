%% Load multistudy canlab dataset with signature and behavioral data of interest
resultsdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';
figuresdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/figures';
cd(resultsdir);
load('self_reg_combined.mat');

%% load siips data
load('multistudy_siips_results_20-Sep-2020.mat');
mysiips = multistudy_siips_results.data;
wh_siips = [2 8 10 13 14];
siips = [];
max_subjects = 36;
for i = 1:size(wh_siips,2)
    x = cell2mat(mysiips(:,wh_siips(i)));
    size_x = size(x,1);
    if size_x < max_subjects
       nan_to_add = NaN(max_subjects - size_x, 1);
       dat_to_add = cat(1, x, nan_to_add);
    end
    siips = [siips dat_to_add];
end

%switch sign on siips data for imagination and symbolic to match others
ss = [2 3];
for col=1:size(ss,2)
 siips(:,ss(col)) = siips(:,ss(col)) * -1;
end

 
% only keep studies of interest for right now (2020-09-22)
wh_keep = [3 4 5 6 7 8 11 12 13 14];

%put into mydat so we can reformat
mydat = DAT.Subj_Level.data(:,wh_keep);
[n, k] = size(mydat);
% Make imagination, social, and symbolic cues negative effects to match others
sign_switch = [3 4 5 6];
for col=1:size(sign_switch,2)
 mydat(:,sign_switch(col)) = mydat(:,sign_switch(col)) * -1;
end



% RESCALE by MAD (median abs. deviation) column-wise:
mydat = mydat ./ repmat(mad(mydat), n, 1);
[n, k] = size(siips);
siips = siips ./ repmat(mad(siips), n, 1); 





 
%% Get, reorder, and plot behavioral data
% -------------------------------------------------------------------------
connames = { 'Reward NPS'
             'Reward Beh'
             'Imagination NPS'
             'Imagination Beh'
             'Symbolic Cues NPS'
             'Symbolic Cues Beh'
             'Mindful Acc NPS'
             'Mindful Acc Beh'
             'Handholding NPS'
             'Handholding Beh'
             %'Reward SIIPS'
             %'Imagination SIIPS'
             %'Symbolic Cue SIIPS'
             %'Mindful Acc SIIPS'
             %'Handholding SIIPS'
             };
siips_names = {'Reward SIIPS'
             'Imagination SIIPS'
             'Symbolic Cue SIIPS'
             'Mindful Acc SIIPS'
             'Handholding SIIPS'
             };
         
 % Sort by effect size
% ------------------------------------------------------------------------
d = nanmean(mydat) ./ nanstd(mydat);
[ds, wh] = sort(abs(d), 'ascend');
mydat = mydat(:, wh);
connames = connames(wh);

%% Produce NPS Violin Plots
% get new behavioral indices only
nps_indices = find(contains(connames,'NPS'));
nps_dat = mydat(:,nps_indices);
nps_names = connames(nps_indices);
    

% how many significant?  For colors
% ------------------------------------------------------------------------
t = nanmean(nps_dat) ./ ste(nps_dat);
p = 2 * tcdf(abs(t), sum(~isnan(nps_dat)) - 1, 'upper'); % two-tailed

k2 = sum(p < .05);
[n, k] = size(nps_dat);

vnames = format_strings_for_legend(nps_names);

xvals = 1:k;
colors = repmat({[.5 .5 .7]}, 1, k - k2);        % non-significant 
colors = [colors custom_colors([.7 0 0], [1 .7 0], k2)']; % significant

create_figure('NPS Responses by Study')
[h1, s1] = barplot_columns(nps_dat,'x', xvals, 'colors', colors, 'nofig');
set(gca, 'XTickLabel', vnames);
ylabel('NPS Response');
xlabel('Study');
title('NPS Response by Study');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow; %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing

%% Save NPS Plot
% -------------------------------------------------------------------------
saveas(gcf, fullfile(figuresdir, 'multistudy_5_NPS_violin_with_points.fig'));
saveas(gcf, fullfile(figuresdir, 'multistudy_5_NPS_violin_with_points.png'));

%% Produce Behavioral Violin Plots
% get new behavioral names in same order as NPS plot
beh_names = []
for i = 1:size(nps_names,1)
    beh_names = [beh_names strrep(nps_names(i),'NPS', 'Beh')];
end
beh_names = beh_names'; % transpose to match connames dimensions

beh_indices = []
% get indicies based on order of names
for p = 1:size(beh_names,1)
    beh_indices = [beh_indices find(contains(connames,beh_names(p)))];
end 

% transpose to match mydata dimensions
beh_indices = beh_indices';
% get data based on indices
beh_dat = mydat(:,beh_indices);

% how many significant?  For colors
% ------------------------------------------------------------------------
t = nanmean(beh_dat) ./ ste(beh_dat);
p = 2 * tcdf(abs(t), sum(~isnan(beh_dat)) - 1, 'upper'); % two-tailed

k2 = sum(p < .05);
[n, k] = size(beh_dat);

vnames = format_strings_for_legend(beh_names);

xvals = 1:k;
colors = repmat({[.5 .5 .7]}, 1, k - k2);        % non-significant 
colors = [colors custom_colors([.7 0 0], [1 .7 0], k2)']; % significant

create_figure('Behavioral Pain Ratings')
[h1, s1] = barplot_columns(beh_dat,'x', xvals, 'colors', colors, 'nofig');
set(gca, 'XTickLabel', vnames);
ylabel('Pain ratings');
xlabel('Study');
title('Pain Rating by Study');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow; %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing

%% Save Pain Plot
% -------------------------------------------------------------------------
saveas(gcf, fullfile(figuresdir, 'multistudy_5_ratings_violin_with_points.fig'));
saveas(gcf, fullfile(figuresdir, 'multistudy_5_ratings_violin_with_points.png'));


%% Produce same plot for SIIPS
% reorder siips data to match beh effect size order
siips_indices = [1 2 5 3 4];
siips_dat = siips(:,siips_indices);
siips_names = siips_names(siips_indices);

% how many significant?  For colors
% ------------------------------------------------------------------------
t = nanmean(siips_dat) ./ ste(siips_dat);
p = 2 * tcdf(abs(t), sum(~isnan(siips_dat)) - 1, 'upper'); % two-tailed

k2 = sum(p < .05);
[n, k] = size(siips_dat);

vnames = format_strings_for_legend(siips_names);

xvals = 1:k;
colors = repmat({[.5 .5 .7]}, 1, k - k2);        % non-significant 
colors = [colors custom_colors([.7 0 0], [1 .7 0], k2)']; % significant

create_figure('SIIPS Responses by Study')
[h1, s1] = barplot_columns(siips_dat,'x', xvals, 'colors', colors, 'nofig');
set(gca, 'XTickLabel', vnames);
ylabel('SIIPS Response');
xlabel('Study');
title('SIIPS Response by Study');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow; %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing
%% Save NPS Plot
% -------------------------------------------------------------------------
saveas(gcf, fullfile(figuresdir, 'multistudy_5_SIIPS_violin_with_points.fig'));
saveas(gcf, fullfile(figuresdir, 'multistudy_5_SIIPS_violin_with_points.png'));



