library(tidyverse)
library(lme4)
library(lmerTest)

train_df <- readr::read_csv("data/train_df.csv")

freq_ce_model <- lmer(rt ~ congruency  + (1 + congruency | participant_id), data = train_df)
saveRDS(freq_ce_model, "models/freq_ce_model.rds")
