library(tidyverse)
library(brms)

train_df <- readr::read_csv("data/train_df.csv")
model_dir <- "models"

h_cse_conditions_priors <- c(
  set_prior("normal(0, 60)", class = "b", coef = "congruencyincongruent"),
  set_prior("normal(0, 30)", class = "b", coef = "prev_congruencyincongruent"),
  set_prior("normal(0, 15)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:condition_positive"),
  set_prior("normal(0, 15)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:condition_negative"),
  set_prior("normal(0, 5)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:condition_neutral"),
  set_prior("normal(0, 10)", class = "b"),
  set_prior("student_t(5, 0, 10)", class = "sd"),
  set_prior("lkj(1.5)", class = "cor")
)

h_cse_conditions_formula <- bf(rt ~ congruency * prev_congruency * 
              (condition_positive + condition_negative + condition_neutral) + 
              (1 + congruency + prev_congruency | participant_id))

h_cse_conditions_fit <- brm(formula = h_cse_conditions_formula, data = train_df, prior = h_cse_conditions_priors, seed = 1234, sample_prior = "yes", save_model = file.path(model_dir, "h_cse_conditions.stan"), file = file.path(model_dir, "h_cse_conditions"), init = 0, iter = 10000, warmup = 2000, cores =  16, file_refit = "on_change")
