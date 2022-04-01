#Normalverteilung
library(ggplot2)
dnorm(100,m=100,s=15)
x.val = seq (40,160,1)
sd.val = seq (40,160,14)
zeros9 = rep(0,9)

ggplot(NULL,aes(x=x.val, y= dnorm(x.val,m=100,s=15))) + 
  geom_line() + 
  labs(x="IQ", y="f(IQ)") +
  scale_x_continuous(breaks=sd.val,labels = sd.val)+
  geom_segment((aes(x=sd.val, y=zeros9,xend =sd.val,yend=dnorm(sd.val,m=100,s=15))),linetype ="dashed")+
  scale_y_continuous(expand = c(0,0))

#kumulierte Dichtefunktion
# Wahrscheinlichkeit von x kleiner 85
pnorm(85,m=100,s=15)
# Wahrscheinlichkeit, das Wert zwischen ober und Untergrenze liegt
library(tigerstats)
pnormGC(c(85,100), region ="between", m=100, sd=15, graph = TRUE)
#Verteilungsfunktion

ggplot(NULL,aes(x=x.val, y= pnorm(x.val,m=100,s=15))) + 
  geom_line() + 
  labs(x="IQ", y="FN(IQ)") +
  scale_x_continuous(breaks=sd.val,labels = sd.val)+
  geom_segment((aes(x=sd.val, y=zeros9,xend =sd.val,yend=pnorm(sd.val,m=100,s=15))),linetype ="dashed")+
  scale_y_continuous(expand = c(0,0))
#Quantile der Normalverteilung
qnormGC(.15, region = "below", m=100, sd=15, graph =TRUE)
#Standardnormalverteilung
z.val = seq(-4,4,.01)
z.sd.val = seq(-4,4,1)
ggplot(NULL,aes(x=z.val, y= dnorm(z.val))) + 
  geom_line() + 
  labs(x="z", y="f(z)") +
  scale_x_continuous(breaks=z.sd.val,labels = z.sd.val)+
  geom_segment((aes(x=z.sd.val, y=zeros9,xend =z.sd.val,yend=dnorm(z.sd.val))),linetype ="dashed")+
  scale_y_continuous(expand = c(0,0))
