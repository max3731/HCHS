
setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_05.csv")


library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)

#just for fun
CONNECT_cov = lm(degrees_wei~mod+betw, data =CONNECT)

x= with (CONNECT, (scatterplot3d(eff_global~mod+betw,type = "h", pch =19)))
x$plane3d(CONNECT_cov,lty="dashed")

# 3d Bild der Regression
scatter3d(eff_global~mod+betw, data = CONNECT)



#Kovarianz
 CONNECT_reg = lm(degrees_wei ~ group, data = CONNECT)
 summary(CONNECT_reg)

ggplot(CONNECT, aes(x=age, y=degrees_wei, shape = group)) + geom_point(size=2.5)
ggplot(CONNECT, aes(x=age, y=degrees_wei, shape = group)) + geom_point(size=2.5)+geom_smooth(method = lm,se = FALSE, aes(linetype=group))
     

for (i in c("degrees_wei","eff_global","char_path","mod","eff_local","betw","clust_coef", "DemTecT", "CDT", "FWT_III")){


CONNECT_cov = lm(as.formula(paste(i,"~log(ratio+0.01)+sex+age")), data =CONNECT)
#print(summary(CONNECT_cov$coefficients)[,4])
i=(summary(CONNECT_cov))
print(i$coefficients[,4])
f = summary(CONNECT_cov)$fstatistic
p = pf(f[1],f[2],f[3],lower.tail=F)
print(p)
}

ggplot(CONNECT,aes(x=ratio, y=DemTecT)) + geom_point()+ geom_smooth(method=lm)

# Drittvariablenkontrolle
anova(CONNECT_reg,CONNECT_cov)
ggplot(CONNECT, aes(x=age, y=degrees_wei, shape = group)) + geom_point(size=2.5)+geom_smooth(method = lm,se = FALSE, aes(linetype=group))
anova(CONNECT_cov, CONNECT_wechsel)