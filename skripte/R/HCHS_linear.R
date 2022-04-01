setwd("C:/Users/mschu/Documents/CSI/R-Skripte/")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.9_gsr_aroma.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.7_gsr_aroma.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_gsr_aroma.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.3_gsr_aroma.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0_gsr_aroma.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_gsr_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.9_aroma_gsr_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.7_aroma_gsr_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.3_aroma_gsr_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0_aroma_gsr_abs.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.3_aroma_gsr_no_neg.csv")


HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS/HCHS_imputated.csv")



#Packages########################

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
library(car)


       
#Plots##########################

plotNormalHistogram(HCHS$age)
plotNormalHistogram(HCHS$ratio)
plotNormalHistogram(HCHS$mean_default_all)
plotNormalHistogram(HCHS$mean_dorsal_all)
plotNormalHistogram(HCHS$mean_salven_all)
plotNormalHistogram(HCHS$mean_cont_all)

plotNormalHistogram(HCHS$GDS)
plotNormalHistogram(HCHS$animal)
plotNormalHistogram(HCHS$TMT)
plotNormalHistogram(HCHS$word)
plotNormalHistogram(HCHS$smoking)
plotNormalHistogram(HCHS$psmd)

plotNormalHistogram(HCHS$mean_thickness)
plotNormalHistogram(HCHS$Default_all)
plotNormalHistogram(HCHS$Dorsal_all)
plotNormalHistogram(HCHS$Salience_all)
plotNormalHistogram(HCHS$Cont_all)

########################
### Preprocessing ####
########################


#Outliers########################

  for (i in c( "mean_conn_all","mean_default_all","mean_dorsal_all","mean_salven_all","mean_cont_all")){
    
    
    print(i)
    HCHS[i]
    out <- boxplot.stats(HCHS[[i]])$out
    out_ind <- which(HCHS[[i]] %in% c(out))
    out_ind
    
    HCHS= HCHS[-out_ind, ]
   
  }

#T_tuk = transformTukey(HCHS$wml, plotit=FALSE)
  T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
  HCHS["T_tuk"] <- T_tuk


# Smoking to dummy variable
  smoking = transform(HCHS$smoking,id=as.numeric(factor(HCHS$smoking)))
  smoking = smoking$id
  HCHS["smoking"] <- smoking
  
  HCHS <- transform(HCHS, TMT_score = TMTB / TMTA)
  HCHS <- transform(HCHS, TMT_score = TMTB - TMTA)
  
  out <- summary(fit)
  a <- c()
  b <- c()

  HCHS %>% 
    map(~lm(HCHS$animal ~ .x+age, data = HCHS)) %>% map(summary) %>% 
    map(c("coefficients"))
  
  HCHS%>% 
    map_dbl(8)  %>% # 8th element is the p-value 
    tidy %>% 
    dplyr::arrange(desc(x)) %>% 
    rename(p.value = x) -> ps

