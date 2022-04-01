setwd("C:/Users/mschu/Documents/CSI/R-Skripte/")

#CONNECT = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/connectivity_bast.csv")

HCHS = read.csv("C:/Users/mschu/Documents/CSI/R-Skripte/HCHS_imptutated.csv")

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)
library(tidyverse)



HCHSq1 = HCHS %>% filter(HCHS$age < 64 )
Age_group = rep("45-63",length(HCHSq1$id))
HCHSq1 = cbind(HCHSq1,Age_group)

HCHSq2 = HCHS %>% filter(HCHS$age > 63 )
Age_group = rep("64-73",length(HCHSq2$id))
HCHSq2 = cbind(HCHSq2,Age_group)

HCHS = rbind(HCHSq1, HCHSq2)
HCHS[,'Age_group']<-factor(HCHS[,'Age_group'])


#Cortical THickness
ggplot(HCHS, aes(x=Age_group, y=mean_thickness,  fill= Age_group)) + geom_boxplot()  +
  labs(x="Age", y="Cortical Thickness") + ggtitle("Cortical Thickness \n for cohort members below and above 63 years of age ") + 
  theme (plot.title = element_text(color="blue", size=14, face="bold.italic", hjust = 0.5), panel.background = element_blank()) + geom_point() 

t.test(mean_thickness~group)

#Global FC
ggplot(HCHS, aes(x=Age_group, y=mean_conn_all,  fill= Age_group)) + geom_boxplot()  +
  labs(x="Age", y="Global FC") + ggtitle("Global FC \n for cohort members below and above 63 years of age ") + 
  theme (plot.title = element_text(color="blue", size=14, face="bold.italic", hjust = 0.5), panel.background = element_blank()) + geom_point() 



#Clustering
ggplot(CONNECT, aes(x=group, y=clust_coef,  fill=group)) + geom_boxplot()  + labs(x="Gruppen", y="Clustering Koeffizient") + ggtitle("Clustering Koeffizient \n für die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point()
t.test(CONNECT$clust_coef~Group)

#Lokale Effizienz
ggplot(CONNECT, aes(x=group, y=eff_local,  fill=group)) + geom_boxplot()  + labs(x="Gruppen", y="Lokale Effizienz") + ggtitle("Lokale Effizienz \n für die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point()
t.test(CONNECT$eff_local~Group)

#Degree
ggplot(CONNECT, aes(x=group, y=degrees_wei,  fill=group)) + geom_boxplot()  + labs(x="Gruppen", y="Degree") + ggtitle("Degree \n für die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point()
t.test(CONNECT$degrees_wei~Group)

#Modularität
ggplot(CONNECT, aes(x=group, y=mod,  fill=group)) + geom_boxplot()  + labs(x="Gruppen", y="Modularität") + ggtitle("Modularität \n für die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point()
t.test(CONNECT$degrees_wei~Group)

#Betweeness
ggplot(CONNECT, aes(x=group, y=betw ,  fill=group)) + geom_boxplot()  + labs(x="Gruppen", y="Betweeness") + ggtitle("Betweeness \n für die Gruppen") + theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point()
t.test(CONNECT$degrees_wei~Group)
