library(lavaan)
library(haven)
library(semPlot)
library(dplyr)  
library(ggplot2)
library(rcompanion)
library(semTools)
library(mice)

library(reshape2)
library(tidyverse)
library(gapminder)
library(Hmisc)
library(dplyr)
library(corrplot)

library(zoo)

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_imptutated.csv")

str(HCHS)
complete.cases(HCHS)
summary(HCHS)

HCHSNA = subset(HCHS, is.na(HCHS$psmd))

HCHS[is.na(HCHS)] = 0
summary(HCHS)

#outlierremoval <- function(dataframe){
 # dataframe %>%
 #   select_if(is.numeric) %>% #selects on the numeric columns
 #   map(~ .x[!.x %in% boxplot.stats(.)$out])
}

#res = outlierremoval(HCHS)
# Checking Data 

   plotNormalHistogram(HCHS$intercranial)
   plotNormalHistogram(HCHS$mean_thickness)
   plotNormalHistogram(HCHS$BrainSegNotVent)
   plotNormalHistogram(HCHS$mean_default_all)
   plotNormalHistogram(HCHS$mean_dorsal_all)
   plotNormalHistogram(HCHS$mean_salven_all)
   plotNormalHistogram(HCHS$mean_sommon_all)
   plotNormalHistogram(HCHS$mean_cont_all)
   plotNormalHistogram(HCHS$mean_vis_all)
   plotNormalHistogram(HCHS$mean_limb_all)
   plotNormalHistogram(HCHS$ratio)
   plotNormalHistogram(HCHS$psmd)
   plotNormalHistogram(HCHS$brainvol)
   

# Angleichung Variablen

  mean_thickness_rat = HCHS$mean_thickness/10
  HCHS["mean_thickness_rat"] <- mean_thickness_rat
  
  Default_all = HCHS$Default_all/10
  HCHS["Default_all"] <- Default_all
  
  Dorsal_all = HCHS$Dorsal_all/10
  HCHS["Dorsal_all"] <- Dorsal_all
  
  Salience_all = HCHS$Salience_all/10
  HCHS["Salience_all"] <- Salience_all
  
  Cont_all = HCHS$Cont_all/10
  HCHS["Cont_all"] <- Cont_all
  
  
  
  
  intercranial_rat = HCHS$intercranial/10000
  HCHS["intercranial_rat"] <- intercranial_rat
  
  
  age = HCHS$age/100
  HCHS["age_rat"] <- age
  
  
  ratio_rat = HCHS$ratio*100
  HCHS["ratio_rat"] <- ratio_rat
  
  
  hyertension = HCHS$hyertension*10
  HCHS["hyertension"] <- hyertension
  
  diabetes = HCHS$diabetes*10
  HCHS["diabetes"] <- diabetes
  
  ratio_rat = HCHS$ratio*100
  HCHS["ratio_rat"] <- ratio_rat
  
  
  psmd_rat = HCHS$psmd*1000
  HCHS["psmd_rat"] <- psmd_rat
  
  
  
  BrainSegNotVent_rat = HCHS$BrainSegNotVent/10000
  HCHS["BrainSegNotVent_rat"] <- BrainSegNotVent_rat
  
  
  
  #T_tuk = transformTukey(HCHS$wml, plotit=FALSE)
  T_tuk = transformTukey(HCHS$ratio_rat, plotit=FALSE)
  HCHS["T_tuk"] <- T_tuk
  
  
  #T_tuk = transformTukey(HCHS$wml, plotit=FALSE)
  T_tuk2 = transformTukey(HCHS$psmd_rat, plotit=FALSE)
  HCHS["T_tuk2"] <- T_tuk2
  
  #T_tuk = transformTukey(HCHS$wml, plotit=FALSE)
  T_tuk3= transformTukey(HCHS$mean_thickness_rat, plotit=FALSE)
  HCHS["T_tuk3"] <- T_tuk3
  
  
  plotNormalHistogram(HCHS$T_tuk)
  plotNormalHistogram(HCHS$T_tuk2)
  plotNormalHistogram(HCHS$T_tuk3)
  
  #?bersucht 
  
  str(HCHS)
  
  varTable(HCHS)
  
