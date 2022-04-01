data(airquality)
names(airquality)

#[1] "Ozone"   "Solar.R" "Wind"    "Temp"    "Month"   "Day" 

plot(Ozone~Solar.R, data=airquality)

#calculating mean ozone concentration (na's removed)

mean.ozone=mean(airquality$Ozone, na.rm=TRUE)

abline(h=mean.ozone)

#use lm to fit a regression line through these data:

model1=lm(Ozone~Solar.R,data=airquality)

abline(model1,col="red")

plot(model1)

termplot(model1)

summary(model1)
 
