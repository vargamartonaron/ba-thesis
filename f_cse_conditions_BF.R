source("dienes_BF.R")

freq_cse_model <- readRDS("models/freq_cse_model.rds")
cse_summary <- summary(freq_cse_model)
cse_summary_coefs <- coef(cse_summary)
cse_scale <- 25 # previously measured cse estimates
cse_mean_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Estimate"]
cse_se_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Std. Error"]

freq_cse_conditions_model <- readRDS("models/freq_cse_conditions_model.rds")
cse_conditions_summary <- summary(freq_cse_conditions_model)
cse_conditions_summary_coefs <- coef(cse_conditions_summary)
cse_conditions_scale <- 5 # arbitrary

cse_conditions_mean_effect_negative <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative", "Estimate"]
cse_conditions_mean_effect_positive <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive", "Estimate"]

cse_conditions_se_effect_negative <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_negative", "Std. Error"]
cse_conditions_se_effect_positive <- cse_conditions_summary_coefs["congruencyincongruent:prev_congruencyincongruent:condition_positive", "Std. Error"]

cse_BF_negative <- BF(sd = cse_conditions_se_effect_negative, obtained = cse_conditions_mean_effect_negative, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_conditions_scale, tail = 1)
cse_BF_positive <- BF(sd = cse_conditions_se_effect_positive, obtained = cse_conditions_mean_effect_positive, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_conditions_scale, tail = 1)

cse_conditions_range <- seq(from= 0,to=-cse_mean_effect,by=0.01)

cse_conditions_range_test_negative <- BF_range(sd = cse_conditions_se_effect_negative, obtained =  cse_conditions_mean_effect_negative, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_range, tail = 1)
cse_conditions_range_test_positive <- BF_range(sd = cse_conditions_se_effect_positive, obtained =  cse_conditions_mean_effect_positive, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_conditions_range, tail = 1)

ev_for_cse_conditions_negative <- subset(data.frame(cse_conditions_range_test_negative), BF > 3)
low_cse_conditions_threshold_negative <- min(ev_for_cse_conditions_negative$sdtheory)
high_cse_conditions_threshold_negative <- max(ev_for_cse_conditions_negative$sdtheory)
sink("f_cse_conditions_negative_BF.txt")
cat(low_cse_conditions_threshold_negative, high_cse_conditions_threshold_negative, cse_BF_negative, sep = ", ")
sink()

ev_for_cse_conditions_positive <- subset(data.frame(cse_conditions_range_test_positive), BF > 3)
low_cse_conditions_threshold_positive <- min(ev_for_cse_conditions_positive$sdtheory)
high_cse_conditions_threshold_positive <- max(ev_for_cse_conditions_positive$sdtheory)
sink("f_cse_conditions_positive_BF.txt")
cat(low_cse_conditions_threshold_positive,high_cse_conditions_threshold_positive, cse_BF_positive, sep = ", ")
sink()
