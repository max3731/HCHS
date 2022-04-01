setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_imptutated.csv")

cortical = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/cortical.csv")

HCHS=cbind(HCHS,cortical)


library(tidyverse)
library(ggpubr)
library(rstatix)
library(broom)

quantile(HCHS$psmd, probs = seq(0, 1, 0.25), na.rm = FALSE,
         names = TRUE, type = 7)


HCHSq1 = HCHS %>% filter(HCHS$psmd < 0.0001935292 )
group = rep(25,length(HCHSq1$id))
HCHSq1 = cbind(HCHSq1,group)


HCHSq2 = HCHS %>% filter(HCHS$psmd > 0.0002442465  )
group = rep(75,length(HCHSq2$id))
HCHSq2 = cbind(HCHSq2,group)


HCHS2=rbind(HCHSq1,HCHSq2)


HCHS2$group = factor(HCHS2$group)


ggscatter(
  HCHS2, x = "age", y = "mean_conn_all",
  color = "group", add = "reg.line"
)+
  stat_regline_equation(
    aes(label =  paste(..eq.label.., ..rr.label.., sep = "~~~~"), color = group)
  )

##

HCHS2 %>% anova_test(mean_conn_all ~ group*age)

##Normality of residuals

model <- lm(mean_conn_all ~ age + group, data = HCHS2)

model.metrics <- augment(model) 
head(model.metrics, 3)

shapiro_test(model.metrics$.resid)

##Homogeneity of variances

model.metrics %>% levene_test(.resid ~ group)

# outliers
model.metrics %>% 
  filter(abs(.std.resid) > 3) %>%
  as.data.frame()

##Anova

res.aov <- HCHS2 %>% anova_test(mean_conn_all ~ age + group)
get_anova_table(res.aov)

# Pairwise comparisons
library(emmeans)
pwc <- HCHS2 %>% 
  emmeans_test(
    mean_conn_all ~ group, covariate = age,
    p.adjust.method = "bonferroni"
  )
pwc


get_emmeans(pwc)

# Visualization: line plots with p-values
pwc <- pwc %>% add_xy_position(x = "group", fun = "mean_se")
ggline(get_emmeans(pwc), x = "group", y = "emmean") +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) + 
  stat_pvalue_manual(pwc, hide.ns = TRUE, tip.length = FALSE) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
  )


library("ggpubr")
ggscatter(HCHS, x = "psmd", y = "mean_thickness", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "PSMD", ylab = "Cortical")

