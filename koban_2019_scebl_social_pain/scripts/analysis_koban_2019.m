%% Load

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/koban_2019_scebl_social_pain';
datadir = fullfile(basedir, 'results');

cd(datadir)

load canlab_dataset_koban_2019_scebl_social_pain DAT

%% Analysis: Pain ratings 

colors = {[1 0 0] [1 .5 0] [0 1 0] [.5 1 0] [0 0 1] [0 .5 1]};

create_figure('barplot', 1, 2);

% Group averages: Conditions
% -------------------------------------------------------------------------
wh = [13 14 15 16 17 18 19 20];  % reorder to make sense on plot; these correspond to contrasts of interest
condnames = {'CLSL_4_8'
             'CLSH_4_8'
             'CLSL_4_9'
             'CLSH_4_9'
             'CHSL_4_9'
             'CHSH_4_9'
             'CHSL_5_0'
             'CHSH_5_0'};
         
% add 2 extra colors for this many conditions
% Add colors for plotting later
colors = colorcube_colors(length(DAT.Subj_Level.names));

bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
set(gca, 'XTickLabel', condnames);
ylabel('Pain ratings');
title('Pain Rating by Condition');

% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

% set contrast names and descriptions, then grab corresponding values,
% descriptions, and indices from DAT
connames = {'Social High > Low'
            'CS High > Low'};
cons =     {'contrast_ratings_sochilo'
            'contrast_ratings_cuehilo'}';
[convals, ~, ~, descrip, wh_indx] = get_var(DAT, cons);

% barplot_columns(convals, 'nofig', 'noviolin', 'colors', colors([1 3]));
bars(DAT, DAT.Subj_Level.names(wh_indx), 'colors', colors([1 3 5]), 'noviolin', 'nofig');

% clean up X axis and add title
set(gca, 'XTickLabel', connames); % gca is to get handle of current axis
ylabel('Pain ratings');
title('Contrast values');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing

fprintf('Percent response: %3.0f%%\n', 100*sum(convals > 0) ./ size(convals, 1));

%% Save Pain Ratings
% -------------------------------------------------------------------------
figdir = fullfile(basedir, 'figures');
if ~exist(figdir, 'dir'), mkdir(figdir); end

saveas(gcf, fullfile(figdir, 'ratings_bars_with_points.fig'));
saveas(gcf, fullfile(figdir, 'ratings_bars_with_points.png'));


%% Analysis: NPS response

create_figure('barplot', 1, 2);

% Group averages
% -------------------------------------------------------------------------
wh = [5 6 7 8];  % reorder to make sense on plot 
bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
ylabel('NPS Response');
title('NPS by Condition (49C Stimuli)');

% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

connames = {'CS-HighLow'
            'Soc-HighLow'};
cons =     {'Pain CShilo'
            'Pain Sochilo'}';
[convals, ~, ~, descrip, wh_indx] = get_var(DAT, cons);

%barplot_columns(convals, 'nofig', 'noviolin', 'colors', colors([1 3]));
bars(DAT, DAT.Subj_Level.names(wh_indx), 'colors', colors([1 2 3 8]), 'noviolin', 'nofig');

set(gca, 'XTickLabel', connames); %gca is get handle of current axis
ylabel('NPS Response'); 
title('NPS by Contrast');

pos = get(gcf, 'Position');
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow

fprintf('Percent response: %3.0f%%\n', 100*sum(convals > 0) ./ size(convals, 1));

%% Text output - for aggregation across studies
% -------------------------------------------------------------------------

disp(DAT.Description.Experiment_Name) % print paper data is from

sprintf('%s\n', descrip{:}) % print the contrast descriptions

print_matrix(convals, connames) %print out the contrast NPS values

%% Save
% -------------------------------------------------------------------------
figdir = fullfile(basedir, 'figures');
if ~exist(figdir, 'dir'), mkdir(figdir); end

saveas(gcf, fullfile(figdir, 'nps_bars_with_points.fig'));
saveas(gcf, fullfile(figdir, 'nps_bars_with_points.png'));