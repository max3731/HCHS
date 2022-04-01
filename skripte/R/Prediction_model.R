setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)
library(R.matlab)
library(tidyr)
library(reshape2)
library(tidyverse)
library(gapminder)


CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_bast2.csv")
agec = CONNECT$age
T_tukc =  transformTukey(CONNECT$ratio, plotit=FALSE)
sexc = CONNECT$sex

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/data_930_ggp_swp.csv")

ratio = HCHS$wmh_total_vol / HCHS$brain_in_nativ_vol


T_tuk = transformTukey(ratio, plotit=FALSE)
plotNormalHistogram(T_tuk)

#lm_wmhl_ef <- lm(Ef ~ T_tuk + age + sex + brain_in_nativ_vol + Ew_median, HCHS)

#Effizienz
lm_wmhl_ef <- lm(Ef ~ T_tuk + age + sex , HCHS)

ggplot(HCHS,aes(x=T_tuk,y=Ef))+geom_point() + labs(x="Läsionsvolumen", y="Ef") + 
  ggtitle("Effizienz \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)

pred_eff = predict(lm_wmhl_ef, data.frame(T_tuk = T_tukc, age = agec, sex =sexc))

#Degree
lm_wmhl_de <- lm(De ~ T_tuk , HCHS) # + age + sex


pred_degree = predict(lm_wmhl_de, data.frame(T_tuk = T_tukc, age = agec, sex =sexc))

#Standardabweichung aus dem Model ziehen (Um Residuen um die predikteten Mittelwerte zu simulieren)
stand <- sigma(lm_wmhl_de)
#Residuen mit Standardabweichung Simulieren(sind immer normal verteilt)
pred_degree_res = rnorm(42,0,stand)
conn = c(pred_degree, CONNECT$degrees_wei)

pred = pred_degree+ pred_degree_res

ggplot(HCHS,aes(x=T_tuk,y=De)) +
  geom_point(alpha = .2) + 
  labs(x="Läsionsvolumen", y="Degree") + 
  ggtitle("Degree \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) +
  geom_point(data = data.frame(LV=T_tukc, De = pred), aes(x = LV, y = De), inherit.aes = FALSE, color = 'red') +
  geom_smooth(data = data.frame(LV=T_tukc, De = pred), aes(x=LV, y=De), method = 'lm', color = 'red')


lm_wmhl_de_C = lm(pred ~ T_tukc)
lm_wmhl_de_C %>% summary()

ggplot(NULL,aes(x=T_tukc,y=pred))+geom_point() + labs(x="Läsionsvolumen", y="Degree (predicted") + 
  ggtitle("Degree (predicted) \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)

co<-coefficients(lm_wmhl_de)
type1 = c(rep(1,42))
type2 = c(rep(2,42))

sigma(lm_wmhl_ef)


type = c(type1,type2)
name = c("Pred", "Orig" )
Group = factor(type)
levels(Group) = c("Pred", "Orig")

conn_frame = data.frame(Group,conn)

ggplot(conn_frame, aes(x=Group, y=conn,  fill=Group)) + geom_boxplot() + 
  labs(x="Groups", y="Degree") + geom_point() + ggtitle("Degree (normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point() 

sigma(lm_wmhl_ef)