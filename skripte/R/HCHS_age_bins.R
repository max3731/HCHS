setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_imptutated.csv")

#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_gsr_abs.csv")

library(ggplot2)
library(ggfortify)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(broom)
library(AICcmodavg)
library(rcompanion)
library(regclass)
library(lm.beta)
library(rcompanion)
library(dplyr)

young_age <- select(filter(HCHS, age <= 63),c(age,sex,education,TMTB,TMTA,TMT_score,smoking,diabetes,BMI,hypertension,psmd,mean_thickness))

table(young_age$sex)
240/490

median(young_age$age)
IQR(young_age$age)

median(young_age$education)
IQR(young_age$education)

median(young_age$TMTB)
IQR(young_age$TMTB)

median(young_age$TMTA)
IQR(young_age$TMTA)

table(young_age$smoking)
98/490

table(young_age$diabetes)
38/490

median(young_age$BMI)
IQR(young_age$BMI)

table(young_age$hypertension)
283/490

median(young_age$psmd)
IQR(young_age$psmd)

median(young_age$mean_thickness)
IQR(young_age$mean_thickness)

old_age <- select(filter(HCHS, age > 63),c(age,sex,education,TMTB,TMTA,TMT_score,smoking,diabetes,BMI,hypertension,psmd,mean_thickness))

table(old_age$sex)
203/486

median(old_age$age)
IQR(old_age$age)

median(old_age$education)
IQR(old_age$education)

median(old_age$TMTB)
IQR(old_age$TMTB)

median(old_age$TMTA)
IQR(old_age$TMTA)

table(old_age$smoking)
71/486

table(old_age$diabetes)
71/486

median(old_age$BMI)
IQR(old_age$BMI)

table(old_age$hypertension)
402/512

median(old_age$psmd)
IQR(old_age$psmd)

median(old_age$mean_thickness)
IQR(old_age$mean_thickness)