
%% imagine down condition
% load imagine down dataset, extract subject names, clean up 
% import data object
x = load('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3/imaginedown/data_obj.mat');

% get paths out of data object
path_set = {33};
for i=1:33
    path_set{i} = char({x.imgs(i:33:3267)});
end

% get only subjid and onward for filenames
subs = {33};
for i = 1:33
    subs{i} = char(path_set{i}(50:55));
end

% replace forward slash with underscore, periods with empty and add prefix
% and suffix
for i = 1:33
    subs{i} = strcat('imagine_down_', strrep(subs{i},'/','_'));
    subs{i} = char(strrep(subs{i}, '.',''));
    subs{i} = strcat(subs{i},'.img');
end

x.dat.image_names = subs;
x.dat.fullpath = {33};
for i = 1:33
    x.dat.fullpath{i} = char(strcat('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3/imagine_down/',subs{i}));
end

imaginedown = x;
disp('imaginedown data object created');
clear x;
clear i;
clear subs;
clear path_set;


%% Standard Condition

x = load('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3/standard/data_obj.mat');

% get paths out of data object
path_set = {33};
for i=1:33
    path_set{i} = char({x.imgs(i:33:3267)});
end

% get only subjid and onward for filenames
subs = {33};
for i = 1:33
    subs{i} = char(path_set{i}(50:55));
end

% replace forward slash with underscore, periods with empty and add prefix
% and suffix
for i = 1:33
    subs{i} = strcat('imagine_down_', strrep(subs{i},'/','_'));
    subs{i} = char(strrep(subs{i}, '.',''));
    subs{i} = strcat(subs{i},'.img');
end

x.dat.image_names = subs;
x.dat.fullpath = {33};
for i = 1:33
    x.dat.fullpath{i} = char(strcat('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3/standard/',subs{i}));
end

standard = x;
disp('standard data object created');
clear x;
clear i;
clear subs;
clear path_set;

%% Imagine Up Condition
x = load('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3/imagineup/data_obj.mat');

% get paths out of data object
path_set = {33};
for i=1:33
    path_set{i} = char({x.imgs(i:33:3267)});
end

% get only subjid and onward for filenames
subs = {33};
for i = 1:33
    subs{i} = char(path_set{i}(50:55));
end

% replace forward slash with underscore, periods with empty and add prefix
% and suffix
for i = 1:33
    subs{i} = strcat('imagine_down_', strrep(subs{i},'/','_'));
    subs{i} = char(strrep(subs{i}, '.',''));
    subs{i} = strcat(subs{i},'.img');
end

x.dat.image_names = subs;
x.dat.fullpath = {33};
for i = 1:33
    x.dat.fullpath{i} = char(strcat('/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/bmrk3/imagineup/',subs{i}));
end

imagineup = x;
disp('imagineup data object created');

clear x;
clear i;
clear subs;
clear path_set;