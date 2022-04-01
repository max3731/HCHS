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
library(Hmisc)

CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_015.csv")

#Zusammenfassung
summary(CONNECT)
describe.data.frame(CONNECT)
datadensity(CONNECT$age)

#Häufigkeit
g=table(CONNECT$group)
#Häufigkeitswahrscheinlichkeit
prop.table(g)
#addierte Häufigkeit
margin.table(g)
#komulierte Häufigkeit
cumsum(CONNECT$CDT)
#emperical cumulative distribution function 
ggplot(NULL, aes(x=CONNECT$age)) + geom_step(stat="ecdf") 
