%% Load

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/kober_2019_mindful_acceptance_mrp';
datadir = fullfile(basedir, 'results');

cd(datadir)

load canlab_dataset_kober_2019_mindful_acceptance_mrp DAT

%% Analysis: Pain ratings 

create_figure('barplot', 1, 2);

% nicer names to appear on plot
cond_names={'acc_n_e_u'
            'acc_n_e_g'
            'acc_w_a_r_m'
            'acc_h_o_t'
            'rea_n_e_u'
            'rea_n_e_g'
            'rea_w_a_r_m'
            'rea_h_o_t'}
        
% get colors for # of conditions
colors = colorcube_colors(length(cond_names));


% Group averages: Conditions
% -------------------------------------------------------------------------
wh = 11:18;  % reorder to make sense on plot; these correspond to contrasts of interest
bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
set(gca, 'XTickLabel', cond_names); % gca is to get handle of current axis
ylabel('Pain ratings');
title('Condition Values');

% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

% set contrast names and descriptions, then grab corresponding values,
% descriptions, and indices from DAT
connames = {'Accept Hot vs. React Hot'};
cons =     {'con_beh_acc_hot_vs_rea_hot'}';
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
wh = [2 1 4 3 7 6 9 8];  % reorder to make sense on plot; careful, nps not same order as ratings
bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
set(gca, 'XTickLabel', cond_names); % gca is to get handle of current axis

ylabel('NPS Response');
title('NPS by Condition');

% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

connames = {'Accept Hot vs. React Hot'};
cons =     {'con acc heat vs react heat'}';
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