%% Set up paths and load data

basedir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/2016_Becker_painreward_copes';
datadir = fullfile(basedir, 'data');

cd(datadir)

load canlab_dataset_becker DAT

load rating_data.mat

%% add ratings data

% label to distinguish behavioral ratings from nps values
for i = 1:numel(descript)
    descript{i} = ['Rating:' descript{i}];
end

% add behavioral var names to the dataset list of names
DAT.Subj_Level.names = [DAT.Subj_Level.names descript];
%     'Rating:LOSEMILD'
%     'Rating:LOSEMOD'
%     'Rating:NEUTMILD'
%     'Rating:NEUTMOD'
%     'Rating:WINMILD'
%     'Rating:WINMOD'

% add descriptions for each behavioral condition
DAT.Subj_Level.descrip = [DAT.Subj_Level.descrip; descript'];

% add ratings data to Subject level data only if the subject is in the
% canlab data object already
DAT.Subj_Level.data = [DAT.Subj_Level.data ratings(ismember(subj, cellfun(@str2num, DAT.Subj_Level.id)),:)];
% behavioral data will be at indices 14:19 once concatenated (used below)

%% add contrasts (same with NPS)

% array is prime(') to fit the size of the subj_level data (matrix algebra
% will require this to apply contrasts to data)
C = [-.333 .333 -.333 .333 -.333 .333;
    -.5 -.5 0 0 .5 .5;
    .25 .25 -.5 -.5 .25 .25]';
connames = {'Rating:Hot - Mild' 'Rating:HotMild Win-Loss' 'Rating:HotMild WinLoss - NoRew'};

wh = 14:19; % for indices of conditions
mydat = get_var(DAT, DAT.Subj_Level.names(wh)); % get subject level data for each of the behavioral conditions
convals = mydat * C; % multiply the data by the contrasts to get behavioral values for each subject for each contrast

% concatenate new contrast values and names to the data object
DAT.Subj_Level.data = [DAT.Subj_Level.data convals];
DAT.Subj_Level.names = [DAT.Subj_Level.names connames];

% add contrast descriptions for each behavioral contrast
DAT.Subj_Level.descrip(end+1) = {'Rating Hot - Mild within-person contrast'};
DAT.Subj_Level.descrip(end+1) = {'Rating Hot + Mild Reward gain - Loss within-person contrast'};  
DAT.Subj_Level.descrip(end+1) = {'Rating Hot + Mild Reward or loss - No reward within-person contrast'};

% Add variable types

k = length(DAT.Subj_Level.names); % get subject level name length
DAT.Subj_Level.type = repmat({'numeric'}, 1, k); % get variable types


%% List variable names
get_var(DAT);

% save csv files of data
write_text(DAT)

% SAVE

save canlab_dataset_becker DAT


