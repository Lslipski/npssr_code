%% Set up paths and load data

basedir = '/Users/lukie/Documents/canlab/NPSSR/npssr_code/bmrk3/'
rawdir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3';
datadir = fullfile(basedir, 'results');

cd(datadir)

load canlab_dataset_bmrk3 DAT

bmrk3 = load(fullfile(rawdir, 'BMRK3_dataset_fmri.mat'));

%% Get pain ratings from bmrk3 data object
% aggregate arrays of averaged subject pain ratings per condition
agg_down_reg = [];
agg_standard = [];
agg_up_reg = [];

for i=1:33 % loop through each participant
    
    rate = bmrk3.D.Event_Level.data{i}(:,11); %get pain ratings
    regulate = bmrk3.D.Event_Level.data{i}(:,12); %get trial manipulation
    
    reg_down = [];
    reg_up = [];
    standard = [];
    for q=1:194
       if regulate(q) < 0
           reg_down = [reg_down rate(q)];
       elseif regulate(q) > 0
           reg_up = [reg_up rate(q)];
       else
           standard = [standard rate(q)];
       end
    
    end
    
    % take mean of subject's ratings and add to aggregates
    agg_down_reg = [agg_down_reg mean(reg_down)];
    agg_standard = [agg_standard mean(standard)];
    agg_up_reg = [agg_up_reg mean(reg_up)];
    
    % clear subject-specific loop vars
    clear reg_down reg_up standard;
end


%% Add pain ratings to new canlab data object
% label to distinguish behavioral ratings from nps values
ratings_descrip = {'IMAGINE_DOWN: Pain ratings for imagine down'
                   'STANDARD: Pain ratings for standard'
                   'IMAGINE_UP: Pain ratings for Imagine Up'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; ratings_descrip];

% add descriptions for each behavioral condition
ratings_names = {'imagine_down_rating'
                 'standard_rating'
                 'imagine_up_rating'
                 'down_vs_neutral_rating'
                 'up_vs_neutral_rating'};
DAT.Subj_Level.names = [DAT.Subj_Level.names, ratings_names'];

% add raw ratings data to Subject level data 
DAT.Subj_Level.data = [DAT.Subj_Level.data, agg_down_reg' agg_standard' agg_up_reg'];
% behavioral data will be at indices 14:19 once concatenated (used below)

%% add contrasts (same with NPS)

% array is prime(') to fit the size of the subj_level data (matrix algebra
% will require this to apply contrasts to data)
C = [1 -1 0;
    0 -1 1;]';
connames = {'Rating:Down vs Standard' 'Rating:Up vs Standard'};
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; connames'];

wh = 6:8; % for indices of conditions
mydat = get_var(DAT, DAT.Subj_Level.names(wh)); % get subject level data for each of the behavioral conditions
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

save canlab_dataset_bmrk3 DAT


