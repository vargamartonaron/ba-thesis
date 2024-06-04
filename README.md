# Psychology BA thesis, author: Marton Aron Varga

---
This repository contains the experiment to generate stimuli and collect data written in jsPsych. Model training are contained in .R files,
data cleaning and analysis are contained in .Rmd files

if you'd like to read the thesis, please ask for a .pdf file at martonaronvarga at gmail dot com

## Contents: 
- css/ -  code to format the style of the experiment
- images/ - images presented during the experiment
- cse.html - jsPsych code of the experiment
- gen_trials.py - stimuli generator
- config.js - helper file to implement multiple languages
- local.js - text dictionary of the experiment
- parse_data.py - reading experiment data line by line
- server.js - server logic to host the experiment using Express
- f_ - frequentist model training using lme4
- h_ - Bayesian model training using brms
- dienes_BF.R - script calculating Dienes Bayes Factor
- tidy_data.Rmd - data cleaning Rmarkdown file
- analysis.Rmd - formal analysis of the experiment data

