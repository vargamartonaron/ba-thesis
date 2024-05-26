library(tidyverse)
library(brms)

train_df <- readr::read_csv("data/train_df.csv")
model_dir = "models"

h_cse_conditions_time_elapsed_priors <- c(
  set_prior("normal(0, 60)", class = "b", coef = "congruencyincongruent"),
  set_prior("normal(0, 30)", class = "b", coef = "prev_congruencyincongruent"),
  set_prior("normal(0, 15)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:condition_positive"),
  set_prior("normal(0, 15)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:condition_negative"),
  set_prior("normal(0, 5)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:condition_neutral"),
  set_prior("student_t(5, 0, 10)", class = "sd"),
  set_prior("lkj(1.5)", class = "cor"),
  set_prior("normal(0, 5)", class = "b", coef = "time_elapsed"),
  set_prior("normal(0, 3)", class = "b", coef = "time_elapsed:condition_positive"),
  set_prior("normal(0, 3)", class = "b", coef = "time_elapsed:condition_negative"),
  set_prior("normal(0, 10)", class = "b")
)

h_cse_conditions_time_elapsed_formula <- bf(rt ~ congruency * prev_congruency * time_elapsed * (condition_positive + condition_negative + condition_neutral) + (1 + congruency + prev_congruency | participant_id))

h_cse_conditions_time_elapsed_fit <- brm(formula = h_cse_conditions_time_elapsed_formula,
					 data = train_df, 
				       	prior = h_cse_conditions_time_elapsed_priors, 
					 seed = 1234, sample_prior = "yes", save_pars = save_pars(all = TRUE), save_model = file.path(model_dir, "h_cse_conditions_time_elapsed.stan"), file = file.path(model_dir, "h_cse_conditions_time_elapsed"), init = 0, iter = 10000, warmup = 2000, cores = 4, file_refit = "always")
