library(tidyverse)
library(lme4)
library(lmerTest)

train_df <- readr::read_csv("data/train_df.csv")
source("dienes_BF.R")

freq_cse_conditions_model <- lmer(rt ~ congruency * prev_congruency * (condition_negative + condition_positive + condition_neutral) + (1 + congruency + prev_congruency | participant_id), data = train_df)
saveRDS(freq_cse_conditions_model, "models/freq_cse_conditions_model.rds")
cse_conditions_summary <- summary(freq_cse_conditions_model)
cse_conditions_summary_coefs <- coef(cse_conditions_summary)
cse_conditions_scale <- 5 # arbitrary

cse_conditions_mean_effect_negative <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative", "Estimate"]
cse_conditions_mean_effect_positive <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive", "Estimate"]
cse_conditions_mean_effect_neutral <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_neutral", "Estimate"]

cse_conditions_se_effect_negative <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative", "Std. Error"]
cse_conditions_se_effect_positive <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive", "Std. Error"]
cse_conditions_se_effect_neutral <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_neutral", "Std. Error"]

cse_BF_negative <- BF(sd = cse_conditions_se_effect_negative, obtained = cse_conditions_mean_effect_negative, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_conditions_scale, tail = 1)
cse_BF_positive <- BF(sd = cse_conditions_se_effect_positive, obtained = cse_conditions_mean_effect_positive, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_conditions_scale, tail = 1)
cse_BF_neutral <- BF(sd = cse_conditions_se_effect_neutral, obtained = cse_conditions_mean_effect_neutral, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_conditions_scale, tail = 2)

cse_conditions_range <- seq(from= 0,to=cse_scale * cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Estimate"],by=0.01)

cse_conditions_range_test_negative <- BF_range(sd = cse_conditions_se_effect_negative, obtained =  cse_conditions_mean_effect_negative, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_range, tail = 1)
cse_conditions_range_test_positive <- BF_range(sd = cse_conditions_se_effect_positive, obtained =  cse_conditions_mean_effect_positive, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_range, tail = 1)
cse_conditions_range_test_neutral <- BF_range(sd = cse_conditions_se_effect_neutral, obtained =  cse_conditions_mean_effect_neutral, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_range, tail = 2)

ev_for_cse_conditions_negative <- subset(data.frame(cse_conditions_range_test_negative), BF > 3)
low_cse_conditions_threshold_negative <- min(ev_for_cse_conditions_negative$sdtheory)
high_cse_conditions_threshold_negative <- max(ev_for_cse_conditions_negative$sdtheory)
sink("models/cse_conditions_threshold_negative_BF.rds")
print(low_cse_conditions_threshold_negative, high_cse_conditions_threshold_negative, cse_BF_negative)
sink()

ev_for_cse_conditions_positive <- subset(data.frame(cse_conditions_range_test_positive), BF > 3)
low_cse_conditions_threshold_positive <- min(ev_for_cse_conditions_positive$sdtheory)
high_cse_conditions_threshold_positive <- max(ev_for_cse_conditions_positive$sdtheory)
sink("models/cse_conditions_threshold_positive_BF.rds")
print(low_cse_conditions_threshold_positive, high_cse_conditions_threshold_positive, cse_BF_positive)
sink()

ev_for_cse_conditions_neutral <- subset(data.frame(cse_conditions_range_test_neutral), BF > 3)
low_cse_conditions_threshold_neutral <- min(ev_for_cse_conditions_neutral$sdtheory)
high_cse_conditions_threshold_neutral <- max(ev_for_cse_conditions_neutral$sdtheory)
sink("models/cse_conditions_threshold_neutral_BF.rds")
print(low_cse_conditions_threshold_neutral, high_cse_conditions_threshold_neutral, cse_BF_neutral)
sink()
