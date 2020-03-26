This folder contains scripts for preparing data from 
Koban, L., Jepma, M., López-Solà, M., & Wager, T. D. (n.d.). Different brain networks mediate the effects of social and conditioned expectations on pain. https://doi.org/10.1038/s41467-019-11934-y

The CANLab data object from this study already exists, so we will be taking NPS values straight from their analysis. Therefore, prep_1, prep_2, prep_3, and prep_4 scripts are being skipped. Prep_5_save_nps_values.m
will extract only the relevant NPS values from this data object. From there create_canlab_dataset_koban_2019 will create a canlab data object with the nps values, and add_pain_ratings_koban_2019 will add the behavioral
pain ratings to that same data object.
