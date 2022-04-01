library(MASS)
sum(Cars93$Origin == "USA")
sum(Cars93$Origin != "USA")

sum(Cars93$Origin == "USA" & Cars93$Cylinders == 8)
#or
with(Cars93, sum (Origin == "USA" & Cylinders == 8))
#or
Horsepower.USA.8 = Cars93$Horsepower[Origin == "USA" & Cylinders == 4]
length (Horsepower.USA.8)
# Maximum und Minimum
max (Horsepower.USA.8)
min(Horsepower.USA.8)