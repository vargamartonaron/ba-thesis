source("dienes_BF.R")

freq_cse_model <- readRDS("models/freq_cse_model")

cse_summary <- summary(freq_cse_model)
cse_summary_coefs <- coef(cse_summary)
cse_scale <- 25 # previously measured cse estimates
cse_mean_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Estimate"]
cse_se_effect <- cse_summary_coefs["congruencyincongruent:prev_congruencyincongruent", "Std. Error"]

freq_cse_motoric_model <- readRDS("models/freq_cse_motoric_model")

cse_reversed_color_axes_summary <- summary(freq_cse_motoric_model)
cse_reversed_color_axes_summary_coefs <- coef(cse_reversed_color_axes_summary)
cse_reversed_color_axes_scale <- 2 # arbitrary
cse_reversed_color_axes_mean_effect <- cse_reversed_color_axes_summary_coefs["congruencyincongruent:prev_congruencyincongruent:reversed_color_axesTRUE", "Estimate"]
cse_reversed_color_axes_se_effect <- cse_reversed_color_axes_summary_coefs["congruencyincongruent:prev_congruencyincongruent:reversed_color_axesTRUE", "Std. Error"]

cse_reversed_correct_responses_summary <- summary(freq_cse_motoric_model)
cse_reversed_correct_responses_summary_coefs <- coef(cse_reversed_correct_responses_summary)
cse_reversed_correct_responses_scale <- 2 # arbitrary
cse_reversed_correct_responses_mean_effect <- cse_reversed_correct_responses_summary_coefs["congruencyincongruent:prev_congruencyincongruent:reversed_correct_responsesTRUE", "Estimate"]
cse_reversed_correct_responses_se_effect <- cse_reversed_correct_responses_summary_coefs["congruencyincongruent:prev_congruencyincongruent:reversed_correct_responsesTRUE", "Std. Error"]

cse_finger_summary <- summary(freq_cse_motoric_model)
cse_finger_summary_coefs <- coef(cse_finger_summary)
cse_finger_scale <- 2 # arbitrary
cse_finger_mean_effect <- cse_finger_summary_coefs["congruencyincongruent:prev_congruencyincongruent:fingerindex", "Estimate"]
cse_finger_se_effect <- cse_finger_summary_coefs["congruencyincongruent:prev_congruencyincongruent:fingerindex", "Std. Error"]

cse_fingermiddle_summary <- summary(freq_cse_motoric_model)
cse_fingermiddle_summary_coefs <- coef(cse_fingermiddle_summary)
cse_fingermiddle_scale <- 2 # arbitrary
cse_fingermiddle_mean_effect <- cse_fingermiddle_summary_coefs["congruencyincongruent:prev_congruencyincongruent:fingermiddle", "Estimate"]
cse_fingermiddle_se_effect <- cse_fingermiddle_summary_coefs["congruencyincongruent:prev_congruencyincongruent:fingermiddle", "Std. Error"]


cse_reversed_color_axes_BF <- BF(sd = cse_reversed_color_axes_se_effect, obtained = - cse_reversed_color_axes_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_reversed_color_axes_scale, tail = 2)

cse_reversed_color_axes_range <- seq(from= 0,to=-cse_mean_effect,by=0.01)
cse_reversed_color_axes_range_test <- BF_range(sd = cse_reversed_color_axes_se_effect, obtained = - cse_reversed_color_axes_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_reversed_color_axes_range, tail = 2)

cse_reversed_correct_responses_BF <- BF(sd = cse_reversed_correct_responses_se_effect, obtained = - cse_reversed_correct_responses_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_reversed_correct_responses_scale, tail = 2)

cse_reversed_correct_responses_range <- seq(from= 0,to=-cse_mean_effect,by=0.01)
cse_reversed_correct_responses_range_test <- BF_range(sd = cse_reversed_correct_responses_se_effect, obtained = - cse_reversed_correct_responses_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_reversed_correct_responses_range, tail = 2)

cse_fingermiddle_BF <- BF(sd = cse_fingermiddle_se_effect, obtained = - cse_fingermiddle_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_fingermiddle_scale, tail = 2)

cse_fingermiddle_range <- seq(from= 0,to=-cse_mean_effect,by=0.01)
cse_fingermiddle_range_test <- BF_range(sd = cse_fingermiddle_se_effect, obtained = - cse_fingermiddle_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_fingermiddle_range, tail = 2)

cse_finger_BF <- BF(sd = cse_finger_se_effect, obtained = - cse_finger_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, scaleoftheory = cse_finger_scale, tail = 2)

cse_finger_range <- seq(from= 0,to=-cse_mean_effect,by=0.01)
cse_finger_range_test <- BF_range(sd = cse_finger_se_effect, obtained = - cse_finger_mean_effect, likelihood = "normal", modeloftheory = "normal", modeoftheory = 0, sdtheoryrange = cse_finger_range, tail = 2)

ev_for_cse_reversed_color_axes <- subset(data.frame(cse_reversed_color_axes_range_test), BF > 3)
low_cse_reversed_color_axes_threshold <- min(ev_for_cse_reversed_color_axes$sdtheory)
high_cse_reversed_color_axes_threshold <- max(ev_for_cse_reversed_color_axes$sdtheory)
sink("f_cse_motoric_reversed_color_axes_BF.txt")
cat(low_cse_reversed_color_axes_threshold, high_cse_reversed_color_axes_threshold, cse_reversed_color_axes_BF, sep = ", ")
sink()

ev_for_cse_reversed_correct_responses <- subset(data.frame(cse_reversed_correct_responses_range_test), BF > 3)
low_cse_reversed_correct_responses_threshold <- min(ev_for_cse_reversed_correct_responses$sdtheory)
high_cse_reversed_correct_responses_threshold <- max(ev_for_cse_reversed_correct_responses$sdtheory)
sink("f_cse_motoric_BF_reversed_correct_responses.txt")
cat(low_cse_reversed_correct_responses_threshold, high_cse_reversed_correct_responses_threshold, cse_reversed_correct_responses_BF, sep = ", ")

ev_for_cse_finger <- subset(data.frame(cse_finger_range_test), BF > 3)
low_cse_finger_threshold <- min(ev_for_cse_finger$sdtheory)
high_cse_finger_threshold <- max(ev_for_cse_finger$sdtheory)
sink("f_cse_motoric_BF_finger.txt")
cat(low_cse_finger_threshold, high_cse_finger_threshold, cse_finger_BF, sep = ", ")
sink()

ev_for_cse_fingermiddle <- subset(data.frame(cse_fingermiddle_range_test), BF > 3)
low_cse_fingermiddle_threshold <- min(ev_for_cse_fingermiddle$sdtheory)
high_cse_fingermiddle_threshold <- max(ev_for_cse_fingermiddle$sdtheory)
sink("f_cse_motoric_BF_fingermiddle.txt")
cat(low_cse_fingermiddle_threshold, high_cse_fingemiddler_threshold, cse_fingermiddle_BF, ", ")
sink()
