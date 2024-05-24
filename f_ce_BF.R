source("dienes_BF.R")

freq_ce_model <- readRDS("models/freq_ce_model.rds")

ce_summary <- summary(freq_ce_model)
ce_summary_coefs <- coef(ce_summary)
ce_scale <- 50 # previously measured ce estimates
ce_mean_effect <- ce_summary_coefs["congruencyincongruent", "Estimate"]
ce_se_effect <- ce_summary_coefs["congruencyincongruent", "Std. Error"]

ce_BF <- BF(sd = ce_se_effect, obtained = ce_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = ce_scale, tail = 1)
ce_range <- seq(from= 0,to=ce_summary_coefs["(Intercept)", "Estimate"],by=0.01)
ce_range_test <- BF_range(sd = ce_se_effect, obtained = ce_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = ce_range, tail = 1)

ev_for_ce <- subset(data.frame(ce_range_test), BF > 3)
low_ce_threshold <- min(ev_for_ce$sdtheory)
high_ce_threshold <- max(ev_for_ce$sdtheory)
sink("f_ce_BF.txt")
cat(low_ce_threshold, high_ce_threshold, ce_BF, sep = ", ")
sink()