########################
### LINEAR ANALYSIS ####
########################


  for (i in c( "mean_conn_all","mean_default_all","mean_dorsal_all","mean_salven_all","mean_cont_all","mean_global_within_all","mean_global_between_all")){
    
    HCHS_cov = lm(as.formula(paste(i,"~age + psmd + mean_thickness + sex + education ")), data =HCHS) 
    
    print(i)
    print(lm.beta(HCHS_cov))
    print(summary(HCHS_cov))
    
  }
  
  

  for (i in c("mean_conn_all", "mean_default_all" ,"mean_dorsal_all" , "mean_salven_all",
              "mean_sommon_all","mean_cont_all", "mean_vis_all", "mean_limb_all","mean_default_dorsal_all",
              "mean_default_salven_all","mean_default_sommot_all","mean_default_cont_all","mean_default_vis_all","mean_default_limb_all","mean_dorsal_salven_all",
              "mean_dorsal_sommot_all","mean_dorsal_cont_all","mean_dorsal_vis_all","mean_dorsal_limb_all","mean_salven_sommot_all","mean_salven_cont_all",
              "mean_salven_vis_all","mean_salven_limb_all","mean_sommot_cont_all","mean_sommot_vis_all","mean_sommot_limb_all","mean_cont_vis_all","mean_cont_limb_all"
             ,"mean_vis_limb_all", "mean_default_sign_all", "mean_dorsal_sign_all", "mean_salven_sign_all", "mean_sommot_sign_all ", "mean_vis_sign_all ")){
    
    
    HCHS_cov = lm(as.formula(paste(i,"~age +psmd+ mean_thickness+sex+education")), data =HCHS) # +vol+intercranial+BrainSegNotVent+mean_thickness+brainvol
    print(i)
    print(summary(HCHS_cov))
    
  } 
  
  autoplot(HCHS_cov)
  vif(HCHS_cov)


  for (i in c( "seg_default_all","seg_dorsal_all","seg_salven_all","seg_sommot_all","seg_cont_all","seg_vis_all","seg_limb_all" )){
    
    
    HCHS_cov = lm(as.formula(paste(i,"~ age  + sex")), data =HCHS) # +vol+intercranial+BrainSegNotVent+mean_thickness+brainvol
    print(i)
    print(summary(HCHS_cov))
    # autoplot(HCHS_cov)
    
    # print(car::outlierTest(HCHS_cov))
    #print(lm.beta(HCHS_cov))
    #print( autoplot(HCHS_cov))
    #vif((HCHS_cov))
    #AIC((HCHS_cov))
    
  } 

  for (i in c( "mean_salven_all","salven_betw_all" )){
    
    
    HCHS_cov = lm(as.formula(paste(i,"~ age + sex")), data =HCHS) # +vol+intercranial+BrainSegNotVent+mean_thickness+brainvol
    print(i)
    print(summary(HCHS_cov))
    #autoplot(HCHS_cov)
    cook=cooks.distance(HCHS_cov)
    print( length(cook[cook > 10]))
    print(lm.beta(HCHS_cov))
    print(car::outlierTest(HCHS_cov))
    
  } 


  "mean_conn_all","mean_default_all" ,"mean_dorsal_all" , "mean_salven_all", "mean_cont_all","mean_default_all" ,"mean_dorsal_all" , "mean_salven_all", "mean_cont_all"
  "+mean_thickness +psmd +sex+education","mean_global_between_all","mean_global_within_all",

  for (i in c( "mean_default_all" ,"mean_dorsal_all" , "mean_salven_all", "mean_cont_all","mean_global_within_all","mean_global_between_all","mean_conn_all" )){ 
    
    
    HCHS_cov = lm(as.formula(paste(i,"~ age  ")), data =HCHS) # +vol+intercranial+BrainSegNotVent+mean_thickness+brainvol
    print(i)
    print(summary(HCHS_cov))
    print(lm.beta(HCHS_cov))
    # autoplot(HCHS_cov)
    # hist(HCHS$standardized.residuals)HCHS$leverage = hatvalues(HCHS_cov)
    #HCHS$leverage = hatvalues(HCHS_cov)
    
    #print(sqrt(summary(HCHS_cov)$r.squared))
    
    print(AIC(HCHS_cov))
    
  }
  
  autoplot(HCHS_cov)
  vif(HCHS_cov)
  AIC(HCHS_cov)
  
  for (i in c("mean_conn_all", "mean_default_sign_all" ,"mean_dorsal_sign_all" , "mean_salven_sign_all", "mean_cont_sign_all")){
    
    
    HCHS_cov = lm(as.formula(paste(i,"~ age+psmd+Salience_all+sex+education")), data =HCHS) # +vol+intercranial+BrainSegNotVent+mean_thickness+brainvol
    print(i)
    print(summary(HCHS_cov))
    
    
  } 
  
  autoplot(HCHS_cov)
  vif(HCHS_cov)

