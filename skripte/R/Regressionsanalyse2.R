setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_bast.csv")


HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_conn.csv")


CONNECT = read.xlsx("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/Review_gl_sub_versuch.xlsx")
library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)



plotNormalHistogram(CONNECT$ratio)

ggplot(CONNECT,aes(x=ratio,y=FWT_III))+geom_point()+geom_smooth(method=lm)

T_tuk = transformTukey(CONNECT$ratio, plotit=FALSE)
rat=CONNECT$ratio^0.25

plotNormalHistogram(rat)
plotNormalHistogram(T_tuk)

#Faktorisieren
gender = factor(CONNECT$sex)
class(gender)

g = factor(CONNECT$group)


ggplot(CONNECT_cov,aes(x=rat,y=FWT_III))+geom_point()+geom_smooth(method=lm)
ggplot(CONNECT,aes(x=degrees_wei,y=FWT_III))+geom_point()+geom_smooth(method=lm)

#Farbwechseltest 
ggplot(CONNECT,aes(x=T_tuk,y=FWT_III))+geom_point() + labs(x="Läsionsvolumen", y="Farbwechseltest III") + ggtitle("Farbwechseltest III \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm) 

#CDT
ggplot(CONNECT,aes(x=T_tuk,y=CDT))+geom_point() + labs(x="Läsionsvolumen", y="CDT") + ggtitle("CDT \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)

#Globale Effizienz
ggplot(CONNECT,aes(x=T_tuk,y=eff_global))+geom_point() + labs(x="Läsionsvolumen", y="Globale Effizienz") + ggtitle("Globale Effizienz \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)


#Clustering
ggplot(CONNECT,aes(x=T_tuk,y=clust_coef))+geom_point() + labs(x="Läsionsvolumen", y="Clustering") + ggtitle("Clustering \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)

#Lokale Effizienz
ggplot(CONNECT,aes(x=T_tuk,y=eff_local))+geom_point() + labs(x="Läsionsvolumen", y="Lokale Effizienz") + ggtitle("Lokale Effizienz \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)

#Degree
ggplot(CONNECT,aes(x=T_tuk,y=degrees_wei))+geom_point() + labs(x="Läsionsvolumen", y="Degree") + ggtitle("Degree \n in Abhängigkeit zum Läsionsvolumen") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +geom_smooth(method=lm)

ggplot(CONNECT,aes(x=ratio, y=ID, label=group)) + labs(x="Läsionsvolumen", y="Gruppe") + ggtitle("Läsionsvolumen \n ") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5))  + geom_text() + geom_point()
ggplot(CONNECT,aes(x=ratio, y=ID, label=group))+ labs(x="Läsionsvolumen", y="Gruppe") + ggtitle("Läsionsvolumen \n ") + theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5))  + geom_point()




for (i in c("degrees_wei","eff_global","char_path","mod","eff_local","betw","clust_coef", "DemTecT", "CDT","FWT_III", "type", "conn")){
  
  
  CONNECT_cov = lm(as.formula(paste(i,"~T_tuk+age")), data =CONNECT)
  
  ggplot(CONNECT_cov, aes(x=fitted(CONNECT_cov), y=residuals(CONNECT_cov))) + 
    geom_point() + geom_hline(yintercept = 0, linetype = "dashed")
  print(i)
  print(summary(CONNECT_cov))
  
  print(summary(CONNECT_cov$coefficients)[4])
  i=(summary(CONNECT_cov))
  print(i$coefficients[4])
  f = summary(CONNECT_cov)$fstatistic
 p = pf(f[1],f[2],f[3],lower.tail=F)
  print(p)
  plot(fitted(CONNECT_cov),residuals(CONNECT_cov)) + abline(h = 0, col="red", lwd=3, lty=2)
  hist(residuals(CONNECT_cov))
  qqnorm(residuals(CONNECT_cov))

} 


ggplot(CONNECT_cov, aes(x=fitted(CONNECT_cov), y=residuals(CONNECT_cov))) + 
  geom_point() + geom_hline(yintercept = 0, linetype = "dashed")

type1 = c(rep(1,17))
type2 = c(rep(2,25))
type = c(type1,type2)
