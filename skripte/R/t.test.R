setwd("C:/Users/HP840-G1/Documents/CSI/R-Skripte/")

#t-test, mittelwert größer 4?
daten_vec = c(3,6,9,9,10,4,12)
t.test(daten_vec,mu=4,alternative ="greater")