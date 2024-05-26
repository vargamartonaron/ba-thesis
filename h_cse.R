library(tidyverse)
library(brms)

train_df <- read_csv("data/train_df.csv")
model_dir <- "models"

h_cse_priors <- c(
  set_prior("normal(0, 60)", class = "b", coef = "congruencyincongruent"),
  set_prior("normal(0, 30)", class = "b", coef = "prev_congruencyincongruent"),
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("lkj(2)", class = "cor")
)

h_cse_formula <- bf(rt ~ congruency * prev_congruency + (1 + congruency + prev_congruency | participant_id))

h_cse_fit <- brm(formula = h_cse_formula, data = train_df, save_pars = save_pars(all = TRUE), prior = h_cse_priors, seed = 1234, sample_prior = "yes", save_model = file.path(model_dir, "h_cse_model.stan"), file = file.path(model_dir, "h_cse"), init = 0, iter = 10000, warmup = 2000, cores =  16, file_refit = "on_change")
