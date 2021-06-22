setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")


#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/without_age/HCHS_conn_0_aroma.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.7_aroma_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/36/HCHS_conn_0.5_36_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_pval_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_gsr_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_imptutated.csv")
#HCHS = read_excel("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/Lernen.xlsx")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_conn_aroma_abs.csv")

#HCHS[HCHS == "NaN"] <- NA
#HCHS$diabetes = as.factor(HCHS$diabetes)
#HCHS = na.omit(HCHS)

library(readxl)
library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)
library(QuantPsyc)


library(tidyverse)

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)
library(skimr)

library(pander)
library(mediation)
library(diagram)
library(medflex)
library(psych) 

library(mice)
library(VIM)

round(describe(HCHS))

plotNormalHistogram(HCHS$wml)
plotNormalHistogram(HCHS$ratio)
plotNormalHistogram(HCHS$mean_default_all)
plotNormalHistogram(HCHS$psmd_rat)
plotNormalHistogram(HCHS$mean_thickness)
plotNormalHistogram(HCHS$education)

smoking = transform(HCHS$smoking,id=as.numeric(factor(HCHS$smoking)))
smoking = smoking$id
HCHS["smoking"] <- smoking

HCHS$hypertension = as.factor(HCHS$hypertension)
HCHS$smoking = as.factor(HCHS$smoking)
HCHS$diabetes = as.factor(HCHS$diabetes)

HCHS$education=round(HCHS$education)

HCHS$hypertension_1 = as.factor(HCHS$hypertension_1)

# Checking missing data (percentage)

pMiss <- function(x){sum(is.na(x))/length(x)*100}
apply(HCHS,2,pMiss)
apply(HCHS,1,pMiss)

md.pattern(HCHS)
aggr_plot <- aggr(HCHS, col=c('navyblue','red'), # plot an overview
numbers=TRUE, sortVars=TRUE, labels=names(data), 
cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))

marginplot(HCHS[c(16,1)]) # constrained at plotting 2 variables at a time only The red box plot on the left shows the distribution of Solar.R with Ozone missing while the blue box plot shows the distribution of the remaining datapoints. Likewhise for the Ozone box plots at the bottom of the graph.
                         #If our assumption of MCAR data is correct, then we expect the red and blue box plots to be very similar


#Imputing Data

tempData <- mice(HCHS,m=5,maxit=20,meth= c("","","","","","","pmm","","","","logreg","","logreg","logreg","pmm","pmm","pmm","pmm",
                                           "logreg","pmm","pmm","pmm","","","","","","","","","","","","","","","","","",
                                           "","","","","","","","","","","","","","","","","","","","","","",""),seed=500)

tempData <- mice(HCHS,m=5,maxit=50,meth= "cart",seed=500)

tempData <- mice(HCHS,m=5,maxit=1,meth= "logreg",seed=500) # hyertension
summary(tempData)

tempData$imp$animal # checking results

densityplot(tempData) #plot imputated and original data

HCHS <- complete(tempData,2) # replace missing values with imputaded data

# check for na in data frame
is.na(HCHS)
nas = apply(is.na(HCHS), 2, which) 

#Delete na in psmd
na_psmd = nas$animal
HCHS <- HCHS[-na_psmd,] 


psmd_rat = HCHS$psmd*1000
HCHS["psmd_rat"] <- psmd_rat

#T_tuk = transformTukey(HCHS$wml, plotit=FALSE)
T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
HCHS["T_tuk"] <- T_tuk

df1 = data.frame(HCHS$mean_conn_all,HCHS$age,HCHS$mean_thickness)

library(SciViews)
#für Funktion correlation
KorTab <- SciViews::correlation(df1)
pander(KorTab, digits = 3)
plot(KorTab, type = "lower", digits = 3)

Mod1     <- lm(HCHS$mean_conn_all ~ HCHS$age , data = df1)
Mod1_Std <- lm(scale(HCHS$mean_conn_all ) ~ scale(HCHS$age ), 
               data = df1)
pander(summary(Mod1_Std), digits = 3)


Mod2     <- lm(HCHS$mean_thickness ~ HCHS$age , data = df1)
Mod2_Std <- lm(scale(HCHS$mean_thickness ) ~ scale(HCHS$age ), 
               data = df1)
pander(summary(Mod2_Std), digits = 3)

Mod12     <- lm(HCHS$mean_conn_all ~ HCHS$age + HCHS$mean_thickness, data = df1)
Mod12_Std <- lm(scale(HCHS$mean_conn_all ) ~ scale(HCHS$age ) +  scale(HCHS$mean_thickness ) , 
               data = df1)
