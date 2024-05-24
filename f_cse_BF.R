source("dienes_BF.R")

freq_ce_model <- readRDS("models/freq_ce_model.rds")
ce_summary <- summary(freq_ce_model)
ce_summary_coefs <- coef(ce_summary)
ce_scale <- 50 # previously measured ce estimates
ce_mean_effect <- ce_summary_coefs["congruencyincongruent", "Estimate"]
ce_se_effect <- ce_summary_coefs["congruencyincongruent", "Std. Error"]

freq_cse_model <- readRDS("models/freq_cse_model.rds")
cse_summary <- summary(freq_cse_model)
cse_summary_coefs <- coef(cse_summary)
cse_scale <- 25 # previously measured cse estimates
cse_mean_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Estimate"]
cse_se_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Std. Error"]

cse_BF <- BF(sd = cse_se_effect, obtained = - cse_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_scale, tail = 1)
cse_range <- seq(from= 0,to=ce_scale,by=0.01)
cse_range_test <- BF_range(sd = cse_se_effect, obtained = - cse_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_range, tail = 1)

ev_for_cse <- subset(data.frame(cse_range_test), BF > 3)
low_cse_threshold <- min(ev_for_cse$sdtheory)
high_cse_threshold <- max(ev_for_cse$sdtheory)
sink("f_cse_BF.txt")
cat(low_cse_threshold, high_cse_threshold, cse_BF, sep = ", ")
sink()
