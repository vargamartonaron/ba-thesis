library(tidyverse)
library(lme4)
library(lmerTest)

train_df <- readr::read_csv("data/train_df.csv")

freq_cse_model <- lmer(rt ~ congruency * prev_congruency + (1 + congruency + prev_congruency | participant_id), data = train_df, 
                       control = lmerControl(optCtrl = list(maxfun = 10000), 
                                             optimizer = "bobyqa"))

saveRDS(freq_cse_model, "models/freq_cse_model.rds")
