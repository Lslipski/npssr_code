%% Load multistudy canlab dataset with signature and behavioral data of interest
resultsdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';
figuresdir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/figures';
cd(resultsdir);
load('self_reg_combined.mat');

%put into mydat so we can reformat
[n, k] = size(mydat);
mydat = DAT.Subj_Level.data;



%% RESCALE by MAD (median abs. deviation) column-wise:
mydat = mydat ./ repmat(mad(mydat), n, 1);

%% Make imagination, social, and symbolic cues negative effects to match others
 sign_switch = [5 6 7 8 9 10];
 
 for col=1:size(sign_switch,2)
     mydat(:,sign_switch(col)) = mydat(:,sign_switch(col)) * -1;
 end


%% Produce Behavioral Violin Plots

% Get, reorder, and plot behavioral data
% -------------------------------------------------------------------------
connames = {'Remifentanil NPS'
             'Remifentanil Beh'
             'Reward NPS'
             'Reward Beh'
             'Imagination NPS'
             'Imagination Beh'
             'Symbolic Cues NPS'
             'Symbolic Cues Beh'
             'Social Cue NPS'
             'Social Cue Beh'
             'Minduful Acc NPS'
             'Mindful Acc Beh'
             'Handholding NPS'
             'Handholding Beh'
             };
         
 % Sort by effect size
% ------------------------------------------------------------------------
d = nanmean(mydat) ./ nanstd(mydat);
[ds, wh] = sort(abs(d), 'ascend');
mydat = mydat(:, wh);
connames = connames(wh);

         
% get new behavioral indices only
beh_indices = find(contains(connames,'Beh'));
beh_dat = mydat(:,beh_indices);
beh_names = connames(beh_indices);
    

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
title('Pain Rating by Study');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow; %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing

%% Save Pain Plot
% -------------------------------------------------------------------------
saveas(gcf, fullfile(figuresdir, 'ratings_violin_with_points.fig'));


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
title('NPS Response by Study');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow; %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing




















%% Produce ranked dataset
ds = load('self_reg_combined.mat');
[r,c] = size(ds.DAT.Subj_Level.data);

% get only non NaN values and rank them
for i = 1:c
    real_indicies = (~isnan(ds.DAT.Subj_Level.data(:,i)));
    mydat = ds.DAT.Subj_Level.data(real_indicies,i);
    myrankdat = rankdata(mydat);
    nan_to_add = NaN(r - size(mydat,1), 1);
    myrankdat = cat(1, myrankdat, nan_to_add);
    ds.DAT.Subj_Level.data(:,i) = myrankdat;
end

% get spearman correlations for NPS + pain ratings pairs
for col = 1:2:size(ds.DAT.Subj_Level.data,2)
    subdata = ds.DAT.Subj_Level.data(:,col:col+1)
end


