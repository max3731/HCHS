#empirische kumulative Verteilungsfunktion
CONNECT = read.csv("C:/Users/HP840-G1/Documents/CSI/R-Skripte/connectivity.csv")
library(ggplot2)
degree = quantile(CONNECT$degrees_wei)
ggplot(NULL, aes(x=CONNECT$degrees_wei)) +
  geom_step(stat="ecdf")+
  labs(x="degrees_weighted",y = "Fn(Anzahl)")+
  geom_vline(aes(xintercept=degree),linetype ="dashed")+
  scale_x_continuous(breaks = degree,labels= degree)