###################################
## QUANTILE for PSMD ##############
###################################

  quantile(HCHS$psmd, probs = seq(0, 1, 0.25), na.rm = FALSE,
           names = TRUE, type = 7)
  
  
  quantile(HCHS$age, probs = seq(0, 1, 0.25), na.rm = FALSE,
           names = TRUE, type = 7)
  
  quantile(HCHS$mean_thickness, probs = seq(0, 1, 0.25), na.rm = FALSE,
           names = TRUE, type = 7)
  
  
  HCHSq1 = HCHS %>% filter(HCHS$mean_thickness < 2.389286 )
  group = rep(25,length(HCHSq1$id))
  HCHSq1 = cbind(HCHSq1,group)




  HCHSq2 = HCHS %>% filter(HCHS$mean_thickness > 2.389286  )
  group = rep(75,length(HCHSq2$id))
  HCHSq2 = cbind(HCHSq2,group)
  
  HCHS2=rbind(HCHSq1,HCHSq2)
  
  
  HCHS2$group = factor(HCHS2$group)
  
  
  ggplot(HCHS2, aes(x=group, y=mean_cont_all,  fill=group)) + geom_boxplot()  + labs(x="Gruppen", y="FC") + ggtitle("FC \n f?r die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point() 
  t.test(HCHS2$mean_cont_all~HCHS2$group)
  
  t.test(T_tuk~Group)

####################################
##### Cortical thickness Comparison
####################################

  HCHS_default = c(HCHS[,"Default_all"])
  group1 = (rep(1,length(HCHS_default)))
  group1 <- unname(group1)
  
  HCHS_dorsal = HCHS$Dorsal_all
  group2 = ( rep(2,length(HCHS_Dorsal)))
  group2 <- unname(group2)
  
  HCHS_salience  = HCHS$Salience_all
  group3 = ( rep(3,length(HCHS_salience)))
  group3 <- unname(group3)
  
  HCHS_cont = HCHS$Cont_all
  group4 = ( rep(4,length(HCHS_cont)))
  group4 <- unname(group4)
  
  HCHS_mean = HCHS$mean_thickness
  group5 = ( rep(5,length(HCHS_mean)))
  group5 <- unname(group5)


  df2 <- data.frame(cortical = c(HCHS[,"Default_all"], HCHS[,"Dorsal_all"], HCHS[, "Salience_all"], HCHS[, "Cont_all"],HCHS[, "mean_thickness"]))
  
  group=c(group1, group2, group3, group4,group5)
  name = c("Default", "Dorsal", "Salience","Cont","Global")
  Group = factor(group)
  levels(Group) = c("Default", "Dorsal","Salience","Cont","Global")
  
  df=data.frame(df2,Group)



  ggplot(df, aes(x=Group, y=cortical,  fill=Group)) + geom_boxplot()  + labs(x="Gruppen", y="FC") +
    ggtitle("FC \n f?r die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + 
    geom_point() 

    HCHS2=rbind(HCHSq1,HCHSq2)

    HCHS2$group = factor(HCHS2$group)

    summary(HCHS)

    sumwords = transformTukey(HCHS$sumwords, plotit=FALSE)
    HCHS["sumwords"] <- sumwords

    GDS = transformTukey(HCHS$GDS, plotit=FALSE)
    HCHS["GDS"] <- GDS
    
####################################
##### Diagnostics###################
####################################
    
#Comparison of different models
    
  age.mod <- lm(mean_default_all ~ age + sex + education, data = HCHS)
  
  psmd.mod <- lm(mean_default_all ~ age + psmd+ sex  + education, data = HCHS)
  
  cortical.mod <- lm(mean_default_all ~ age + mean_thickness+ sex  + education, data = HCHS)
  
  combination.mod <- lm(mean_default_all ~ age + psmd + mean_thickness+ sex  + education, data = HCHS)
  
  interaction.mod <- lm(mean_default_all ~ age * psmd * mean_thickness + sex + education, data = HCHS)
  
  interaction2.mod <- lm(mean_default_all ~ age + psmd * mean_thickness + sex + education, data = HCHS)
  
  models <- list(age.mod, psmd.mod, cortical.mod, combination.mod, interaction.mod, interaction2.mod)
  
  model.names <- c('age.mod', 'psmd.mod', 'cortical.mod', 'combination.mod', 'interaction.mod', 'interaction2.mod')
  
  aictab(cand.set = models, modnames = model.names)
  
  anova(interaction.mod, combination.mod)


# Outlier diagnostics

  HCHS$residuals = resid(HCHS_cov)
  
  HCHS$standardized.residuals = rstandard(HCHS_cov)
  
  HCHS$stundentized.residuals = rstudent(HCHS_cov)
  
  HCHS$cooks.distance = cooks.distance(HCHS_cov)
  
  HCHS$dfbeta = dfbeta(HCHS_cov)
  
  HCHS$dffit = dffits(HCHS_cov)
  
  HCHS$leverage = hatvalues(HCHS_cov) 
  
  HCHS$covariance.ratios = covratio(HCHS_cov)
  
  HCHS$standardized.residuals > 2 | HCHS$standardized.residuals < -2
  
  HCHS$large.residuals = HCHS$standardized.residuals>2 | HCHS$standardized.residuals < -2
  
  sum(HCHS$large.residuals)
  
  HCHS[HCHS$large.residuals,c("mean_conn_all", "age", "mean_thickness", "psmd", "standardized.residuals")]
  
  HCHS[HCHS$large.residuals,c("cooks.distance", "leverage", "covariance.ratios")]

# Assessing the assumption of independence

  dwt(HCHS_cov)
  
                                          
                                          
  autoplot(HCHS_cov)
  vif(HCHS_cov)
  1/vif(HCHS_cov)
  mean(vif(HCHS_cov))
  
  AIC(HCHS_cov)





## Mean Connectivity/L?sionsvolumen

HCHS$pc <- predict(prcomp(~mean_conn_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_conn_all,color = mean_conn_all, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Global Connectivity") + 
  ggtitle("Global Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

HCHS$pc <- predict(prcomp(~mean_conn_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_conn_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Global Connectivity") + 
  ggtitle("Global Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

ggplot(HCHS,aes(x=age,y=mean_global_within_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Within Connectivity") + 
  ggtitle("Within Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


ggplot(HCHS,aes(x=age,y=mean_global_between_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Between Connectivity") + 
  ggtitle("Between Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


ggplot(HCHS,aes(x=age,y=seg_global_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Global Segregation") + 
  ggtitle("Global Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

ggplot(HCHS,aes(x=age,y=seg_asso_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Association Segregation") + 
  ggtitle("Association Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


ggplot(HCHS,aes(x=age,y=seg_sensor_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Sensor Segregation") + 
  ggtitle("Sensor Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

ggplot(HCHS,aes(x=age,y=seg_default_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Default Segregation") + 
  ggtitle("Default Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )                                             


ggplot(HCHS,aes(x=age,y=seg_dorsal_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Dorsal Segregation") + 
  ggtitle("Dorsal Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 

ggplot(HCHS,aes(x=age,y=seg_salven_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Salven Segregation") + 
  ggtitle("Salven Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 


ggplot(HCHS,aes(x=age,y=mean_salven_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Salven within") + 
  ggtitle("Salven within \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 

ggplot(HCHS,aes(x=age,y=salven_betw_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Salven between") + 
  ggtitle("Salven between \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 

ggplot(HCHS,aes(x=age,y=seg_sommot_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Sommot Segregation") + 
  ggtitle("Sommot Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 

ggplot(HCHS,aes(x=age,y=seg_cont_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Control Segregation") + 
  ggtitle("Control Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 


ggplot(HCHS,aes(x=age,y=seg_vis_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Visual Segregation") + 
  ggtitle("Visual Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 


ggplot(HCHS,aes(x=age,y=seg_limb_all,fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Limb Segregation") + 
  ggtitle("Limb Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  ) 

HCHS$correlation <- predict(prcomp(~mean_default_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_default_all,color = mean_default_all, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Default Connectivity") + 
  ggtitle("Default Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~mean_default_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_default_all,color = mean_default_all, fill = "transparent" ))+geom_point(colour = "deepskyblue3")  + 
  labs(x="Age", y="Default Connectivity") + 
  ggtitle("Default Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,colour = "deepskyblue3") +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )



HCHS$correlation <- predict(prcomp(~mean_dorsal_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_dorsal_all,color = mean_dorsal_all, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Dorsal Connectivity") + 
  ggtitle("Dorsal Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

ggplot(HCHS,aes(x=age,y=mean_dorsal_all,color = mean_dorsal_all, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="Dorsal Connectivity") + 
  ggtitle("Dorsal Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="deepskyblue3", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3") +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

HCHS$correlation <- predict(prcomp(~mean_salven_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_salven_all,color = mean_salven_all, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="Salience Connectivity") + 
  ggtitle("Salience Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )



HCHS$correlation <- predict(prcomp(~mean_salven_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_salven_all,color = mean_salven_all, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Salience Connectivity") + 
  ggtitle("Salience Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

HCHS$correlation <- predict(prcomp(~mean_cont_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_cont_all,color = mean_cont_all, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Cont Connectivity") + 
  ggtitle("Cont Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

HCHS$correlation <- predict(prcomp(~mean_cont_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_cont_all,color = mean_cont_all, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="Cont Connectivity") + 
  ggtitle("Cont Connectivity \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3") +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~psmd+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=psmd,color = psmd, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="PSMD") + 
  ggtitle("PSMD \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


ggplot(HCHS,aes(x=age,y=psmd,color = psmd, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="PSMD") + 
  ggtitle("PSMD \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color = "deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~mean_thickness+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_thickness,color = mean_thickness, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="Cortical thickness") + 
  ggtitle("Cortical thickness \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~mean_thickness+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=mean_thickness,color = mean_thickness, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Cortical thickness") + 
  ggtitle("Cortical thickness \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )





HCHS$correlation <- predict(prcomp(~seg_global_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=seg_global_all,color = seg_global_all, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Segregation") + 
  ggtitle("Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

HCHS$correlation <- predict(prcomp(~Dorsal_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=Dorsal_all,color = mean_thickness, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Cortical Dorsal_all") + 
  ggtitle("Cortical Dorsal \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )

HCHS$correlation <- predict(prcomp(~Salience_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=Salience_all,color = mean_thickness, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Cortical Salience_all") + 
  ggtitle("Cortical Salience \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~Cont_all+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=Cont_all,color = mean_thickness, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="Cortical Cont_all") + 
  ggtitle("Cortical Cont \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )




HCHS$correlation <- predict(prcomp(~TMTB+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=TMTB,color = TMTB, fill = "transparent" ))+geom_point()  + 
  labs(x="Age", y="TMTB") + 
  ggtitle("TMTB \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )





HCHS$correlation <- predict(prcomp(~TMTB+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=TMTB,color = TMTB, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="TMTB") + 
  ggtitle("TMTB \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3") +    theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )



HCHS$correlation <- predict(prcomp(~TMT_score+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=TMT_score,color = TMT_score, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="TMT_score") + 
  ggtitle("TMT_score \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3") +    theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )



HCHS$correlation <- predict(prcomp(~TMTA+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=TMTA,color = TMT_score, fill = "transparent" ))+geom_point(color="deepskyblue3")  + 
  labs(x="Age", y="TMTA") + 
  ggtitle("TMTA \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm,color="deepskyblue3") +    theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~seg+age, HCHS))[,1]

ggplot(HCHS,aes(x=age,y=seg,color = seg, fill = "transparent" ))+geom_point()  + 
  labs(x="age", y="Seg") + 
  ggtitle("Segregation \n in dependence of age") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )


HCHS$correlation <- predict(prcomp(~TMTB+seg, HCHS))[,1]

ggplot(HCHS,aes(x=seg,y=TMTB,color = TMTB, fill = "transparent" ))+geom_point()  + 
  labs(x="seg", y="TMTB") + 
  ggtitle("TMTB \n in dependence of Segregation") + 
  theme (legend.position = "none",plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + scale_color_gradient(low = "#0091ff", high = "#f0650e")  +   theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )




