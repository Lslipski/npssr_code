%% Set up paths and load data
a_set_up_paths_always_run_first;

cd(resultsdir)

load canlab_dataset_jepma_2018_ie2.mat DAT

load('jepma_2018_ie2_behavioral_ratings.mat');

%% average pain ratings per condition and insert into table
t = []
for p = 1:34
    cue_vals = med_vars.X_Cue{p};
    cue_data = cue_vals == 1; 
    high_ratings = med_vars.Y_PainRating{p} .* cue_data;
    cue_data = cue_vals == 0; 
    neutral_ratings = med_vars.Y_PainRating{p} .* cue_data;
    cue_data = cue_vals == -1; 
    low_ratings = med_vars.Y_PainRating{p} .* cue_data;
        
    % get temperature 48/49 behavioral ratings
    temp_vals = med_vars.covs_TempRep4x{p}(:,1);
    cue_data = temp_vals > 0.0; 
    hot_ratings = med_vars.Y_PainRating{p} .* cue_data;
    cue_data = temp_vals < 0.0; 
    cool_ratings = med_vars.Y_PainRating{p} .* cue_data;
    
    % take mean of ratings for each condition
    sub_ratings = [nanmean(nonzeros(high_ratings)) nanmean(nonzeros(neutral_ratings)) nanmean(nonzeros(low_ratings)) nanmean(nonzeros(hot_ratings)) nanmean(nonzeros(cool_ratings))];

    % add to table
    if p == 1
        ratings_table = array2table(sub_ratings,'VariableNames',{'high_cue_ratings' 'neutral_cue_ratings' 'low_cue_ratings' 'hot_ratings' 'warm_ratings'});
    else
        ratings_table = [ratings_table; array2table(sub_ratings,'VariableNames',{'high_cue_ratings' 'neutral_cue_ratings' 'low_cue_ratings' 'hot_ratings' 'warm_ratings'})];
    end



end

varfun(@mean, ratings_table, 'InputVariables', {'high_cue_ratings', 'neutral_cue_ratings', 'low_cue_ratings', 'hot_ratings', 'warm_ratings'})

%% Add pain ratings to new canlab data object
% label to distinguish behavioral ratings from nps values
ratings_descrip = {'Behavioral Rating High Cue'
                   'Behavioral Rating Neutral Cue'
                   'Behavioral Rating Low Cue'
                   'Behavioral Rating High Temp'
                   'Behavioral Rating Low Temp'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; ratings_descrip];

% add descriptions for each behavioral condition
ratings_names = {'Beh_hcue'
                 'Beh_ncue'
                 'Beh_lcue'
                 'Beh_htemp'
                 'Beh_ltemp'};
DAT.Subj_Level.names = [DAT.Subj_Level.names; ratings_names];

% add raw ratings data to Subject level data 
DAT.Subj_Level.data = [DAT.Subj_Level.data table2array(ratings_table(:,:))];

%% add contrasts for pain ratings

% array is prime(') to fit the size of the subj_level data (matrix algebra
% will require this to apply contrasts to data)
C = [0 1 -1 0 0;
     1 -1 0 0 0;
     1 0 -1 0 0;
     0 0 0 1 -1;]';
condescrips = {'Behavioral contrast neutral cue vs low cue'
            'Behavioral contrast high cue vs neutral cue'
            'Behavioral contrast high cue vs low cue'
            'Behavioral contrast high temp vs low temp'};
connames = {'neut_vs_low_beh'
            'high_vs_neut_beh'
            'high_vs_low_beh'
            'highT_vs_lowT_beh'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; condescrips];
DAT.Subj_Level.names = [DAT.Subj_Level.names; connames];

mydat = get_var(DAT, DAT.Subj_Level.names(7:11)); % get subject level data for each of the behavioral conditions
convals = mydat * C; % multiply the data by the contrasts to get behavioral values for each subject for each contrast

%concatenate new contrast values to data field
DAT.Subj_Level.data = [DAT.Subj_Level.data convals];

% Add variable types
k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% List variable names
get_var(DAT);

% save csv files of data
write_text(DAT)

% SAVE

save canlab_dataset_jepma_2018_ie2 DAT


