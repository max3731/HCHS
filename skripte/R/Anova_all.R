## ANOVA

analysis = aov(Abhängige ~ Unabhängige, data = data.frame)

summary(analysis)

## ANOVA mit Kontrasten

ANOVA.w.Contrasts = aov(abhängige ~ Unabhängige, data = data.frame, contrasts = contrasts(data.frame$Abhängige))

## nicht geplante Vergleiche

TukeyHSD(analysis)

## wiederholte Messungen 

unabh.anova = aov(Gewicht ~ Zeit + Error(Person/Zeit), data = data.frame) # Verschiedene Zeitpunkte der Wiederholung in Datensatz unter Spalte Zeit untereinander auflisten

## Trendanalyse

contrasts(Gewicht,frame.melt$Zeit) = matrix(c(-3,-1,1,3,1,-1,-1,1,-1,3,-3,1),4,3)

rm.anova = aov(Gewicht ~ Zeit + Error(factor(Person)/Zeit) data = Gewicht.frame.melt, contrasts = contrasts(Gewicht-frame-melt$Zeit))

## Zweifaktorielle Varianzanalyse (ANOVA mit zwei Zwischengruppenvariablen)

zwei.wege = aov(Score ~ Stil*Methode, data = präs.frame)

## Gemischte ANOVA 

mixed.anova = aov(Score ~ Medium*Font + Error(Subject/FOnt), data=mixed.frame)

## MANOVA

m.analyse = manova(cbind(Physik,Chemie,Biologie) ~ Buch, data = Fachbuch.frame)