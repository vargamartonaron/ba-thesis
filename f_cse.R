library(tidyverse)
library(lme4)
library(lmerTest)

source("dienes_BF.R")

train_df <- readr::read_csv("data/train_df.csv")

freq_cse_model <- lmer(rt ~ congruency * prev_congruency + (1 + congruency + prev_congruency | participant_id), data = train_df)

saveRDS(freq_cse_model, "models/freq_cse_model.rds")

cse_summary <- summary(freq_cse_model)
cse_summary_coefs <- coef(cse_summary)
cse_scale <- 25 # previously measured cse estimates
cse_mean_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Estimate"]
cse_se_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Std. Error"]

cse_BF <- BF(sd = cse_se_effect, obtained = - cse_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_scale, tail = 1)
cse_range <- seq(from= 0,to=cse_scale * cse_summary_coefs["congruencyincongruent", "Estimate"],by=0.01)
cse_range_test <- BF_range(sd = cse_se_effect, obtained = - cse_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_range, tail = 1)

ev_for_cse <- subset(data.frame(cse_range_test), BF > 3)
low_cse_threshold <- min(ev_for_cse$sdtheory)
high_cse_threshold <- max(ev_for_cse$sdtheory)
sink("models/f_cse_BF.txt")
print(low_cse_threshold, high_cse_threshold, cse_BF)
sink()
