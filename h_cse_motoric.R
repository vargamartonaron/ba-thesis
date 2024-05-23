library(tidyverse)
library(brms)

train_df <- read_csv("data/train_df.csv")
model_dir <- "models"

h_cse_motoric_priors <- c(
  set_prior("normal(0, 60)", class = "b", coef = "congruencyincongruent"),
  set_prior("normal(0, 30)", class = "b", coef = "prev_congruencyincongruent"),
  set_prior("normal(0, 5)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:fingerindex"),
  set_prior("normal(0, 5)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:fingermiddle"),
  set_prior("normal(0, 5)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:reversed_color_axesTRUE"),
  set_prior("normal(0, 5)", class = "b", coef = "congruencyincongruent:prev_congruencyincongruent:reversed_correct_responsesTRUE"),
  set_prior("normal(0, 10)", class = "b"),
  set_prior("student_t(3, 0, 10)", class = "sd"),
  set_prior("lkj(2)", class = "cor")
)

h_cse_motoric_formula <- bf(rt ~ congruency * prev_congruency +
                      congruency * prev_congruency * reversed_color_axes +
                      congruency * prev_congruency * reversed_correct_responses +
                      congruency * prev_congruency * finger +
                      (1 + congruency + prev_congruency | participant_id))

h_cse_motoric_fit <- brm(formula = h_cse:motoric_formula, data = train_df, prior = h_cse_motoric_priors, seed = 1234, sample_prior = "yes", save_model = file.path(model_dir, "h_cse_motoric.stan"), file = file.path(model_dir, "h_cse_motoric"), init = 0, iter = 10000, warmup = 2000, cores =  16, file_refit = "on_change")
