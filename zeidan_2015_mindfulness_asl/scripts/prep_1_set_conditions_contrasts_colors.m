%% Set up conditions 
% ------------------------------------------------------------------------

% conditions = {'C1' 'C2' 'C3' 'etc'};
% structural_wildcard = {'c1*nii' 'c2*nii' 'c3*nii' 'etc*nii'};
% functional_wildcard = {'fc1*nii' 'fc2*nii' 'fc3*nii' 'etc*nii'};
% colors = {'color1' 'color2' 'color3' etc}  One per condition

fprintf('Image data should be in /data folder\n');

DAT = struct();

% Names of subfolders in /data
DAT.subfolders = {'controls/MR2*/stats/'  'controls/MR2*/stats/' ...
    'placebo_cream/MR2*/stats/'  'placebo_cream/MR2*/stats/' ...
    'sham_mindfulness/MR2*/stats/'  'sham_mindfulness/MR2*/stats/' ...
    'mindfulness_meditation/MR2*/stats/'  'mindfulness_meditation/MR2*/stats/' ...
    };

% Names of conditions
DAT.conditions = {'BookPost' 'BookPre' 'PlacPost' 'PlacPre' 'ShamPost' 'ShamPre' 'MindPost' 'MindPre'};

DAT.conditions = format_strings_for_legend(DAT.conditions);

DAT.structural_wildcard = {};
DAT.functional_wildcard = {'pe1.nii' 'pe2.nii' ...
    'pe1.nii' 'pe2.nii' ...
    'pe1.nii' 'pe2.nii' ...
    'pe1.nii' 'pe2.nii' ...
    };

% Set Contrasts
% ------------------------------------------------------------------------

% Vectors across conditions
DAT.contrasts = [1 -1 0 0 0 0 0 0; 0 0 1 -1 0 0 0 0; 0 0 0 0 1 -1 0 0; 0 0 0 0 0 0 1 -1];
    
DAT.contrastnames = {'Control_Post-Pre' 'Placebo_Post-Pre' 'Sham_Post-Pre' 'Mindfulness_Post-Pre'};

DAT.contrastnames = format_strings_for_legend(DAT.contrastnames);


% Set Colors
% ------------------------------------------------------------------------

% Default colors: Use Matlab's default colormap
% Other options: custom_colors, seaborn_colors, bucknerlab_colors

DAT.colors = custom_colors([.8 .7 .2], [.5 .2 .8], length(DAT.conditions));

DAT.contrastcolors = {[.2 .2 .8] [.2 .8 .2] [.2 .5 .8] [.8 .2 .2]};

% colors = colormap; % default list of n x 3 color vector
% colors = mat2cell(colors, ones(size(colors, 1), 1), 3)';
% DAT.colors = colors;
% clear colors
%close

disp('SET up conditions, colors, contrasts in DAT structure.');



