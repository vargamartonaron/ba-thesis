library(tidyverse)
library(brms)

train_df <- readr::read_csv("data/train_df.csv")

model_dir <- "models"

h_ce_priors <- c(
  set_prior("normal(0, 60)", class = "b", coef = "congruencyincongruent"),
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("lkj(2)", class = "cor")
)

h_ce_formula <- bf(rt ~ congruency + (1 + congruency | participant_id))

ce_fit <- brm(formula = h_ce_formula, data = train_df, prior = h_ce_priors, seed = 1234, sample_prior = "yes", save_model = file.path(model_dir, "h_ce.stan"), file = file.path(model_dir, "h_ce"), init = 0, iter = 10000, warmup = 2000, cores =  16, file_refit = "on_change")
