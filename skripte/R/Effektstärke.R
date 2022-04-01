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


CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/connectivity_015.csv")


df <- data.frame(group = c(rep('ma',170), rep('hc', 190))
                 
                 , WMH = c(rnorm(170, 50, 10), rnorm(190, 50, 10))
                 
                 , age = c(rnorm(170, 65, 10), rnorm(190, 65, 10)))





str(df)



df %>%
  
  ggplot(aes(x = age, y = WMH, color = group))+
  
  geom_point()





conn <- function(WMH, age){
  
  4 - 0.01*WMH - 0.02*age + rnorm(1, 0, 0.5)
  
}





p.list <- c()

for (i in 1:200){
  
  df$conn = mapply(conn, df$WMH, df$age)
  
  m <- lm(conn ~ WMH, data = df)
  
  p <- summary(m)$coefficients['WMH', 'Pr(>|t|)']
  
  p.list[i] <- p
  
}



hist(p.list)
plot(ecdf(p.list))

predict(fit_1, data.frame(Girth = 18.2))
predict(CONNECT_cov, degrees_wei  = 18 )