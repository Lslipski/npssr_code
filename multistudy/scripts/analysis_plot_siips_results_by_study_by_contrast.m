% creates plots for each study by contrast for siips output.
% takes siips results that come from running
% create_multistudy_contrasts_dataframe.m and then
% multistudy_siips_calculation.m

data_dir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results';
save_dir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/multistudy/results/siips';
cd(data_dir);

% load siips results, specify most recent
load('multistudy_siips_results_20-Sep-2020.mat');

study_list = {'pain_reward'
    'bmrk3'
    'ie2'
    'mindful_acceptance'
    'handholding'
};

contrasts_list = {'pain_reward_Mod v Mild'
'pain_reward_Win v Lose'
'pain_reward_Intxn'
'bmrk3_imagine down'
'bmrk3_standard'
'bmrk3_imagine up'
'bmrk3_down vs standard'
'bmrk3_up vs standard'
'ie2_neut vs low'
'ie2_high vs neut'
'ie2_high vs low'
'ie2_hightemp vs lowtemp'
'mindful_acceptance_acc heat vs react heat'
'handholding vs baseline'
};


for i = 1:size(study_list,1)
   wh_contrasts = contains(contrasts_list, char(study_list(i)));
   wh_cols = [find(wh_contrasts == 1)];
   wh_data = [multistudy_siips_results.data(wh_cols)];
   datmat = [];
   for p = 1:size(wh_cols,1)
       datmat = [datmat cell2mat(wh_data(p))];
   end
   [n, k] = size(datmat);
   datmat = datmat ./ repmat(mad(datmat), n, 1);
   wh_contrast_names = multistudy_siips_results.contrast_names(wh_cols);
   
   
   % put data and names into canlab data object for plotting
    DAT = canlab_dataset();
    DAT.Subj_Level.data=datmat;
    DAT.Subj_Level.names = wh_contrast_names;
    
    % edit canlab data set attributes so it will play nicely with bars()
    DAT.Subj_Level.id = cell(1,n);
    DAT.Subj_Level.id(:) = {'image'};
    DAT.Subj_Level.type = cell(1,k);
    DAT.Subj_Level.type(:) = {'numeric'};
    DAT.Subj_Level.descrip = wh_contrast_names';
    
    
   
    % get canlab dataset vars set up for plot
    [dat, ~, ~, descrip, wh_indx] = get_var(DAT,DAT.Subj_Level.names(:));
    colors = {[1 0 0] [1 .5 0] [.2 0 0] [0 1 0] [.5 1 0] [0 .2 0] [0 0 1] [0 .5 1] [0 0 .2]};
    create_figure('barplot', 1,1);

    % Group averages
    % -------------------------------------------------------------------------
    %wh_indx = (1:size(wh_cols,1));
    bars(DAT, DAT.Subj_Level.names(wh_indx), 'colors', colors, 'noviolin', 'nofig');
    ylabel('SIIPS Response');
    title('SIIPS by Contrast');
    %subplot(1, 2);
    
    set(gca, 'XTickLabel', strrep(wh_contrast_names,'_',' ')); %gca is get handle of current axis
    ylabel('SIIPS Response'); 
    title('SIIPS Reponse by Contrast');

    pos = get(gcf, 'Position');
    if pos(3) ./ pos(4) < 2
        pos(3) = pos(3) .* 2.5;
    end
    set(gcf, 'Position', pos);

    drawnow, snapnow
    
    fprintf('Percent response: %3.0f%%\n', 100*sum(dat > 0) ./ size(dat, 1));

    %% Save
    % -------------------------------------------------------------------------
    figdir = fullfile(save_dir);

    saveas(gcf, fullfile(figdir, strcat('siips_response_', char(study_list(i)), '_', date,'.fig')));
    saveas(gcf, fullfile(figdir, strcat('siips_response_', char(study_list(i)), '_', date,'.png')));
   
    
end




