# Standadisieren (Z-Wert)

library(MASS)
PS.USA.8 = with(Cars93, Horsepower [Origin == "USA" & Cylinders == 8])
scale(PS.USA.8)
#letzter Wert ist s ( für Grundgesamtheit jes Elemt des Vektors durch die Quadratwurzel von (N-1)/N)
N = length (PS.USA.8)
scale(PS.USA.8)/sqrt((N-1)/N)
# Rang ermitteln
rank(PS.USA.8)
sort(PS.USA.8)
sort(PS.USA.8)[2]
# Quantile
sort(PS.USA.8)
quantile(PS.USA.8,type = 6)
# spezifische Quantile
quantile(PS.USA.8, c(.54,.68,.91))
#andere
fivenum(PS.USA.8)
summary(PS.USA.8)
