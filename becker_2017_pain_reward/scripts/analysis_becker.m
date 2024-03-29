%% Load

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/becker_2017_pain_reward/';
datadir = fullfile(basedir, 'results');

cd(datadir)

load canlab_dataset_becker_2017_pain_reward DAT

%% Analysis: Pain ratings 

colors = colorcube_colors(length(DAT.Subj_Level.names));
create_figure('barplot', 1, 2);

% Group averages
% -------------------------------------------------------------------------
wh = [14 15 16 17 18 19];  % reorder to make sense on plot; these conditions
bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
ylabel('Pain ratings');
title('Condition Values');
condnames={'MILD_L'
           'MOD_L'
           'MILD_N'
           'MOD_N'
           'MILD_W'
           'MOD_W'}

set(gca, 'XTickLabel', condnames);

% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

% set contrast names and descriptions, then grab corresponding values,
% descriptions, and indices from DAT
connames = {'Hot - Mild' 'Win-Loss' 'Intxn'};
cons =     {'Rating:Hot - Mild'
            'Rating:HotMild Win-Loss'
            'Rating:HotMild WinLoss - NoRew'}';
[convals, ~, ~, descrip, wh_indx] = get_var(DAT, cons);

% barplot_columns(convals, 'nofig', 'noviolin', 'colors', colors([1 3]));
bars(DAT, DAT.Subj_Level.names(wh_indx), 'colors', colors([1 3 5]), 'noviolin', 'nofig');

% clean up X axis and add title
set(gca, 'XTickLabel', connames); % gca is to get handle of current axis
ylabel('Pain ratings');
xlabel('Contrast');
title('Contrast values');

pos = get(gcf, 'Position'); % get gcf gets the position of the current figure
if pos(3) ./ pos(4) < 2
    pos(3) = pos(3) .* 2.5;
end
set(gcf, 'Position', pos);

drawnow, snapnow %drawnow updates figures with new gcf; snapnow takes a snapshot for publishing

fprintf('Percent response: %3.0f%%\n', 100*sum(convals > 0) ./ size(convals, 1));

%% Save
% -------------------------------------------------------------------------
figdir = fullfile(basedir, 'figures');
if ~exist(figdir, 'dir'), mkdir(figdir); end

saveas(gcf, fullfile(figdir, 'ratings_bars_with_points.fig'));
saveas(gcf, fullfile(figdir, 'ratings_bars_with_points.png'));


%% Analysis: NPS response

create_figure('barplot', 1, 2);

% Group averages
% -------------------------------------------------------------------------
wh = [1 2 4 5 7 8];  % reorder to make sense on plot 
bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
ylabel('NPS Response');
title('Condition Values');
condnames={'MILD_L'
           'MOD_L'
           'MILD_N'
           'MOD_N'
           'MILD_W'
           'MOD_W'}

set(gca, 'XTickLabel', condnames);

% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

connames = {'Hot - Mild' 'Win-Loss' 'Intxn'};
cons =     {'Hot - Mild'
            'HotMild Win-Loss'
            'HotMild WinLoss - NoRew'}';
[convals, ~, ~, descrip, wh_indx] = get_var(DAT, cons);

%barplot_columns(convals, 'nofig', 'noviolin', 'colors', colors([1 3]));
bars(DAT, DAT.Subj_Level.names(wh_indx), 'colors', colors([1 2 3 8]), 'noviolin', 'nofig');

set(gca, 'XTickLabel', connames); %gca is get handle of current axis
ylabel('NPS Response'); 
xlabel('Contrast');
title('Contrast values');

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