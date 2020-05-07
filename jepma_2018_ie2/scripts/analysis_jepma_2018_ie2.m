%% Load
a_set_up_paths_always_run_first

cd(resultsdir)

load canlab_dataset_jepma_2018_ie2.mat DAT

%% Analysis: Pain ratings 
create_figure('barplot', 1, 2);

% Group averages: Conditions
% -------------------------------------------------------------------------
wh = [10 11 12 13 14];  % reorder to make sense on plot; these correspond to contrasts of interest
condnames = {'H_c_u_e'
             'N_c_u_e'
             'L_c_u_e'
             'H_t_e_m_p'
             'L_t_e_m_p'};
         
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
connames = {'Neut > Low'
            'High > Neut'
            'High > Low'
            'HighT > LowT'};
cons =     {'neut_vs_low_beh'
            'high_vs_neut_beh'
            'high_vs_low_beh'
            'highT_vs_lowT_beh'};
        
[convals, ~, ~, descrip, wh_indx] = get_var(DAT, cons);

% barplot_columns(convals, 'nofig', 'noviolin', 'colors', colors([1 3]));
bars(DAT, DAT.Subj_Level.names(wh_indx), 'colors', colors, 'noviolin', 'nofig');

% clean up X axis and add title
set(gca, 'XTickLabel', connames); % gca is to get handle of current axis
ylabel('Pain ratings');
title('Pain Rating by Contrast');

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
wh = [3 2 1 5 4];  % reorder to make sense on plot 
condnames = {'H_c_u_e'
             'N_c_u_e'
             'L_c_u_e'
             'H_t_e_m_p'
             'L_t_e_m_p'};
bars(DAT, DAT.Subj_Level.names(wh), 'colors', colors, 'noviolin', 'nofig');
set(gca, 'XTickLabel', condnames);

ylabel('NPS Response');
title('NPS by Condition');


% Contrasts
% -------------------------------------------------------------------------
subplot(1, 2, 2);

connames = {'Neut > Low'
            'High > Neut'
            'High > Low'
            'HighT > LowT'};
cons =     {'neut_vs_low'
            'high_vs_neut'
            'high_vs_low'
            'hightemp_vs_lowtemp'};
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