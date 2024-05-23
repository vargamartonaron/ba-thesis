library(tidyverse)
library(lme4)
library(lmerTest)

train_df <- readr::read_csv("data/train_df.csv")
source("dienes_BF.R")

freq_cse_conditions_time_elapsed_model <- lmer(rt ~ congruency * prev_congruency * (condition_negative + condition_positive + condition_neutral) + (time_elapsed * condition_positive) + (time_elapsed * condition_negative) + (1 + congruency + prev_congruency | participant_id), data = train_df)
saveRDS(freq_cse_conditions_time_elapsed_model, "models/freq_cse_conditions_time_elapsed_model.rds")
cse_conditions_time_elapsed_summary <- summary(freq_cse_conditions_time_elapsed_model)
cse_conditions_time_elapsed_summary_coefs <- coef(cse_conditions_time_elapsed_summary)
cse_conditions_time_elapsed_scale <- 2 # arbitrary

cse_conditions_time_elapsed_mean_effect_negative <- cse_conditions_time_elapsed_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative:time_elapsed", "Estimate"]
cse_conditions_time_elapsed_mean_effect_positive <- cse_conditions_time_elapsed_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive:time_elapsed", "Estimate"]

cse_conditions_time_elapsed_se_effect_negative <- cse_conditions_time_elapsed_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative:time_elapsed", "Std. Error"]
cse_conditions_time_elapsed_se_effect_positive <- cse_conditions_time_elapsed_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive:time_elapsed", "Std. Error"]

cse_BF_negative_time_elapsed <- BF(sd = cse_conditions_time_elapsed_se_effect_negative, obtained = cse_conditions_time_elapsed_mean_effect_negative, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_conditions_time_elapsed_scale, tail = 1)
cse_BF_positive_time_elapsed <- BF(sd = cse_conditions_time_elapsed_se_effect_positive, obtained = cse_conditions_time_elapsed_mean_effect_positive, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_condition_time_elapsed_scale, tail = 1)

cse_conditions_time_elapsed_range_negative <- seq(from= 0,to=cse_conditions_scale * cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative", "Estimate"],by=0.01)
cse_conditions_time_elapsed_range_positive <- seq(from= 0,to=cse_conditions_scale * cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive", "Estimate"],by=0.01)


cse_conditions_time_elapsed_range_test_negative <- BF_range(sd = cse_conditions_time_elapsed_se_effect_negative, obtained =  cse_conditions_time_elapsed_mean_effect_negative, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_time_elapsed_range_negative, tail = 1)
cse_conditions_time_elapsed_range_test_positive <- BF_range(sd = cse_conditions_time_elapsed_se_effect_positive, obtained =  cse_conditions_time_elapsed_mean_effect_positive, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_time_elapsed_range_positive, tail = 1)

ev_for_cse_conditions_time_elapsed_negative <- subset(data.frame(cse_conditions_time_elapsed_range_test_negative), BF > 3)
low_cse_conditions_time_elapsed_threshold_negative <- min(ev_for_cse_conditions_time_elapsed_negative$sdtheory)
high_cse_conditions_time_elapsed_threshold_negative <- max(ev_for_cse_conditions_time_elapsed_negative$sdtheory)
sink("models/cse_conditions_time_elapsed_threshold_negative_BF.txt")
print(low_cse_conditions_time_elapsed_threshold_negative, high_cse_conditions_time_elapsed_threshold_negative, cse_BF_negative_time_elapsed)
sink()

ev_for_cse_conditions_time_elapsed_positive <- subset(data.frame(cse_conditions_time_elapsed_range_test_positive), BF > 3)
low_cse_conditions_time_elapsed_threshold_positive <- min(ev_for_cse_conditions_time_elapsed_positive$sdtheory)
high_cse_conditions_time_elapsed_threshold_positive <- max(ev_for_cse_conditions_time_elapsed_positive$sdtheory)
sink("models/cse_conditions_time_elapsed_threshold_positive_BF.txt")
print(low_cse_conditions_time_elapsed_threshold_positive, high_cse_conditions_time_elapsed_threshold_positive, cse_BF_positive_time_elapsed)
sink()
