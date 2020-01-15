basedir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/2016_Yina_Ma_Han_citalopram_pain';

datadir = fullfile(basedir, 'data');
cd(datadir)

wcards = {'Pain_Sub*AP_001.img' ...
    'Pain_Sub*ANP_001.img' ...
    'Pain_Sub*EP_001.img' ...
    'Pain_Sub*ENP_001.img' ...
    'Pain_Sub*AP_002.img' ...
    'Pain_Sub*ANP_002.img' ...
    'Pain_Sub*EP_002.img' ...
    'Pain_Sub*ENP_002.img' ...
    'Pain_Sub*AP_003.img' ...
    'Pain_Sub*ANP_003.img' ...
    'Pain_Sub*EP_003.img' ...
    'Pain_Sub*ENP_003.img'};

names = {'Pain Antic Run 1' ...
    'NoPain Antic Run 1' ...
    'Pain Run 1' ...
    'NoPain Run 1' ...
    'Pain Antic Run 2' ...
    'NoPain Antic Run 2' ...
    'Pain Run 2' ...
    'NoPain Run 2' ...
    'Pain Antic Run 3' ...
    'NoPain Antic Run 3' ...
    'Pain Run 3' ...
    'NoPain Run 3'};

diaryfile = fullfile(basedir, 'output_data', 'nps_values.txt');

diary(diaryfile);

[nps_values, image_names, data_objects] = apply_nps(wcards, 'noverbose');

diary off
%% save
cd(basedir)

mkdir output_data
cd output_data

save nps_values nps_values image_names wcards names

%% Figure 1

shortnames = {'Pain Ant' ...
    'NoPain Ant' ...
    'Pain ' ...
    'NoPain ' ...
    'Pain Ant' ...
    'NoPain Ant' ...
    'Pain ' ...
    'NoPain ' ...
    'Pain Ant' ...
    'NoPain Ant' ...
    'Pain ' ...
    'NoPain '};


wh_conds = {[1:4] [5:8] [9:12]};
titles = {'Run 1' 'Run 2' 'Run 3'};

k = length(wh_conds);
clear h1 s1

create_figure('NPS values', 1, k);

for i = 1:k
    axh(i) = subplot(1, k, i);
    set(gca, 'FontSize', 20)
    
    dat = cat(2, nps_values{wh_conds{i}});
    
    % error bars are between subject
    [h1{i}, s1{i}] = barplot_colored(dat, 'title', titles{i}, 'XTickLabels', shortnames(wh_conds{i}));
    
    ylabel('NPS response values');
end

equalize_axes(axh, 1)
scn_export_papersetup(500)

saveas(gcf, fullfile(basedir, 'figures', 'nps_values_fig1.png'));

%% Figure 2

% Correlation in pain responses across runs
wh_conds = {[3 7 11]};

dat = cat(2, nps_values{wh_conds{1}});

create_figure('NPS during pain reliability')
plotmatrix(dat);
scn_export_papersetup(500)
saveas(gcf, fullfile(basedir, 'figures', 'nps_reliability_fig2.png'));

%% Figure 3

% Correlation in pain - no-pain responses across runs
wh_conds = {[3 7 11] [4 8 12]};

dat1 = cat(2, nps_values{wh_conds{1}});
dat2 = cat(2, nps_values{wh_conds{2}});

dat = dat1 - dat2;  % Pain - no pain difference scores

create_figure('NPS  pain-nopain reliability')
plotmatrix(dat);
scn_export_papersetup(500)
saveas(gcf, fullfile(basedir, 'figures', 'nps_reliability_pain-nopain_fig3.png'));
