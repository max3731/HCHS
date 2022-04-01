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

CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_05.csv")

T_tuk = transformTukey(CONNECT$ratio, plotit=FALSE)

CONNECT_hc = readMat("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/data_hc_ac.mat")
CONNECT_ma = readMat("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/data_ma_ac.mat")


conn_mean = c(CONNECT_hc, CONNECT_ma)

hc = conn_mean$data.hc.ac
ma = conn_mean$data.ma.ac

conn = c(ma,hc)

x_HC <- "HC"
y_MA <- "MA"

type1 = c(rep(1,17))
type2 = c(rep(2,25))
norm = c(rep("n",42))

type = c(type1,type2)
name = c("MA", "HC" )
Group = factor(type)
levels(Group) = c("MA", "HC")
label = CONNECT$label

conn_frame = data.frame(label,Group,conn,norm)


ggplot(HCHS, aes(x=group, y=mean_thickness,  fill=group)) + geom_boxplot() + 
  labs(x="Groups", y="Mean Connectivity") + geom_point() + ggtitle("Mean Connectivity (normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point() 

ggplot(conn_frame, aes(x=Group, y=conn,  fill=Group)) + geom_boxplot() + 
  labs(x="Groups", y="Mean Connectivity") + geom_point() + ggtitle("Mean Connectivity (normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point() 

CONNECT_hc_un = readMat("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/data_hc_ac_un.mat")
CONNECT_ma_un = readMat("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/data_ma_ac_un.mat")


conn_mean_un = c(CONNECT_hc_un, CONNECT_ma_un)

hc_un = conn_mean_un$data.hc.ac
ma_un = conn_mean_un$data.ma.ac

conn_un = c(ma_un,hc_un)

x_HC <- "HC"
y_MA <- "MA"

type1 = c(rep(1,17))
type2 = c(rep(2,25))
norm = c(rep("unn",42))

type = c(type1,type2)
name = c("MA", "HC" )
Group = factor(type)
levels(Group) = c("MA", "HC")
label = CONNECT$label

conn_frame_un = data.frame(label,Group,conn_un,norm)


ggplot(conn_frame_un, aes(x=Group, y=conn_un,  fill=Group)) + geom_boxplot() + labs(x="Groups", y="Mean Connectivity") + geom_point() + 
  ggtitle("Mean Connectivity (nicht normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point() 

conn_n_un = merge(conn_frame,conn_frame_un,by="ID")

x_HC <- "HCUN"
y_MA <- "MAun"
type1 = c(rep(1,17))
type2 = c(rep(2,25))
norm = c(rep("unn",42))
type = c(type1,type2)
name = c("MA", "HC" )
Group = factor(type)
levels(Group) = c("MAun", "HCun")
conn = c(ma_un,hc_un)
conn_frame_un = data.frame(Group,conn,norm)
new = rbind(conn_frame, conn_frame_un )
ggplot(new, aes(x=Group, y=conn,  fill=Group)) + geom_boxplot() + labs(x="Groups", y="Mean Connectivity") + geom_point()

#Verteilung der Mittelwerte pro subject (norm)
ggplot(conn_frame, aes(x=label, y=conn,  fill=Group)) + geom_boxplot()+ labs(x="Groups", y="Mean Connectivity") + 
  geom_point() + ggtitle("Mean Connectivity (normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + 
  geom_point() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

#Verteilung der Mittelwerte pro subject (unnorm)
ggplot(conn_frame, aes(x=label, y=conn_un,  fill=Group)) + geom_boxplot()+ labs(x="Groups", y="Mean Connectivity") + 
  geom_point() + ggtitle("Mean Connectivity (normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + 
  geom_point() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


ggplot(conn_frame, aes(x=Group, y=conn,  fill=Group)) + geom_boxplot() + 
  labs(x="Groups", y="Mean Connectivity") + geom_point() + ggtitle("Mean Connectivity (normalisiert) \n für die Gruppen") + 
  theme (plot.title = element_text(color="red", size=14, face="bold.italic", hjust = 0.5)) + geom_point() 


#Lineares Modell mean connectivity/ lesion load 

lm(T_tuk~conn+age, data =CONNECT)

ggplot(CONNECT,aes(x=T_tuk,y=conn,label=group))+geom_point() + labs(x="Läsionsvolumen", y="Mean Connectivity norm") + 
  ggtitle("Mean Connectivity norm \n in Abhängigkeit zum Läsionsvolumen") +
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)  + geom_text()


#Lineares Modell mean connectivity/ lesion load (unnormalisiert)

lm(T_tuk~conn_un+age, data =CONNECT)

ggplot(CONNECT,aes(x=T_tuk,y=conn_un, label=group))+geom_point() + labs(x="Läsionsvolumen", y="Mean Connectivity unorm") + 
  ggtitle("Mean Connectivity unnorm \n in Abhängigkeit zum Läsionsvolumen") +
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)  + geom_text()


