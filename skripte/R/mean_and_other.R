setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_bast.csv")

CONNECT = read.xlsx("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/Review_gl_sub_versuch.xlsx")
library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)

#Mittelwert
with(CONNECT, mean(char_path[group == "hc_o"]))

with(CONNECT, mean(char_path[group == "CONNECT_ma"]))
#or
mean(CONNECT$char_path[CONNECT$group == "CONNECT_ma"])

#Median
with(CONNECT, median(char_path[group == "hc_o"]))

#Modelwert (Wert der am häufigsten vorkommt)
with(CONNECT, mfv(char_path[group == "hc_o"]))

#oberen 5 % entfernen
with(CONNECT, mean(char_path[group == "CONNECT_ma"], trim=0.5))

#Verteilung bei Alter (verhältnisskaliert)
ggplot(CONNECT, aes(x=age)) + geom_histogram(color="black", fill="blue", binwidth=10) + facet_wrap(~group)

ggplot(CONNECT, aes(x=age)) + geom_density(color="black", fill="blue", binwidth=10) + facet_wrap(~group)

# komulierte Verteilung 
plot(ecdf(CONNECT$ratio))