pander(summary(Mod12_Std), digits = 3)

# Age via brainvol on connectivity

model.0 <- lm(mean_conn_all ~ age, HCHS)
model.M <- lm(brainvol   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_conn_all ~ age + brainvol + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(TMTB ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(TMTB ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=1000)

model.0 <- lm(mean_dorsal_sign_all  ~ age, HCHS)
model.M <- lm(brainvol   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sign_all  ~ age + brainvol  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_sign_all  ~ age, HCHS)
model.M <- lm(brainvol   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_sign_all  ~ age + brainvol  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_sommot_sign_all  ~ age, HCHS)
model.M <- lm(brainvol   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_sommot_sign_all  ~ age + brainvol  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_vis_sign_all ~ age, HCHS)
model.M <- lm(brainvol   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_vis_sign_all ~ age + brainvol  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)



model.0 <- lm(mean_default_salven_sign_all ~ age + sex + education, HCHS)
model.M <- lm(brainvol   ~ age + sex + education, HCHS)
model.Y <- lm(mean_default_salven_sign_all ~ age + brainvol+ sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_salven_sign_all ~ age + sex + education, HCHS)
model.M <- lm(brainvol   ~ age + sex + education, HCHS)
model.Y <- lm(mean_dorsal_salven_sign_all ~ age + brainvol + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_sommot_sign_all  ~ age + sex + education, HCHS)
model.M <- lm(brainvol   ~ age + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sommot_sign_all  ~ age + brainvol + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_vis_sign_all  ~ age + sex + education, HCHS)
model.M <- lm(brainvol   ~ age + sex + education, HCHS)
model.Y <- lm(mean_dorsal_vis_sign_all  ~ age + brainvol + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_sommot_sign_all  ~ age + sex + education, HCHS)
model.M <- lm(brainvol   ~ age + sex + education, HCHS)
model.Y <- lm(mean_salven_sommot_sign_all  ~ age + brainvol + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_cont_sign_all ~ age + sex + education, HCHS)
model.M <- lm(brainvol   ~ age, HCHS)
model.Y <- lm(mean_salven_cont_sign_all ~ age + brainvol + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

summary(model.0)
lm.beta(model.0)
summary(model.M, standardized=TRUE)
lm.beta(model.M)
summary(model.Y, standardized=TRUE)
lm.beta(model.Y)
summary(med.out, standardized=TRUE, rsquare=TRUE)



# Age via mean_thickness on connectivity

model.0 <- lm(mean_default_all ~ age+ sex + education, HCHS)
model.M <- lm(Default_all   ~ age + sex + education, HCHS)
model.Y <- lm(mean_default_all ~ Default_all  +age + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Default_all', boot=TRUE, sims=1000)

model.0 <- lm(mean_default_sign_all  ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_default_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=10000)

model.0 <- lm(mean_default_all ~ age+ sex + education, HCHS)
model.M <- lm(mean_thickness   ~ age + sex + education, HCHS)
model.Y <- lm(mean_default_all ~ mean_thickness  +age + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_conn_sign_all  ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_conn_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)



model.0 <- lm(mean_dorsal_all ~ age +sex+education, HCHS)
model.M <- lm(Dorsal_all   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_all ~ age + Dorsal_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Dorsal_all', boot=TRUE, sims=1000)

model.0 <- lm(mean_dorsal_sign_all  ~ age, HCHS)
model.M <- lm(Dorsal_all   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sign_all  ~ age + Dorsal_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Dorsal_all', boot=TRUE, sims=1000)

model.0 <- lm(mean_dorsal_all ~ age +sex+education, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_all ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_sign_all  ~ age +sex+education, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=1000)




model.0 <- lm(mean_salven_all  ~ age+ sex + education, HCHS)
model.M <- lm(Salience_all   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_all  ~ age + Salience_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Salience_all', boot=TRUE, sims=1000)

model.0 <- lm(mean_salven_sign_all  ~ age+ sex + education, HCHS)
model.M <- lm(Salience_all   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_sign_all  ~ age + Salience_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Salience_all', boot=TRUE, sims=1000)

model.0 <- lm(mean_salven_all  ~ age+ sex + education, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_sign_all  ~ age+ sex + education, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)



model.0 <- lm(mean_cont_all  ~ age+ sex + education, HCHS)
model.M <- lm(Cont_all   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_cont_all  ~ age + Cont_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Cont_all', boot=TRUE, sims=1000)

model.0 <- lm(mean_cont_sign_all  ~ age+ sex + education, HCHS)
model.M <- lm(Cont_all   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_cont_sign_all  ~ age + Cont_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='Cont_all', boot=TRUE, sims=1000)


model.0 <- lm(mean_default_sign_all  ~ age, HCHS)
model.0 <- lm(mean_cont_all  ~ age+ sex + education, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_cont_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=1000)

model.0 <- lm(mean_cont_sign_all  ~ age+ sex + education, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_cont_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=1000)




model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_default_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_sign_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sign_all ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)


model.0 <- lm(mean_default_salven_sign_all ~ age , HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_default_salven_sign_all ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=10000)

model.0 <- lm(mean_dorsal_salven_sign_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_salven_sign_all ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_sommot_sign_all  ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sommot_sign_all  ~ age + mean_thickness + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_vis_sign_all  ~ age , HCHS)
model.M <- lm(mean_thickness   ~ age + sex + education, HCHS)
model.Y <- lm(mean_dorsal_vis_sign_all  ~ age + mean_thickness + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_sommot_sign_all  ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_sommot_sign_all  ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_cont_sign_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_cont_sign_all ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)

# Age via psmd_rat on connectivity

model.0 <- lm(mean_conn_sign_all ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_conn_sign_all ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_default_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_default_all ~ age + mean_thickness  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_sign_all  ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sign_all  ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_sign_all  ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_sign_all  ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_sommot_sign_all  ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_sommot_sign_all  ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_vis_sign_all ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_vis_sign_all ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)



model.0 <- lm(mean_default_salven_sign_all ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_default_salven_sign_all ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_salven_sign_all ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_salven_sign_all ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_sommot_sign_all  ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_dorsal_sommot_sign_all  ~ age + psmd_rat + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_dorsal_vis_sign_all  ~ age , HCHS)
model.M <- lm(psmd_rat   ~ age + sex + education, HCHS)
model.Y <- lm(mean_dorsal_vis_sign_all  ~ age + psmd_rat + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_sommot_sign_all  ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_sommot_sign_all  ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

model.0 <- lm(mean_salven_cont_sign_all ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_salven_cont_sign_all ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)





model.0 <- lm(mean_sommot_limb_all ~ age, HCHS)
model.M <- lm(psmd_rat   ~ age  + sex + education, HCHS)
model.Y <- lm(mean_sommot_limb_all ~ age + psmd_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd_rat', boot=TRUE, sims=5000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)










# Age via connectivity on cognition 

model.0 <- lm(animal ~ age, HCHS)
model.M <- lm(mean_default_all   ~ age  + sex + education, HCHS)
model.Y <- lm(animal ~ age + mean_default_all  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_default_all', boot=TRUE, sims=5000)

model.0 <- lm(animal ~ age, HCHS)
model.M <- lm(mean_dorsal_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(animal ~ age + mean_dorsal_all  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_dorsal_all', boot=TRUE, sims=5000)

model.0 <- lm(animal ~ age, HCHS)
model.M <- lm(mean_salven_sign_all  ~ age  + sex+ education, HCHS)
model.Y <- lm(animal ~ age + mean_salven_sign_all + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(animal ~ age, HCHS)
model.M <- lm(mean_conn_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(animal ~ age + mean_conn_all  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_conn_all', boot=TRUE, sims=5000)

model.0 <- lm(animal ~ age, HCHS)
model.M <- lm(mean_salven_sommot_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(animal ~ age + mean_salven_sommot_sign_all   + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_sommot_sign_all', boot=TRUE, sims=1000)

model.0 <- lm(animal ~ age, HCHS)
model.M <- lm(mean_salven_cont_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(animal ~ age + mean_salven_cont_sign_all   + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_cont_sign_all', boot=TRUE, sims=1000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)




model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_default_sign_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(sumwords ~ age + mean_default_sign_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_default_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_dorsal_sign_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(sumwords ~ age + mean_dorsal_sign_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_dorsal_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_salven_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(sumwords ~ age + mean_salven_sign_all   + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_sommot_sign_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(sumwords ~ age + mean_sommot_sign_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_sommot_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_vis_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(sumwords ~ age + mean_vis_sign_all   + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_vis_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_conn_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(sumwords ~ age + mean_conn_all   + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_conn_all', boot=TRUE, sims=5000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)




model.0 <- lm(word ~ age, HCHS)
model.M <- lm(brainvol   ~ age  + sex, HCHS)
model.Y <- lm(word ~ age + brainvol  + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)

model.0 <- lm(word ~ age, HCHS)
model.M <- lm(mean_dorsal_salven_sign_all   ~ age  + sex, HCHS)
model.Y <- lm(word ~ age + mean_dorsal_salven_sign_all  + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_dorsal_salven_sign_all', boot=TRUE, sims=1000)

model.0 <- lm(word ~ age, HCHS)
model.M <- lm(mean_dorsal_sommot_sign_all    ~ age  + sex, HCHS)
model.Y <- lm(word ~ age + mean_dorsal_sommot_sign_all   + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_dorsal_sommot_sign_all', boot=TRUE, sims=1000)

model.0 <- lm(word ~ age, HCHS)
model.M <- lm(mean_dorsal_vis_sign_all   ~ age  + sex, HCHS)
model.Y <- lm(word ~ age + mean_dorsal_vis_sign_all  + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_dorsal_vis_sign_all', boot=TRUE, sims=1000)

model.0 <- lm(word ~ age, HCHS)
model.M <- lm(mean_salven_sommot_sign_all    ~ age  + sex, HCHS)
model.Y <- lm(word ~ age + mean_salven_sommot_sign_all   + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_sommot_sign_all', boot=TRUE, sims=1000)

model.0 <- lm(word ~ age, HCHS)
model.M <- lm(mean_salven_cont_sign_all    ~ age  + sex, HCHS)
model.Y <- lm(word ~ age + mean_salven_cont_sign_all   + sex , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_cont_sign_all', boot=TRUE, sims=5000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)




model.0 <- lm(TMTB ~ psmd_rat, HCHS)
model.M <- lm(mean_thickness_rat   ~ psmd_rat  + sex+ education, HCHS)
model.Y <- lm(TMTB ~ mean_thickness_rat + psmd_rat  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='psmd_rat', mediator='mean_thickness_rat', boot=TRUE, sims=1000)

model.0 <- lm(TMTB ~ age, HCHS)
model.M <- lm(mean_thickness_rat   ~ age  + sex, HCHS)
model.Y <- lm(TMTB ~ age + mean_thickness_rat  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness_rat', boot=TRUE, sims=1000)

model.0 <- lm(TMTB ~ age, HCHS)
model.M <- lm(mean_default_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTB ~ age + mean_default_sign_all   + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_default_sign_all', boot=TRUE, sims=10000)

model.0 <- lm(TMTB ~ age, HCHS)
model.M <- lm(mean_sommot_sign_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTB ~ age + mean_sommot_sign_all  + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_sommot_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTB ~ age, HCHS)
model.M <- lm(mean_vis_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTB ~ age + mean_vis_sign_all   + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_vis_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTB ~ age, HCHS)
model.M <- lm(mean_conn_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTB ~ age + mean_conn_sign_all   + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_conn_sign_all', boot=TRUE, sims=5000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)


model.0 <- lm(TMTA ~ age, HCHS)
model.M <- lm(mean_default_sign_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTA ~ age + mean_default_sign_all  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_default_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTA ~ age, HCHS)
model.M <- lm(mean_dorsal_sign_all   ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTA ~ age + mean_dorsal_sign_all  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_dorsal_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTA ~ age, HCHS)
model.M <- lm(mean_salven_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTA ~ age + mean_salven_sign_all   + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_salven_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTA ~ age, HCHS)
model.M <- lm(mean_sommot_sign_all   ~ age  + sex, HCHS)
model.Y <- lm(TMTA ~ age + mean_sommot_sign_all  + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_sommot_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTA ~ age, HCHS)
model.M <- lm(mean_vis_sign_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTA ~ age + mean_vis_sign_all   + sex+ education , HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_vis_sign_all', boot=TRUE, sims=5000)

model.0 <- lm(TMTA ~ age, HCHS)
model.M <- lm(mean_conn_all    ~ age  + sex+ education, HCHS)
model.Y <- lm(TMTA ~ age + mean_conn_all   + sex + education, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_conn_all', boot=TRUE, sims=5000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)




 Xnames <- c("sex", "education")
 m.med <- multimed(outcome = "TMTA", med.main = "mean_default_sign_all", med.alt = "mean_vis_sign_all",
                      treat = "age", covariates = Xnames,
                      data = HCHS, sims = 100)
 
 summary(m.med)
 

meadiation_thick = data.frame (HCHS$mean_default_sign_all, HCHS$mean_thickness, HCHS$age)
meadiation_thick = lapply(meadiation_thick$HCHS.age, as.numeric)
summary(meadiation_thick)

#Outliers
mahal = mahalanobis(meadiation_thick,
                    colMeans(meadiation_thick),
                    cov(meadiation_thick))

cutoff = qchisq(1-.001,ncol(meadiation_thick))
table(mahal < cutoff)
noout = subset(meadiation_thick,mahal < cutoff)

#Correlations additivity 
correl = cor(meadiation_thick)
correl
symnum(correl)

#fake regression style assumptions check
random = rchisq(nrow(noout),7)
fake = lm(random ~ ., data = noout)
standardized = rstudent(fake)
fitted = scale(fake$fitted.values)

#linearity
qqnorm(standardized)
abline(0,1)

#normality
hist(standardized)

#Homog/s
plot(fitted, standardized)
abline(0,0)
abline(v = 0) 

#cpath
cpath = lm(HCHS.mean_default_sign_all ~ HCHS.age,data= noout)
summary(cpath)

#apath
apath = lm(HCHS.mean_thickness ~ HCHS.age, data = noout )
summary(apath)

#bpath
bpath = lm(HCHS.mean_default_sign_all ~ HCHS.age + HCHS.mean_thickness, data = noout)
summary(bpath)


# Areion Sobel Test
a = coef(apath)[2]
b = coef(bpath)[3]

SEa = summary(apath)$coefficients[2,2]
SEb = summary(bpath)$coefficients[3,2]

zscore = (a*b)/(sqrt((b^2*SEa^2)+(a^2*SEb^2)+(SEa*SEb)))

zscore

pnorm(abs(zscore), lower.tail = F)*2

total = cpath$coefficients[2]
direct = bpath$coefficients[2]


model.0 <- lm(mean_default_sign_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age, HCHS)
model.Y <- lm(mean_default_sign_all ~ age + mean_thickness, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=10000)

summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)



model.0 <- lm(mean_default_sign_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age, HCHS)
model.Y <- lm(mean_default_sign_all ~ age + mean_thickness, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot=TRUE, sims=10000
                              , control.value = 0, treat.value = 100)
summary(model.0)
summary(model.M)
summary(model.Y)
summary(med.out)


# Areion Sobel Test
a = coef(model.M)[2]
b = coef(model.Y)[3]

SEa = summary(model.M)$coefficients[2,2]
SEb = summary(model.Y)$coefficients[3,2]

zscore = (a*b)/(sqrt((b^2*SEa^2)+(a^2*SEb^2)+(SEa*SEb)))

zscore

pnorm(abs(zscore), lower.tail = F)*2





model.0 <- lm(mean_conn_all ~ age, HCHS)
model.M <- lm(mean_thickness   ~ age, HCHS)
model.Y <- lm(mean_conn_all ~ age * mean_thickness, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_thickness', boot= TRUE, boot.ci.type = "bca", sims=5000)
test.TMint(med.out, conf.level = .95)


model.0 <- lm(mean_conn_all ~ age, HCHS)
model.M <- lm(brainvol   ~ age, HCHS)
model.Y <- lm(mean_conn_all ~ age + brainvol, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='brainvol', boot=TRUE, sims=5000)






model.0 <- lm(mean_default_sign_all ~ age, HCHS)
model.M <- lm(psmd   ~ age, HCHS)
model.Y <- lm(mean_default_sign_all ~ age + psmd, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='psmd', boot=TRUE, sims=1000)

model.0 <- lm(mean_default_sign_all ~ age, HCHS)
model.M <- glm(formula = lm(diabetes   ~ age, HCHS), family = binomial, data = HCHS)
model.Y <- lm(mean_default_sign_all ~ age + diabetes, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='diabetes', boot=TRUE, sims=1000)

model.0 <- lm(mean_default_sign_all ~ age, HCHS)
model.M <- glm(formula = lm(hypertension   ~ age, HCHS), family = binomial, data = HCHS)
model.Y <- lm(mean_default_sign_all ~ age + hypertension, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='hypertension', boot=TRUE, sims=1000)



model.0 <- lm(sumwords ~ age, HCHS)
model.M <- lm(mean_default_sign_all   ~ age, HCHS)
model.Y <- lm(sumwords ~ age + mean_default_sign_all, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='age', mediator='mean_default_sign_all', boot=TRUE, sims=1000)




model.0 <- lm(Lernleistung  ~ Unterrichtsguete, HCHS)
model.M <- lm(Motivation      ~ Unterrichtsguete, HCHS)
model.Y <- lm(Lernleistung  ~ Unterrichtsguete  + Motivation, HCHS)
med.out <- mediation::mediate(model.M, model.Y, treat='Unterrichtsguete', mediator='Motivation', boot=TRUE, sims=500)


 summary(model.0)
 summary(model.M)
 summary(model.Y)
 summary(med.out)
 
 
 ####
 
#Moderationseffekt
 
 #Interaction Term
 
 xz = HCHS$age * HCHS$diabetes
 
 summary(lm(mean_conn_all~age+diabetes+xz,HCHS))