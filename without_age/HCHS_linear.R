setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")


HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_conn.csv")

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)


plotNormalHistogram(HCHS$wml)
plotNormalHistogram(HCHS$mean_default_all)



T_tuk = transformTukey(HCHS$wml, plotit=FALSE)


## Mean Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_conn))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Konnektivität") + 
  ggtitle("Mittlere Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)

HCHS_cov = lm(mean_conn ~ T_tuk , HCHS)
summary(HCHS_cov)


## Default Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_default_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Default Konnektivität") + 
  ggtitle("Mittlere Default Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_default_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)



## Dorsal Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_dorsal_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Dorsal Konnektivität") + 
  ggtitle("Mittlere Dorsal Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_dorsal_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)





HCHS_cov = lm(mean_default_all ~ T_tuk , HCHS)
summary(HCHS_cov)





## Cont Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_cont_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Limb Konnektivität") + 
  ggtitle("Mittlere Limb Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_limb_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)





HCHS_cov = lm(mean_default_all ~ T_tuk , HCHS)
summary(HCHS_cov)


## Limb Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_limb_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Limb Konnektivität") + 
  ggtitle("Mittlere Limb Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_limb_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)





HCHS_cov = lm(mean_default_all ~ T_tuk , HCHS)
summary(HCHS_cov)




## Salven Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_salven_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Saven Konnektivität") + 
  ggtitle("Mittlere Salven Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_salven_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)



## Sommon Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_sommon_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Sommon Konnektivität") + 
  ggtitle("Mittlere Sommon Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_sommon_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)


HCHS_cov = lm(mean_default_all ~ T_tuk , HCHS)
summary(HCHS_cov)


## Sommon Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=mean_vis_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Sommon Konnektivität") + 
  ggtitle("Mittlere Sommon Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(mean_sommon_all ~ T_tuk+mean_conn , HCHS)
summary(HCHS_cov)


HCHS_cov = lm(mean_default_all ~ T_tuk , HCHS)
summary(HCHS_cov)


## Default_Dorsal Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_dorsal_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Default_Dorsal Connectivity") + 
  ggtitle("Default_Dorsal Connectivity\n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_dorsal_all ~ T_tuk , HCHS)
summary(HCHS_cov)

## Default_Salven Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_salven_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Default_Salven Konnektivität") + 
  ggtitle("Default_Salven Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_salven_all ~ T_tuk , HCHS)
summary(HCHS_cov)


## Default_Sommot Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_sommot_all))+geom_point() + 
  labs(x="Läsionsvolumen", y=" Default_Sommot Konnektivität") + 
  ggtitle("Default_Sommot Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_sommot_all ~ T_tuk , HCHS)
summary(HCHS_cov)


## Default_Sommot Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_sommot_all))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Sommon Konnektivität") + 
  ggtitle("Mittlere Sommon Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_sommot_all ~ T_tuk , HCHS)
summary(HCHS_cov)

## Default_Cont Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_cont_all))+geom_point() + 
  labs(x="Läsionsvolumen", y=" Default_Cont Konnektivität") + 
  ggtitle(" Default_Cont Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_cont_all ~ T_tuk , HCHS)
summary(HCHS_cov)

## Default_vis Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_vis_all))+geom_point() + 
  labs(x="Läsionsvolumen", y=" Default_vis Konnektivität") + 
  ggtitle(" Default_vis Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_vis_all ~ T_tuk , HCHS)
summary(HCHS_cov)

## Default_limb Connectivity/Läsionsvolumen

ggplot(HCHS,aes(x=T_tuk,y=default_limb_all))+geom_point() + 
  labs(x="Läsionsvolumen", y=" Default_limb Konnektivität") + 
  ggtitle(" Default_limb Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)


HCHS_cov = lm(default_limb_all ~ T_tuk , HCHS)
summary(HCHS_cov)


