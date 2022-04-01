

setwd("C:/Users/HP840-G1/Documents/CSI/R-Skripte/")

CONNECT = read.csv("C:/Users/HP840-G1/Documents/CSI/R-Skripte/connectivity.csv")

#Kovarianz
 CONNECT_reg = lm(degrees_wei ~ group, data = CONNECT)
 summary(CONNECT_reg)

ggplot(CONNECT, aes(x=age, y=degrees_wei, shape = group)) + geom_point(size=2.5)
CONNECT_cov = lm(degrees_wei~group+age, data =CONNECT)
summary(CONNECT_cov)

# Drittvariablenkontrolle
anova(CONNECT_reg,CONNECT_cov)