# SEM-Modell

  sem.model.measurement1 <- "
  
                            # measurement model
  
                            Struc =~ mean_conn_all_str 

                            Func =~  seg_global_all 
                                    
                            aging =~ age
                            
                            Cognition =~ TMTB
                            
                            
                            #regressions
                            
                            Struc ~ aging  #Regress COM on Sex and SES
                            
                            Func ~ Struc + aging
                            
                            Cognition ~ aging + Struc + Func
  
                            
                            #residual correlations
                            
                            # mean_default_all ~~    mean_salven_all
                            
                           
  "
  

                            
  
  sem.fit.measurement1 <- sem(sem.model.measurement1, data = HCHS)
  
  #Summary results
  summary(sem.fit.measurement1,
          fit.measures = TRUE,
          standardized=TRUE,
          rsquare=TRUE)
  fitmeasures(sem.fit.measurement1, c("cfi","rmsea", "srmr"))
  
  
  semPaths(sem.fit.measurement1, "par", edge.label.cex = 1.2,fade = FALSE, whatLabels = "std", layout ="tree2",bg = "white",curvePivot = TRUE )
  
  inspect(sem.fit.measurement1, "cov.lv")
  
  
  #Varianzen
  varTable(sem.fit.measurement)
  
  # the model-implied covariance matrix:
  fitted(sem.fit.measurement)
  
  #model-implied correlation among variables
  inspect(sem.fit.measurement, what="cor.all")
  
  #observed correlations
  lavCor(sem.fit.measurement)
  
  #residuals in correlational units, this subtraction of the observed - model-implied matrices above,
  #Large positive values indicate the model underpredicts the correlation; large negative values suggest overprediction of correlation. 
  #Usually values |r>.1| are worth closer consideration.
  resid(sem.fit.measurement1, "cor")
  

  
  
  modificationindices(sem.fit.measurement1, minimum.value = 20)
  
  sem.fit.measurement1b <- update(sem.fit.measurement1, add="mean_default_all ~~  mean_sommon_all")
  summary(sem.fit.measurement1b, fit.measures=TRUE)
  fitmeasures(sem.fit.measurement1b, c("cfi","rmsea", "srmr"))
  
  
  # SEM-Modell 4 latente Variablen 
  
  sem.model.measurement2 <- "
  
                            # measurement model
  
                            struc  =~ mean_conn_all_str
                            
                      

                            Func =~  seg_global_all 

                            
            
                            aging =~ age 
                            
                            
                            #regressions
                            
                            struc ~ aging  #Regress COM on Sex and SES
                            
             
                            
                            Func ~ struc + aging 
                            
                            
  
                           #residual correlations

                           # mean_default_all ~~    mean_sommon_all

                            

                            
                            
  "
  
  
  
  
  sem.fit.measurement2 <- sem(sem.model.measurement2,check.gradient = FALSE, data = HCHS)
  
  # Summary results
  summary(sem.fit.measurement2, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(sem.fit.measurement2, c("cfi","rmsea", "srmr"))
  
  # Subset Parameters
  sfit  = standardizedsolution(sem.fit.measurement2)
  # just loadings
  sfit[ sfit$op == "=~",]
  #mean loadings
  mean(abs(sfit[ sfit$op == "=~", "est.std"]))
  
  
  semPaths(sem.fit.measurement2, "par", edge.label.cex = 1.2, fade = FALSE) 
  
  anova(sem.fit.measurement2,sem.fit.measurement1)
  
  #Varianzen
  varTable(sem.fit.measurement2)
  
  # the model-implied covariance matrix:
  fitted(sem.fit.measurement2)
  
  #model-implied correlation among variables
  inspect(sem.fit.measurement2, what="cor.all")
  
  #observed correlations
  lavCor(sem.fit.measurement2)
  
  #residuals in correlational units, this subtraction of the observed - model-implied matrices above,
  #Large positive values indicate the model underpredicts the correlation; large negative values suggest overprediction of correlation. 
  #Usually values |r>.1| are worth closer consideration.
  resid(sem.fit.measurement2, "cor") # to what extent is the correlation bezween to items not captured by the model

  # Modificaion suggestions ordered decreasing
  mod_ind = modificationindices(sem.fit.measurement2, minimum.value = 20)
  head(mod_ind[order(mod_ind$mi, decreasing=TRUE), ],10)
  
  # Adding modifications if necessary
  sem.fit.measurement2b <- update(sem.fit.measurement2, add="mean_default_all ~~  mean_sommon_all")
  summary(sem.fit.measurement2b, fit.measures=TRUE)
  
  #picture again
  semPaths(sem.fit.measurement2b, what='std', nCharNodes=6, sizeMan=10,
           edge.label.cex=1.25, curvePivot = TRUE, fade=FALSE)
  
  semPaths(sem.fit.measurement2b, "par", edge.label.cex = 1.2, fade = FALSE) 
  varTable(sem.fit.measurement2b) 
  
  pfit = data.frame(predict(sem.fit.measurement2b))
  sem.fit.measurement2b = cbind(sem.fit.measurement2b,pfit)
  plot(sem.fit.measurement2b$Func, sem.fit.measurement2b$atrophy)
  plot(sem.fit.measurement2b$Func, sem.fit.measurement2b$lesion)
  plot(sem.fit.measurement2b$aging, sem.fit.measurement2b$Func)
  
  
  # lets first create a dummy plot for semPaths. we will later ovwerwrite the results
  model_fit_HCHS <- sem(sem.model.measurement3,  data=HCHS, auto.var = TRUE,
                      fixed.x = FALSE, meanstructure = TRUE)
  SEMPLOT_HCHS <- semPlotModel(model_fit_HCHS)
  
  summary(model_fit_HCHS, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(model_fit_HCHS, c("cfi","rmsea", "srmr"))
  
  
  # execute the model with multiple imputation using mice()
  model_fit_HCHS <- runMI(model = sem.model.measurement, data=HCHS,
                        fun="sem",
                        miPackage = "mice", m = 5,
                        miArgs = list(maxit = 5),
                        meanstructure = TRUE, fixed.x = FALSE, auto.var = FALSE)
  summary(model_fit_HCHS, fit.measures=TRUE, standardize = TRUE)
  modindices.mi(model_fit_HCHS)
  
  summary(sem.fit.measurement2, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(sem.fit.measurement2, c("cfi","rmsea", "srmr"))
  # epc = expected parameter change
  
  
  
  
 
  # SEM-Modell 4 latente Variablen ohne Cont und Limb
  
  sem.model.measurement3 <- "
  
                            # measurement model
  
                            atrophy =~  brainvol 
                            
                            lesion =~   T_tuk

                            Func =~  mean_default_sign_all + mean_dorsal_sign_all + 
                                      mean_salven_sign_all + mean_sommot_sign_all + mean_vis_sign_all 
                            
            
                            aging =~ age_rat
                            
                            
                            #regressions
                            
                            atrophy ~ age_rat  #Regress COM on Sex and SES
                            
                            lesion ~ age_rat
                            
                            Func ~ aging + atrophy + lesion  
                            
                            
                            
  
                            
                           #residual correlations
                 
                            mean_default_all ~~    mean_sommon_all
                             
                           # lesion ~~ atrophy
             
                        
                            
                            
  "
  
  
  
  
  sem.fit.measurement3 <- sem(sem.model.measurement3, estimator = "ML", data = HCHS)
  
  # Summary results
  summary(sem.fit.measurement3, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(sem.fit.measurement3, c("cfi","rmsea", "srmr")) 
  
  # Modificaion suggestions ordered decreasing
  mod_ind = modificationindices(sem.fit.measurement3, minimum.value = 20)
  head(mod_ind[order(mod_ind$mi, decreasing=TRUE), ],10)

  
  semPaths(sem.fit.measurement3, "par", edge.label.cex = 1.2, fade = FALSE) 
  
  # Plot path diagram with more graphical options:
  semPaths(sem.fit.measurement3, "par", edge.label.cex = 1.2, fade = FALSE, bg = "white", groups = "latents") 
  
  # the model-implied covariance matrix:
  fitted(sem.fit.measurement3)
  
  #model-implied correlation among variables
  inspect(sem.fit.measurement3, what="cor.all")
  
  #observed correlations
  lavCor(sem.fit.measurement3)
  
  
  #residuals in correlational units, this subtraction of the observed - model-implied matrices above,
  #Large positive values indicate the model underpredicts the correlation; large negative values suggest overprediction of correlation. 
  #Usually values |r>.1| are worth closer consideration.
  resid(sem.fit.measurement3, "cor") # to what extent is the correlation bezween to items not captured by the model
  
  ## Modell Vergleich 
  
  fits = list()
  fits$fit1 = sem.fit.measurement1
  fits$fit2 = sem.fit.measurement2
  fits$fit3 = sem.fit.measurement3
  
  round(sapply(fits, function(x) fitmeasures(x)), 3)
  round(sapply(fits, function(x)
        fitmeasures(x, c("chisq", "df", "cfi", "rmsea", "srmr"))), 3)
  
  anova(sem.fit.measurement1,sem.fit.measurement2,sem.fit.measurement3)
  anova(fits$fit1,fits$fit2,fits$fit3)
  
  
  
  
  
  
  # SEM-Modell 4 latente Variablen ohne Cont und Limb
  
  sem.model.measurement4 <- "
  
                            # measurement model
  
                            atrophy =~  mean_thickness_rat + brainvol
                            
            
                            
                            lesion =~   psmd_rat

         
                                       
                                      
                                     
                            
            
                           
                            
                            
                            #regressions
                            
                            mean_thickness_rat ~ age_rat  #Regress COM on Sex and SES
                            
                            brainvol ~ age_rat
                            
                            psmd_rat ~ age_rat
                            
               
                            
                            mean_default_sign_all ~ age_rat + atrophy + lesion 
                            mean_dorsal_sign_all ~ age_rat + atrophy + lesion 
                            mean_salven_sign_all ~ age_rat + atrophy + lesion 
                            mean_sommot_sign_all ~ age_rat + atrophy + lesion 
                            mean_vis_sign_all ~ age_rat + atrophy + lesion 
  
                            
                           #residual correlations
                 
                          #  mean_default_all ~~    mean_sommon_all
                             
                           # lesion ~~ atrophy
             
          
                            
                            
  "
  
  
  
  
  sem.fit.measurement4 <- sem(sem.model.measurement4, estimator = "ML", data = HCHS)
  
  # Summary results
  summary(sem.fit.measurement4, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(sem.fit.measurement4, c("cfi","rmsea", "srmr")) 
  
  # Modificaion suggestions ordered decreasing
  mod_ind = modificationindices(sem.fit.measurement4, minimum.value = 20)
  head(mod_ind[order(mod_ind$mi, decreasing=TRUE), ],10)
  
  
  semPaths(sem.fit.measurement4, "par", edge.label.cex = 1.2, fade = FALSE) 
  
  # Plot path diagram with more graphical options:
  semPaths(sem.fit.measurement4, "par", edge.label.cex = 1.2, fade = FALSE, bg = "white", groups = "latents") 
  
  # the model-implied covariance matrix:
  fitted(sem.fit.measurement3)
  
  #model-implied correlation among variables
  inspect(sem.fit.measurement3, what="cor.all")
  
  #observed correlations
  lavCor(sem.fit.measurement3)
  
  
  # SEM-Modell 4 latente Variablen, integrierte Mediationsanalyse
  
  sem.model.measurement <- "
  
                            # measurement model


                            Func =~   mean_default_sign_all + mean_dorsal_sign_all + 
                            mean_salven_sign_all
                            
                            CVR =~   diabetes + hypertension
                            
                            Age =~ age
                            
     
                            Func ~ c*Age + b1*mean_thickness_rat + b2*psmd_rat 
                            
                      
                            
                            
                            # mediator model
                            
                            mean_thickness_rat ~ a1* Age 
                            
                            psmd_rat ~ a2* Age
                            
                            CVR ~ a3*Age
                            
                            mean_thickness_rat ~ a4*CVR
                            
                            psmd_rat ~ a5*CVR
                            
                            Func ~ a6*CVR
                            
                            TMTB ~ a7*Func
                            
                            
                            # residual correlations

                              mean_thickness_rat ~~    psmd_rat      
                            
                            
                           # indirect effects (IDE)
                           
                                mean_thickness_rat  := a1*b1
                                psmd_rat  := a2*b2
                                CVR :=a3*a4
                                CVR2 :=a3*a5
                                TMTB :=c*a7
          
                     
  
                            
                                sumIDE := (a1*b1) + (a2*b2) + (a3*a4)+ (a3*a5) + (c*a7) 

                                # total effect
                                total := c + (a1*b1) + (a2*b2) + (a3*a4)+ (a3*a5) + (c*a7) 
                            
                            
  "
  
  
  
  
  sem.fit.measurement <- sem(sem.model.measurement,check.gradient = FALSE,data = HCHS, se = "bootstrap", bootstrap = 1000)
                                                                                                                                    

  # Summary results
  summary(sem.fit.measurement, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(sem.fit.measurement, c("cfi","rmsea", "srmr")) 
  
  sfit = parameterestimates(sem.fit.measurement)
  sfit[sfit$op == "~",]
  
  sfit = standardizedsolution(sem.fit.measurement)
  sfit[sfit$op == "~",]
  

  # Modificaion suggestions ordered decreasing
  mod_ind = modificationindices(sem.fit.measurement, minimum.value = 20)
  head(mod_ind[order(mod_ind$mi, decreasing=TRUE), ],10)
  
  nodeLabels = c("Cortical","PSMD")
  
  
  semPaths(sem.fit.measurement, "par", edge.label.cex = 1.2, fade = FALSE, whatLabels = "std", layout ="tree2",bg = "white", groups = "latents", curvePivot = TRUE,
           nodeLabels= c("Def","Dor","Sal","TMTB","Cort","age","PSMD","Hyp","FC","CVR")) 
  
  
  semPaths(sem.fit.measurement, "par", edge.label.cex = 1.2, fade = FALSE, whatLabels = "std", layout ="tree2",bg = "white", groups = "latents", curvePivot = TRUE,exoVar
           
  = FALSE, nodeLabels= c("Def","Dor","Sal","TMTB","Cort","PSMD","age","Diab","Hyp","FC","CVR","Age")) 
  
  # the model-implied covariance matrix:
  fitted(sem.fit.measurement)
  
  #model-implied correlation among variables
  inspect(sem.fit.measurement, what="cor.all")
  
  #observed correlations
  lavCor(sem.fit.measurement)
  
  #residuals in correlational units, this subtraction of the observed - model-implied matrices above,
  #Large positive values indicate the model underpredicts the correlation; large negative values suggest overprediction of correlation. 
  #Usually values |r>.1| are worth closer consideration.
  resid(sem.fit.measurement, "cor") # to what extent is the correlation bezween to items not captured by the model
  
  
  
  sem.model.measurement6 <- "
  
                            # measurement model
  
                            Structural =~  mean_thickness_rat 
                            
                            Brainvol =~ brainvol
                            
                            lesion =~ T_tuk 

                            Func =~  mean_default_sign_all + mean_dorsal_sign_all + mean_salven_sign_all + mean_sommot_sign_all + mean_vis_sign_all 
                            
                            aging =~ age_rat
            
                            
                            
                            
                            #regressions
                            
                            Brainvol ~ b1* aging  #Regress COM on Sex and SES
                            
                            Thickness ~ b2* aging
                            
                            lesion ~ b3* aging
                            
                            Func ~ b4*aging + b5*Brainvol + b6*Thickness + b7*lesion
                            
                            
                            
  
                            
                            # residual correlations

                              mean_default_all ~~    mean_sommon_all

                            

                          
                            # Indirect effects
                              
                              b1b5 := b1*b5
                              b2b6 := b2*b6
                              
                              totalind_age_rat := b1*b5 + b2*b6
                              
                              
                              b3b7 := b3*b7
                              
                              
                              
                          
                          
                          
                            # Total effects
                            
                              total_age_rat:= b1*b4 + b2*b5 + b3*b7 + b4
                            
                            
  "
  
  
  
  
  sem.fit.measurement6 <- sem(sem.model.measurement6,check.gradient = FALSE,data = HCHS, se = "bootstrap", bootstrap = 1000)
  
  # Summary results
  summary(sem.fit.measurement6, fit.measures = TRUE, standardized=TRUE)
  fitmeasures(sem.fit.measurement6, c("cfi","rmsea", "srmr")) 
  
  sfit = parameterestimates(sem.fit.measurement6)
  sfit[sfit$op == "~",]
  
  sfit = standardizedsolution(sem.fit.measurement6)
  sfit[sfit$op == "~",]
  
  
  # Modificaion suggestions ordered decreasing
  mod_ind = modificationindices(sem.fit.measurement, minimum.value = 20)
  head(mod_ind[order(mod_ind$mi, decreasing=TRUE), ],10)
  
  
  
  semPaths(sem.fit.measurement6, "par", edge.label.cex = 1.2, fade = FALSE) 

# Mediationsanalyse mit Lavaan

set.seed(1234)

X <- HCHS$age
M <- HCHS$mean_thickness
Y <- HCHS$mean_default_all

Data <- data.frame(X = X, Y = Y, M = M)
model <- ' # direct effect
Y ~ c*X
# mediator
M ~ a*X
Y ~ b*M
# indirect effect (a*b)
ab := a*b
# total effect
total := c + (a*b)
'
fit <- sem(model, data = Data)
summary(fit)



mediation_model <- "

 # c' direct effect
 mean_salven_sign_all ~ c*age 
 # a Path
 Salience_all ~ a*age
 
 
 # b Path
 mean_salven_sign_all ~ b*Salience_all 
 
 # indirect (a*b)
 ab := a*b
 
 
# total effect
total := c + (a*b)

"

fitmodel= sem(mediation_model, data = HCHS) # Sobel test (Delta Method) assumes that sample of indirect effect is normal distributed

summary(fitmodel2, fit.measures = TRUE, rsquare=TRUE,standardized=TRUE)

set.seed(2019)

fitmodel2 = sem(mediation_model, data=HCHS, se="bootstrap", bootstrap=5000)

parameterEstimates(fitmodel2, ci=TRUE, level= 0.95, boot.ci.type="perc",whatLabels = std)

semPaths(fitmodel2, "par", edge.label.cex = 1.2, fade = FALSE, whatLabels = "std", layout ="tree2",bg = "white", groups = "latents", curvePivot = TRUE) 

semPaths(fitmodel2, "par", edge.label.cex = 1.2,fade = FALSE, whatLabels = "std", layout ="tree2",bg = "white",curvePivot = TRUE )




model <- "
# outcome model 
TMTB ~ c*age + b1*mean_default_sign_all + b2*mean_dorsal_sign_all + b3*mean_salven_sign_all  + sex + education 
# mediator models
mean_default_sign_all ~ a1*age  + sex + education 
mean_dorsal_sign_all ~ a2*age  + sex + education 
mean_salven_sign_all ~ a3*age  +sex + education 


# indirect effects (IDE)
mean_default_sign_all  := a1*b1
mean_dorsal_sign_all  := a2*b2
mean_salven_sign_all  := a3*b3



sumIDE := (a1*b1) + (a2*b2) + (a3*b3) 

# total effect
total := c + (a1*b1) + (a2*b2) + (a3*b3) 
#mean_default_sign_all ~~ mean_dorsal_sign_all + mean_salven_sign_all  # model correlation between mediators
"

fitmodel= sem(model, data = HCHS) 
summary(fitmodel2, fit.measures = TRUE, rsquare=TRUE,standardized=TRUE)

fitmodel2 = sem(model, data=HCHS, se="bootstrap", bootstrap=10000)

parameterEstimates(fitmodel2, ci=TRUE, level= 0.95, boot.ci.type="perc")

semPaths(fitmodel2, "par", edge.label.cex = 1.2, fade = FALSE, whatLabels = "std",bg = "white" , layout ="tree",curvePivot = TRUE     )





model <- "
mean_thickness ~ a1*age + sex + education
mean_dorsal_sign_all ~ a2*age + covs
M3 ~ a3*M1 + a4*M2 + X
Y ~ b*M3 + c*X + covs

IndirectM1 := a1*a3*b
IndirectM2 := a2*a4*b
IndirectM1M2 := (a1*a3*b) + (a2*a4*b)
"

model <- "

 
 
# outcome model 
mean_default_sign_all ~ c*age + b1*mean_thickness +b2*psmd_rat

# mediator models
mean_thickness ~ a1*age
psmd_rat ~ a2*age



# indirect effects (IDE)
mean_thickness  := a1*b1
psmd_rat := a2*b2

# direct effect
  direct := c


sumIDE := (a1*b1) + (a2*b2)

# total effect
total := c + (a1*b1) + (a2*b2)
#mean_default_sign_all ~~ mean_dorsal_sign_all + mean_salven_sign_all  # model correlation between mediators
"





# Tutorial

?HolzingerSwineford1939

holz = HolzingerSwineford1939

HS.model <- ' visual =~ x1 + x2 + x3
textual =~ x4 + x5 + x6
speed =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data=holz)

summary(fit, fit.measures=TRUE)


# Tutorial 2

political = PoliticalDemocracy

model <- '
# measurement model
ind60 =~ x1 + x2 + x3
dem60 =~ y1 + y2 + y3 + y4
dem65 =~ y5 + y6 + y7 + y8
# regressions
dem60 ~ ind60
dem65 ~ ind60 + dem60
# residual correlations
y1 ~~ y5
y2 ~~ y4 + y6
y3 ~~ y7
y4 ~~ y8
y6 ~~ y8
'
fit <- sem(model, data=PoliticalDemocracy)
summary(fit, standardized=TRUE)

