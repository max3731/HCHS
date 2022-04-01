setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

library(tidyverse) # data management
library(survival) # basic survival analysis
library(survminer) # nice survival graphics
library(Hmisc) # load spss data
library(cr17) # competing risks analysis
library(cmprsk) # cumulative incidence curve (competing risks)
library(mstate) # multi state modelling
library(sjPlot) # nice plot for e.g. Cox model output
library(rpact) # sample size calculation
library(ggplot2)
library(survminer)
library(readxl)
library(fitcox)


CONNECT = read.csv("C:/Users/mschu/Documents/Documents/CSI/CONNECT/analysis/csv_for_r/CONNECT_0.5_abs.csv")


addict = read_excel("C:/Users/mschu/Documents/Documents/CSI/Statistik/Exercise/Addict.xlsx")

addict <- addict[order(addict$survivalTime),] # sort after survival time


# load data (simulated film data)
dat <- spss.get("C:/Users/mschu/Documents/Documents/CSI/Statistik/Data_Code_R_SPSS/FilmData.sav", use.value.labels = FALSE,
                to.data.frame = TRUE)

# first observations of data set
head(dat)

head(addict)

# table with number of patients at risk, number of event times,
# survival probability (95% confidence interval)
fit0 <- survfit(Surv(eventTime, status) ~ 1, data = dat)

fit0_addict <- survfit(Surv(survivalTime , status) ~ clinic, data = addict)

plot(fit0_addict, conf.int=F, xlab="Time (days)",
     ylab="%in hospital = S(t)", main ="KM-Model", col=c("red","blue"),lwd=2, mark.time = TRUE)
abline(h=0.5, col="red")

# summary(fit0) ## uncomment to print
# for groupwise
fit <- survfit(Surv(eventTime, status) ~ group, data = dat)
 summary(fit)
 
 
