###### npssr_code

# NPS + Self-Regulation
This repository contains code for the Neurologic Pain Scale and Self-Regulation study. 

Contact: luke.slipski.gr@dartmouth.edu

This code is a mixture of bash and python helper functions for data cleaning and wrangling, and Matlab code for analyzing
various pain datasets to compare NPS and behavioral pain ratings across regulation and analgesic strategies.

## Pipeline Description
Because this study is comparing pain responses across multiple datasets, the code comprises two main analysis sequences:
### A Within Dataset Sequence 
This sequence runs imaging QA on contrast maps and calculates NPS responses on contrast images for each subject. Then it creates a CANLab data object for the entire dataset, which includes NPS values and behavioral pain rating values for each subject for each contrast of interest. It is this CANLab dataset that allows for easy comparison of NPS and pain rating responses across datasets (below).

#### Complete Datasets
For a dataset to be included in our study it must contain two parts:

1. **Imaging Data**: This means either beta maps for each contrast of interest created from first-level GLM analysis OR a delimited file that includes extracted NPS response values for each subject for each contrast of interest.
1. **Behavioral Data**: This means a delimited file that includes behavioral pain rating values for each subject for each contrast of interest.

The within study code pipeline (assuming contrast images are provided instead of pre-extracted NPS values) proceeds serially through the following scripts:

* [CANLab Batch Script Sequence](https://canlab.github.io/batch/)
  ###### Set up Paths and Specify Dataset-Specific Options
  1. **a_set_up_paths_always_run_first.m**
  1. **prep_1_set_conditions_contrasts_colors.m**
  ###### Load Contrast Data, Run Image QA with Plots, Apply NPS
  1. **prep_2_load_image_data_and_save.m**
  1. **prep_3_calc_univariate_contrast_maps_and_save.m**
  1. **prep_4_apply_signatures_and_save.m**
  1. **prep_5_save_nps_values_delimited.m** (doesn't exist yet)
  
  At this point, the NPS values we need are all created and saved to tab delimited file, "npsvals_[dataset_ID]". Now we need to take these values and put them into CANLab data object. Then we import the behavioral pain ratings to the same CANLab data object.

* Set up CANLab Data Object 
  1. **create_canlab_dataset_[dataset_ID].m**: This creates the data object and imports the NPS value from npsvals_[dataset_ID], then saves the data object as a .mat file.
  1. **add_pain_ratings_[dataset_ID].m**: This loads the data object and then imports values from the behavioral data delimited file. The data object now has NPS and ratings values that correspond to the contrasts of interest. I can now be compared to other datasets with a corresponding data object.
  1. **analysis_[dataset_ID].m**: This uses the data object to produce bar plots for both NPS response and pain ratings by condition and contrast.


### An Across Dataset Sequence
Coming soon.

