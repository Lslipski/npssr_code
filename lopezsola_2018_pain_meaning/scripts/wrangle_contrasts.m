datadir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/lopezsola_2018_pain_meaning';
savedir = '/Users/lukie/Documents/canlab/NPSSR/NPSSR_contrast_images_local/lopezsola_2018_pain_meaning/contrasts/'
origdir = pwd;
cd(datadir)

% get list of painbetas fmri objects to loop through and print to console
mymats = dir('*painbetas*');
myfiles = {mymats.name}
char(myfiles)

% all participants had A-B-B-A design with four trials in each run
% A = take pain assigned to them
% B = take pain assigned to romantic partner
trial_vec = [1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1]';
pain_type = {'self_pain' 'partner_pain'}

for i = 1:size(char(myfiles),1)
   mydat = load(char(myfiles(i)));
   self_pain_imgs = mydat.painbetas.dat(:,trial_vec == 1);
   partner_pain_imgs = mydat.painbetas.dat(:,trial_vec == 0);
   
   self_pain_contrasts = mean(self_pain_imgs,2);
   partner_pain_contrast = mean(partner_pain_imgs, 2);
   
   mydat.painbetas.dat = [self_pain_contrasts partner_pain_contrast];
   mycopy = mydat.painbetas;
    
   
   % set up fullpath so mean images save in correct locations
   for cue = 1:2
       new_full_path = char(strcat(savedir, pain_type(cue), myfiles(i), '.img'));
       new_full_path = erase(new_full_path, '.mat');
       mycopy.fullpath = fullfile(new_full_path);
       mycopy.dat = mydat.painbetas.dat(:,cue);
       
       write(mycopy);

   end
   
end










cd(origdir)