fit_addict <- survfit(Surv(survivalTime, status) ~ clinic, data = addict)
 summary(fit_addict)

 # estimated median survival (25% & 75%)
 quantile(fit0)
 
 quantile(fit0_addict) 
 
 # survival probability at time point 2
 summary(fit0, times = 2)
 
 summary(fit0_addict, times = 2)
 
 # reverse Kaplan-Meier method
 fit0 <- survfit(Surv(survivalTime, status==0) ~ 1, data = dat)
 fit0
 
 
 fit0_addict <- survfit(Surv(survivalTime, status==0) ~ 1, data = addict)
 fit0_addict
 
 
 # plot
 ggsurv2 <- ggsurvplot(fit, data = dat, # basic plot
                       conf.int = TRUE, # with confidence interval
                       risk.table = TRUE, # with at risk table
                       # different variables to modify plot
                       risk.table.y.text.col = FALSE,
                       legend.title = "",
                       legend.labs = c("Adult\ndramatic films", "Children's\nanimated films"),
                       tables.y.text = TRUE,
                       risk.table.fontsize = 7,
                       palette = c("#E69F00", "#56B4E9"),
                       xlab = ("Time [hours]"),
                       ylab = c("\n\nSurvival probability (%)"),
                       break.time.by = 0.5,
                       xlim = c(0,3.1)) +
   theme_survminer(font.x = c(15, "bold", "black"),
                   font.y = c(15, "bold", "black"),
                   font.tickslab = c(14, "bold", "black"))
 # plot modification
 ggsurv2$plot <- ggsurv2$plot+
   scale_x_continuous(breaks = seq(0,3,0.5), limits = c(0,3), expand=c(0,0),
                      labels = function(x) sprintf("%.1f", x)) +
   scale_y_continuous(expand = c(0,0), labels = function(x) (x*100)) +
   theme_classic2() +
   ggtitle("Kaplan-Meier Estimate") +
   theme(panel.grid = element_blank() ,
         plot.title = element_text(size=20, hjust =0.5, face ="bold"),
         axis.title = element_text(size=15, face = "bold"),
         axis.text = element_text(size=15, face = "bold", colour = "black"),
         legend.position = c(0.25, 0.2),
         legend.text = element_text(size = 15, face = "bold"),
         plot.margin = unit(c(0, 9, 0, 0), "points") )
 # at riks table modification
 ggsurv2$table <- ggsurv2$table + theme_cleantable(base_size = 12,base_family = "bold")+
   scale_x_continuous(breaks = seq(0,3,0.5), limits = c(0,3))+
   theme(plot.title = element_text(hjust = -0.35, size=13, face="bold"),
         plot.margin = unit(c(0, 0, 0,0), "points"),
         axis.text.x.bottom = element_blank(),
         axis.ticks.x.bottom = element_blank(),
         legend.background = element_blank(),
         legend.title = element_text(face = "bold"))+
   xlab("")
 # print plot
 ggsurv2
 
 
 
 # plot
 ggsurv2 <- ggsurvplot(fit_addict, data = addict, # basic plot
                       conf.int = TRUE, # with confidence interval
                       risk.table = TRUE, # with at risk table
                       # different variables to modify plot
                       risk.table.y.text.col = FALSE,
                       legend.title = "",
                       legend.labs = c("Clinic1's\ndropouts", "Clinic2's\ndropouts"),
                       tables.y.text = TRUE,
                       mark.time=TRUE,
                       surv.median.line = "hv",
                       risk.table.fontsize = 7,
                       palette = c("#E69F00", "#56B4E9"),
                       xlab = ("Time [days]"),
                       ylab = c("\n\nTime in clinic probability (%)"),
                       break.time.by = 200,
                       xlim = c(0,1200)) +
   theme_survminer(font.x = c(15, "bold", "black"),
                   font.y = c(15, "bold", "black"),
                   font.tickslab = c(14, "bold", "black" ))
   xlab("")
 # print plot
 ggsurv2

 
 survdiff(Surv(survivalTime, status) ~ clinic, data = addict)
 
 # Cox proportional hazard model
 
 addict$prisonRecord = as.factor(addict$prisonRecord)
 
 
 #addict$clinic = as.factor(addict$clinic)
 
 summary(addict)
 
 fitCox <- coxph(Surv(survivalTime, status) ~ clinic + methodoneDose + prisonRecord  , data = addict)
 
 fitCox2 <- coxph(Surv(survivalTime, status) ~ clinic + methodoneDose   , data = addict)
 
 anova(fitCox, fitCox2, test = "LRT")
 summary(fitCox)
 
 plot_model(fitCox)+ # basic
   # additional information
   geom_hline(yintercept =1, linetype=2)+
   ggtitle("")+
   ylab("Hazard ratio")+
   annotate(geom = "text", x=2.3, y=20,
            label="Hazard ratio\n(95% CI)", fontface="bold", size=4)+
   annotate(geom = "text", x=2, y=20,
            label=paste0(formatC(exp(summary(fitCox)$coefficients[1,1]), format="f", digits=2),
                         " (",formatC(exp(confint(fitCox)[1,1]), format="f", digits=2),
                         ", ",formatC(exp(confint(fitCox)[1,2]), format="f", digits=2), ")"),
            fontface="bold", size=4)+
   annotate(geom = "text", x=1, y=20,
            label=paste0(formatC(exp(summary(fitCox)$coefficients[2,1]), format="f", digits=2),
                         " (",formatC(exp(confint(fitCox)[2,1]), format="f", digits=2),
                         ", ",formatC(exp(confint(fitCox)[2,2]), format="f", digits=2), ")"),
            fontface="bold", size=4)+
   # layout
   theme_classic()+theme(axis.line.y = element_blank(),
                         axis.text = element_text(size=10, face="bold"),
                         axis.title = element_text(size=11, face="bold"))
 
 
 # get residuals
 mred <- residuals(fitCox, type = "martingale")
 # data set to plot residuals
 fitRed <- tibble(survivalTime = addict$survivalTime, MResiduals = mred)
 # plot residuals
 ggplot(fitRed) + geom_point(aes(x = survivalTime, y = MResiduals)) + # basic plot
    stat_smooth(aes(x = survivalTime, y = MResiduals))+ # with line
    # plot modifications
    ggtitle("Martingale Residuals vs. Total Run Time")+
    ylab("Martingale residuals")+
    theme_classic()+
    theme(plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
          axis.title = element_text(size = 12, face = "bold"),
          axis.text = element_text(size = 12, face = "bold"))
 
 plot(predict(fitCox), residuals(fitCox, type = "martingale"),
      xlab = "fitted values", ylab = "Martingale residuals", 
      main= "Residual Plot", las=1)

     abline(h=0)
     
     lines(smooth.spline(predict(fitCox),
                         residuals(fitCox, type = "martingale")), col="red")
     
     
     # get residuals
     sred <- residuals(fitCox, type = "schoenfeld")
     # data set for plot
     fitRed <- tibble(survivalTime = as.numeric(row.names(sred)), SResiduals = sred[,1])
     # plot
     ggplot(fitRed) + geom_point(aes(x = survivalTime, y = SResiduals)) + # basic plot
        stat_smooth(aes(x = survivalTime, y = SResiduals))+ # with line
        # plot modifications
        ggtitle("Schoenfeld Residuals vs. Survival Time\nFilm Type")+
        xlab("Survival Time")+
        ylab("Schoenfeld residuals")+
        theme_classic()+
        theme(plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
              axis.title = element_text(size = 12, face = "bold"),
              axis.text = element_text(size = 12, face = "bold"))
     
     
     
     
     fitCoxStrata <- coxph(Surv(survivalTime, status) ~ strata(clinic) + methodoneDose, data = addict)
     plSurv <- summary(survfit(fitCoxStrata))
     fitRed <- tibble(Time = plSurv$time, lg = -log(-log(plSurv$surv)),
                      clinic = as.factor(c(rep(0, length(plSurv$time[plSurv$strata=="clinic=1"])),
                                          rep(1, length(plSurv$time[plSurv$strata=="clinic=2"])))))
     ggplot(fitRed) + geom_point(aes(x=Time, y=lg, shape=clinic), size=2) +
        ggtitle("Adjusted -log(-log(Survival))")+
        scale_shape_manual(name=" ", values = c(1,2),
                           labels=c("Clinic\n1", "Clinic\n2"))+
        xlab("Survival Time")+
        ylab("-log(-log(Survival))")+
        theme_classic()+ theme(plot.title = element_text(size=18, hjust =0.5, face ="bold"),
                               axis.title = element_text(size=15, face = "bold"),
                               axis.text = element_text(size=12, face = "bold"),
                               legend.position = c(0.85,0.9),
                               legend.text = element_text(size=12, face = "bold"))
     
     
     # Survival curves
     fit <- survfit(fitCox, newdata = addict)
     ggsurvplot(fit, conf.int = TRUE, legend.labs=c("clinic=1", "Clinic=2"),
                ggtheme = theme_minimal())
     
     # Plot the baseline survival function
     ggsurvplot(survfit(fitCox), color = "#2E9FDF",
                ggtheme = theme_minimal())