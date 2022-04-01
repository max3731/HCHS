setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/without_age/HCHS_conn_0_aroma.csv")
p_val = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/p-values.csv")


thresh = c(0.0,0.1,0.3,0.5,0.7)
mean_conn = c(0.01,0.01,0.009,0.006,0.001)
mean_default = c(0.04,0.04,0.02,0.012,0.008)
mean_dorsal= c(0.00002,0.00002,0.000014,0.00003,0.00003)
mean_salv = c(0.000018,0.00002,0.000042,0.0001,0.0004)
mean_sommot = c(0.000013,0.00001,0.000036,0.00006,0.0001)
mean_vis = c(0.03,0.03,0.02,0.007,0.002)


default_dorsal = c(0.72,0.7027,0.52,0.13,0.01)
default_vis = c(0.4,0.4,0.2,0.07,0.02)
dorsal_salven = c(0.0025,0.003,0.002,0.002,0.004)
dorsal_sommot = c(0.016,0.02,0.01,0.00985,0.01)
dorsal_vis = c(0.003,0.003,0.01,0.004,0.008)
salven_sommot = c(0.001,0.001,0.0013,0.0012,0.001)
salven_vis = c(0.015,0.02,0.02,0.02,0.051)
modul = c(0.06,0.06,0.04,0.05,0.04)

modul_salven = c(0.0006,0.0006,0.0009,0.01,0.0002)
modul_sommot = c(0.009,0.006,0.003,0.002,0.009)




HCHS_val = data.frame(thresh,mean_conn,mean_default,mean_dorsal,mean_salv,mean_sommot,mean_vis,dorsal_salven,dorsal_sommot,salven_sommot,salven_vis,default_dorsal,default_vis,modul,modul_salven,modul_sommot)

ggplot(HCHS_val,aes(x = thresh, y = mean_conn)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere Konnektivität") +  
  ggtitle("Mittlere Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = mean_default)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere Default Konnektivität") +  
  ggtitle("Mittlere Default Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = mean_dorsal)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Treshold", y="Mittlere Dorsal Konnektivität") +  
  ggtitle("Mittlere Dorsal Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = mean_salv)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Treshold", y="Mittlere salven Konnektivität") +  
  ggtitle("Mittlere salven Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = mean_sommot)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Treshold", y="Mittlere Sommot Konnektivität") +  
  ggtitle("Mittlere Sommot Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = mean_vis)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere Vis Konnektivität") +  
  ggtitle("Mittlere Vis Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = dorsal_salven)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Treshold", y="Mittlere dorsal_salven Konnektivität") +  
  ggtitle("Mittlere dorsal_salven Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = dorsal_sommot)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Treshold", y="Mittlere dorsal_sommot Konnektivität") +  
  ggtitle("Mittlere dorsal_sommot Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = dorsal_vis)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Treshold", y="Mittlere dorsal_Vis Konnektivität") +  
  ggtitle("Mittlere dorsal_Vis Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = salven_sommot)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere salven_sommot Konnektivität") +  
  ggtitle("Mittlere salven_sommot Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = salven_vis)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere salven_vis Konnektivität") +  
  ggtitle("Mittlere salven_vis Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = salven_vis)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere salven_vis Konnektivität") +  
  ggtitle("Mittlere salven_vis Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = default_dorsal)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere default_dorsal Konnektivität") +  
  ggtitle("Mittlere default_dorsal Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = default_vis)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere default_vis Konnektivität") +  
  ggtitle("Mittlere default_vis Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()

ggplot(HCHS_val,aes(x = thresh, y = modul)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere modul Konnektivität") +  
  ggtitle("Mittlere modul Konnektivität \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()


ggplot(HCHS_val,aes(x = thresh, y = modul_salven)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere modul_salven ") +  
  ggtitle("Mittlere modul_salven \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()


ggplot(HCHS_val,aes(x = thresh, y = modul_sommot)) + geom_point()  + geom_line(colour ="red") +
  labs(x="Threshold", y="Mittlere modul_sommot ") +  
  ggtitle("Mittlere modul_sommot  \n in Abhängigkeit vom Threshold") + 
  theme (plot.title = element_text(color ="royalblue4", size = 14, face ="bold.italic", hjust = 0.5)) +
  geom_hline(aes(yintercept=.05), colour ="blue", linetype ="dashed")+
  theme_classic()