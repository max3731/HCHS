
setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")


#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/without_age/HCHS_conn_0_aroma.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.7_aroma_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/36/HCHS_conn_0.5_36_abs.csv")
HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_abs.csv")
T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
HCHS["T_tuk"] <- T_tuk

library(tidyverse)
library(fs)
library(ggplot2)
library(corrplot)
library(ggsci)


library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)



measures_a=c(HCHS$mean_default_all, HCHS$default_dorsal_all,HCHS$default_salven_all, HCHS$default_sommot_all, HCHS$default_cont_all, HCHS$default_vis_all,HCHS$default_limb_all ,HCHS$default_dorsal_all,HCHS$mean_dorsal_all, HCHS$dorsal_salven_all,
            HCHS$dorsal_sommot_all , HCHS$dorsal_cont_all, HCHS$dorsal_vis_all , HCHS$dorsal_limb_all ,HCHS$default_salven_all,HCHS$dorsal_salven_all, HCHS$mean_salven_all,HCHS$salven_sommot_all , HCHS$salven_cont_all , HCHS$salven_vis_all , HCHS$salven_limb_all,
            HCHS$default_sommot_all,HCHS$dorsal_sommot_all , HCHS$salven_sommot_all,HCHS$mean_sommon_all,HCHS$sommot_cont_all ,
            HCHS$sommot_vis_all , HCHS$sommot_limb_all,HCHS$default_cont_all,HCHS$dorsal_cont_all, HCHS$salven_cont_all,HCHS$sommot_cont_all,HCHS$mean_cont_all,HCHS$cont_vis_all, HCHS$cont_limb_all, 
            HCHS$default_vis_all,HCHS$dorsal_vis_all,HCHS$salven_vis_all,HCHS$sommot_vis_all,HCHS$cont_vis_all,HCHS$mean_vis_all,HCHS$vis_limb_all,HCHS$default_limb_all, HCHS$dorsal_limb_all,HCHS$salven_limb_all,
            HCHS$sommot_limb_all,HCHS$cont_limb_all,HCHS$vis_limb_all,HCHS$mean_limb_all)

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_pval_abs.csv")


measures_pval =c(HCHS$mean_default_all, HCHS$default_dorsal_all,HCHS$default_salven_all, HCHS$default_sommot_all, HCHS$default_cont_all, HCHS$default_vis_all,HCHS$default_limb_all ,HCHS$default_dorsal_all,HCHS$mean_dorsal_all, HCHS$dorsal_salven_all,
            HCHS$dorsal_sommot_all , HCHS$dorsal_cont_all, HCHS$dorsal_vis_all , HCHS$dorsal_limb_all ,HCHS$default_salven_all,HCHS$dorsal_salven_all, HCHS$mean_salven_all,HCHS$salven_sommot_all , HCHS$salven_cont_all , HCHS$salven_vis_all , HCHS$salven_limb_all,
            HCHS$default_sommot_all,HCHS$dorsal_sommot_all , HCHS$salven_sommot_all,HCHS$mean_sommon_all,HCHS$sommot_cont_all ,
            HCHS$sommot_vis_all , HCHS$sommot_limb_all,HCHS$default_cont_all,HCHS$dorsal_cont_all, HCHS$salven_cont_all,HCHS$sommot_cont_all,HCHS$mean_cont_all,HCHS$cont_vis_all, HCHS$cont_limb_all, 
            HCHS$default_vis_all,HCHS$dorsal_vis_all,HCHS$salven_vis_all,HCHS$sommot_vis_all,HCHS$cont_vis_all,HCHS$mean_vis_all,HCHS$vis_limb_all,HCHS$default_limb_all, HCHS$dorsal_limb_all,HCHS$salven_limb_all,
            HCHS$sommot_limb_all,HCHS$cont_limb_all,HCHS$vis_limb_all,HCHS$mean_limb_all)


HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_gsr_abs.csv")


measures_gsr =c(HCHS$mean_default_all, HCHS$default_dorsal_all,HCHS$default_salven_all, HCHS$default_sommot_all, HCHS$default_cont_all, HCHS$default_vis_all,HCHS$default_limb_all ,HCHS$default_dorsal_all,HCHS$mean_dorsal_all, HCHS$dorsal_salven_all,
                 HCHS$dorsal_sommot_all , HCHS$dorsal_cont_all, HCHS$dorsal_vis_all , HCHS$dorsal_limb_all ,HCHS$default_salven_all,HCHS$dorsal_salven_all, HCHS$mean_salven_all,HCHS$salven_sommot_all , HCHS$salven_cont_all , HCHS$salven_vis_all , HCHS$salven_limb_all,
                 HCHS$default_sommot_all,HCHS$dorsal_sommot_all , HCHS$salven_sommot_all,HCHS$mean_sommon_all,HCHS$sommot_cont_all ,
                 HCHS$sommot_vis_all , HCHS$sommot_limb_all,HCHS$default_cont_all,HCHS$dorsal_cont_all, HCHS$salven_cont_all,HCHS$sommot_cont_all,HCHS$mean_cont_all,HCHS$cont_vis_all, HCHS$cont_limb_all, 
                 HCHS$default_vis_all,HCHS$dorsal_vis_all,HCHS$salven_vis_all,HCHS$sommot_vis_all,HCHS$cont_vis_all,HCHS$mean_vis_all,HCHS$vis_limb_all,HCHS$default_limb_all, HCHS$dorsal_limb_all,HCHS$salven_limb_all,
                 HCHS$sommot_limb_all,HCHS$cont_limb_all,HCHS$vis_limb_all,HCHS$mean_limb_all)

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/36/HCHS_conn_0.5_36_abs.csv")

measures_36p = c(HCHS$mean_default_all, HCHS$default_dorsal_all,HCHS$default_salven_all, HCHS$default_sommot_all, HCHS$default_cont_all, HCHS$default_vis_all,HCHS$default_limb_all ,HCHS$default_dorsal_all,HCHS$mean_dorsal_all, HCHS$dorsal_salven_all,
                 HCHS$dorsal_sommot_all , HCHS$dorsal_cont_all, HCHS$dorsal_vis_all , HCHS$dorsal_limb_all ,HCHS$default_salven_all,HCHS$dorsal_salven_all, HCHS$mean_salven_all,HCHS$salven_sommot_all , HCHS$salven_cont_all , HCHS$salven_vis_all , HCHS$salven_limb_all,
                 HCHS$default_sommot_all,HCHS$dorsal_sommot_all , HCHS$salven_sommot_all,HCHS$mean_sommon_all,HCHS$sommot_cont_all ,
                 HCHS$sommot_vis_all , HCHS$sommot_limb_all,HCHS$default_cont_all,HCHS$dorsal_cont_all, HCHS$salven_cont_all,HCHS$sommot_cont_all,HCHS$mean_cont_all,HCHS$cont_vis_all, HCHS$cont_limb_all, 
                 HCHS$default_vis_all,HCHS$dorsal_vis_all,HCHS$salven_vis_all,HCHS$sommot_vis_all,HCHS$cont_vis_all,HCHS$mean_vis_all,HCHS$vis_limb_all,HCHS$default_limb_all, HCHS$dorsal_limb_all,HCHS$salven_limb_all,
                 HCHS$sommot_limb_all,HCHS$cont_limb_all,HCHS$vis_limb_all,HCHS$mean_limb_all)

                  T_tuk_36 = transformTukey(HCHS$ratio, plotit=FALSE)
                  HCHS["T_tuk_36"] <- T_tuk_36


                  
networks = c("Default","Dorsal","Salven","Sommot","Cont","Vis","Limb")
                  
                  
                  
nS_36 = 926; nC <- 7; nM_36 <- 1; nA_36 = 6482
methods_36p = c("36p")



networks_all1_36=rep(networks[1:nC], each = nA_36)
networks_all2_36=rep(networks[1:nC], each = nS_36)
networks_all2_36=rep(networks_all2_36,7)
T_tuk_all_36 = rep(T_tuk_36,49)
measure_36=rep(methods_36p,times=c(length(networks_all1_36)))



nS = 927; nC <- 7; nM <- 3; nA = 6489



methods = c("aroma","aroma_pval","aroma_gsr")
labels = c("default","dorsal","salven", "sommot","cont","vis","limb")

networks_all1=rep(networks[1:nC], each = nA)
networks_all2=rep(networks[1:nC], each = nS)
networks_all2=rep(networks_all2,7)
   T_tuk_all = rep(T_tuk,times=c(length(networks_all1)))
   measure=rep(methods_36p,times=c(length(networks_all1)))
   
   networks_all1 = rep(networks_all1,3)
   networks_all2 =rep(networks_all2,3)

HCHS_grid_lin <- data.frame(Control1 =c(networks_all1,networks_all1_36),
                            Control2 =c(networks_all2,networks_all2_36),
                        T_tuk = c(T_tuk_all,T_tuk_all_36),
                        methods = c(measure,measure_36),
                       value = c(measures_a,measures_pval,measures_gsr,measures_36p))




HCHS_grid_lin = ggplot(HCHS_grid_lin,aes(x=T_tuk,y=value,shape=methods)) +
  labs(x="Lesion Volume", y="Change of Connectivity") + 
  ggtitle("Mean Connectivity \n in dependence from Lesion Volume") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm) + stat_smooth(aes(colour=factor(methods)),method="lm",se = FALSE) + 
  scale_colour_manual(values = c("red","green", "orange","blue")) 




HCHS_grid_lin + facet_grid(Control1 ~ Control2)




#HCHS_2=data.frame(names,network)






n=c()
p <- ggplot(HCHS, aes(mpg, wt)) + geom_point()
# With one variable
p + facet_grid(. ~ cyl)


T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
HCHS["T_tuk"] <- T_tuk


ToothGrowth$dose <- as.factor(ToothGrowth$dose)
df <- ToothGrowth
head(df)



bp <- ggplot(HCHS_2, aes(x=HCHS$ratio, y=s, group=names)) + 
  geom_boxplot(aes(fill=names))

library(ggplot2)
bp <-  ggplot(HCHS_2[T_tuk > 0.1, ],aes(x=T_tuk[T_tuk > 0.1],y=ss))+geom_point() + 
  labs(x="Läsionsvolumen", y="Mittlere Konnektivität") + 
  ggtitle("Mittlere Konnektivität \n in Abhängigkeit zum Läsionsvolumen") + 
  theme (plot.title = element_text(color="royalblue4", size=14, face="bold.italic", hjust = 0.5)) +
  geom_smooth(method=lm)
bp

# Split in vertical direction
bp + facet_grid(ratio ~ .)
# Split in horizontal direction
bp + facet_grid(. ~ supp)

bp + facet_grid(dose ~ supp)
# Facet by two variables: reverse the order of the 2 variables
# Rows are supp and columns are dose
bp + facet_grid(supp ~ dose)


schaefer200x7 <- read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/schaefer200x7NodeNames.txt", header = FALSE, stringsAsFactors = FALSE)$V1
networks <- str_match(schaefer200x7, "_\\s*(.*?)\\s*_")[,2]

## aroma_pval_0.5

default = c( 0.0381834, -0.0181419, 0.0115915, 0.0147365, 0.0485567, 0.0306697)

dorsal = c( -0.1937459, -0.1332731, -0.0506045, -1.652e-01 ,0.0047273 )

salven = c(-2.199e-01, -0.0407538 ,-0.1007712 ,3.031e-02)

sommot = c(1.851e-02, -6.058e-02 ,4.572e-02)

cont =c ( 0.0022631 ,0.0095400 )

vis =c ( 0.0439945  )

single = c(-0.09360879, -0.2225132,-0.2225802, -0.2430612, -0.106026 ,-0.1853318,0.0001302753    )

network = c(single,default,dorsal,salven,sommot,cont,vis)


## aroma_gsr_0.5

default2 = c( -0.0887273, -0.0650156, 1.987e-03,-0.0158405, -1.284e-02, 3.324e-02)

dorsal2 = c( -0.0377515, -0.0235887, -0.0370657, -0.0413798 ,0.0280060 )

salven2 = c(-8.435e-02,-0.0098169 ,0.0095864 ,4.574e-02)

sommot2 = c(-0.0083818, -1.570e-02 ,6.015e-02)

cont2 =c ( -0.0452587 , 3.278e-02 )

vis2 =c ( 3.091e-02)

single2 = c(-0.0988749, -0.1504479 ,-0.146558 , -0.1715399 , -0.1271713 ,-0.1473086 ,0.0001372735  )


network2 = c(single2,default2,dorsal2,salven2,sommot2,cont2,vis2)


## 36p_0.5

default3 = c( -0.0766035, -0.0736714, 0.0610703, 0.0019545, -0.0152523, 3.444e-02)

dorsal3 = c( -1.520e-02, 0.1213105, 3.378e-02,0.0046531 ,0.0306012)

salven3 = c(0.0226958,5.545e-03 ,3.357e-02 ,2.347e-02)

sommot3 = c(0.0585422, 0.0386643 ,0.0399174)

cont3 =c ( 6.557e-03 , 2.364e-02 )

vis3 =c ( 0.0415331)

single3 = c(-0.0290332, -0.0031989 ,-0.0646507 , 0.0487428 , -0.0264390 ,-0.0461524 ,0.0720831   )


network3 = c(single3,default3,dorsal3,salven3,sommot3,cont3,vis3)


## aroma

default4 = c( 0.0388630, -0.0176641 ,0.0123051 ,0.0149963, 0.0491632, 0.0309616)

dorsal4 = c(-0.1931864, -0.1328464, -0.0498359, -1.644e-01 ,0.0055009)

salven4 = c(-2.192e-01 ,-0.0401194, -0.0999370 ,3.094e-02)

sommot4 = c(1.909e-02 ,-6.008e-02 ,4.607e-02 )

cont4 = c( 0.0027517, 0.0102397)

vis4 = c( 0.0447968)

single4 = c(-0.0944133, -0.2235891  ,-0.2248748  , -0.2442717 ,-0.1081919 ,-0.1869531  ,0.0134798   )

network4 = c(single4,default4,dorsal4,salven4,sommot4,cont4,vis4)



names_all=c(names,names,names,names)

Change_of_Connectivity = c(network,network2,network3,network4)

                                                      

n <- 28
aroma_pval <- rep("aroma_pval", n)

n <- 28
aroma_gsr <- rep("aroma_gsr", n)

n <- 28
p36 <- rep("36p", n)

n <- 28
aroma <- rep("aroma", n)





method=c(aroma_pval,aroma_gsr,p36,aroma)

HCHS_2=data.frame(method,names_all,Change_of_Connectivity )

HCHS_2$names_all <- factor(HCHS_2$names_all, levels = names)

bp =ggplot(HCHS_2,aes(x=method, y=Change_of_Connectivity, fill=method))+ geom_bar(stat = "identity", width = 0.25) +theme_minimal()



bp + facet_wrap( ~ names_all)


#aroma

default4 = c(-0.0944133, 0.0388630, -0.0176641, 0.0123051 ,0.0149963, 0.0491632 ,0.0309616)

dorsal4 = c(0.0388630, -0.2235891, -0.1931864, -0.1328464, -0.0498359 ,-1.644e-01, 0.0055009)

salven4 = c(-0.0176641, -0.1931864, -0.2248748 , -2.192e-01, -0.0401194, -0.0999370, 3.094e-02)

sommot4 = c(0.0123051, -0.1328464, -2.192e-01, -0.2442717,1.909e-02, -6.008e-02, 4.607e-02 )

cont4 = c(0.0149963, -0.0498359 ,-0.0401194, 1.909e-02 ,-0.1081919,0.0027517 ,0.0102397)

vis4 = c(0.0491632, -1.644e-01, -0.0999370, -6.008e-02, 0.0027517, -0.1869531, 0.0447968)

limb4  = c(0.0309616, 0.0055009, 3.094e-02 ,4.607e-02, 0.0102397 ,0.0447968 , 0.0134798)



network4 = c(default4,dorsal4,salven4,sommot4,cont4,vis4,limb4)



## aroma_pval_0.5

default = c( -0.09360879, 0.0381834, -0.0181419, 0.0115915, 0.0147365, 0.0485567, 0.0306697)

dorsal = c(0.0381834, -0.2225132, -0.1937459, -0.1332731, -0.0506045, -1.652e-01 ,0.0047273 )

salven = c(-0.0181419, -0.1937459, -0.2225802, -2.199e-01, -0.0407538 ,-0.1007712 ,3.031e-02)

sommot = c(0.0115915, -0.1332731, -2.199e-01, -0.2430612, 1.851e-02, -6.058e-02 ,4.572e-02)

cont =c (0.0147365, -0.0506045 ,-0.0407538, 1.851e-02,  -0.106026, 0.0022631 ,0.0095400 )

vis =c (0.0485567, -1.652e-01 ,-0.1007712 ,-6.058e-02, 0.0022631, -0.1853318, 0.0439945  )

limb  = c(0.0306697, 0.0047273, 3.031e-020 ,4.572e-02 ,0.0095400  ,0.0439945 ,0.0001302753)




network = c(default,dorsal,salven,sommot,cont,vis,limb)


## aroma_gsr_0.5

default2 = c(-0.0988749,-0.0887273, -0.0650156 ,1.987e-03 ,-0.0158405, -1.284e-02, 3.324e-02)

dorsal2 = c(-0.0887273,  -0.1504479, -0.0377515 ,-0.0235887 ,-0.0370657 ,-0.0413798 ,0.0280060)

salven2 = c(-0.06501561, -0.0377515 ,-0.146558 ,-8.435e-02, -0.0098169, 0.0095864, 4.574e-02)

sommot2 = c(1.987e-03, -0.0235887 ,-8.435e-02,  -0.1715399, -0.0083818, -1.570e-02 ,6.015e-02)

cont2 = c(-0.0158405, -0.0370657 ,-0.0098169 ,-0.0083818, -0.1271713  ,-0.0452587, 3.278e-02)

vis2 = c(-1.284e-02 ,-0.0413798, 0.0095864 ,-1.570e-02, -0.0452587,-0.1473086, 3.091e-02)

limb2  = c( 3.324e-02, 0.0280060 ,4.574e-02, 6.015e-02 ,3.278e-02,  3.091e-02, 0.0001372735)




network2 = c(default2,dorsal2,salven2,sommot2,cont2,vis2,limb2)

##36p

default3 = c(-0.0290332,-0.0766035, -0.0736714 ,0.0610703 ,0.0019545 ,-0.0152523 ,3.444e-02)

dorsal3 = c(-0.0766035 ,-0.0031989 ,-1.520e-02 ,0.1213105 ,3.378e-02,  0.0046531, 0.0306012)

salven3 = c(-0.0736714, -1.520e-02 ,-0.0646507 ,0.0226958, 5.545e-03 ,3.357e-02 ,2.347e-02)

sommot3 = c(0.0610703 ,0.1213105 ,0.0226958,  0.0487428 , 0.0585422 , 0.0386643 ,0.0399174)

cont3 = c(0.0019545, 3.378e-02 ,5.545e-03, 0.0585422 ,-0.0264390, 6.557e-03 ,2.364e-02)

vis3 = c(-0.0152523, 0.0046531, 3.357e-02 ,0.0386643, 6.557e-03, -0.046152, 0.0415331 )

limb3  = c(3.444e-02, 0.0306012, 2.347e-02, 0.0399174, 2.364e-02, 0.0415331 , 0.0720831)


network3 = c(default3,dorsal3,salven3,sommot3,cont3,vis3,limb3)

Change_of_Connectivity = c(network4,network,network2,network3)


#aroma

default_a = c(0.03266957, 0.01961809 , 0.02123069,0.02391316,0.02311408,0.02370951,0.02304550)

dorsal_a = c( 0.01961809 , 0.04759427, 0.05269303,0.04586232, 0.03516554,  0.05161848,0.02605715 )

salven_a = c(0.02123069, 0.05269303, 0.05283210 , 0.05956955,0.03175230, 0.04588351,0.02537992)

sommot_a = c(0.02391316, 0.04586232, 0.05956955, 0.05493912, 0.02508463, 0.03890790, 0.02351601 )

cont_a = c(0.02311408,0.03516554 ,0.03175230, 0.02508463 ,0.04886566,0.02956369,  0.02146757)

vis_a = c(0.02370951,0.05161848, 0.04588351, 0.03890790, 0.02956369,   0.06123019 ,0.02800686)

limb_a  = c(0.02304550, 0.02605715,0.02537992,0.02351601,0.02146757 ,0.02800686 , 0.03712723 )

network_a = c(default_a,dorsal_a,salven_a,sommot_a,cont_a,vis_a,limb_a)



## aroma_pval_0.5

default_pval =c(0.03229561, 0.01972028,0.02136619 ,0.02400058, 0.02327090, 0.02376682,0.02310726 )

dorsal_pval = c(0.01972028 ,0.04713490,0.05294116,0.04607530 ,0.03538948 , 0.05185786,0.02615587 )

salven_pval = c(0.02136619,0.05294116, 0.05237748,0.05978085,0.03198331,0.04605241 ,0.02546946 )

sommot_pval = c(0.02400058,0.04607530,0.05978085,0.05458135, 0.02524354 , 0.03904398 ,0.02355206 )

cont_pval =c (0.02327090, 0.03538948 ,0.03198331,0.02524354, 0.04843191,0.02970347 ,  0.02154961 )

vis_pval =c (0.02376682, 0.05185786 ,0.04605241 ,0.03904398, 0.02970347, 0.06087024, 0.02803594  )

limb_pval  = c(0.02310726, 0.02615587, 0.02546946 ,0.02355206, 0.02970347  ,0.02970347 ,0.03682768)




network_pval = c(default_pval,dorsal_pval,salven_pval,sommot_pval,cont_pval,vis_pval,limb_pval)



## aroma_gsr_0.5


default_gsr =c(0.02916820,         0.02813223,         0.02754633,         0.01689809,         0.01689285,         0.02869225 ,        0.01473404 )

dorsal_gsr = c(0.02813223 ,        0.03556432,         0.02502508,        0.02318100 ,        0.01978075 ,        0.02426693  ,       0.01544273 )

salven_gsr = c(0.02754633 ,        0.02502508,         0.03794872,         0.03087356,         0.01908152,         0.02058088 ,        0.01613873)

sommot_gsr= c(0.01689809 ,        0.02318100,          0.03087356,       0.04141492,        0.01737632 ,        0.02169086  ,       0.01452985 )

cont_gsr =c ( 0.01689285 ,         0.01978075,         0.01908152,        0.01737632  ,       0.04109964  ,       0.02146007  ,       0.01342509 )

vis_gsr =c (0.02869225,            0.02426693,         0.02058088,          0.02169086 ,      0.02146007,          0.04921322 ,        0.01789707 )

limb_gsr = c( 0.01473404  ,       0.01544273,         0.01613873 ,        0.01452985,        0.01342509,         0.01789707 ,         0.02841848)


network_gsr = c(default_gsr,dorsal_gsr,salven_gsr,sommot_gsr,cont_gsr,vis_gsr,limb_gsr)




## 36P

default_36p =c(0.02737752,         0.02859892,         0.02699801,         0.02171142,         0.01512215,         0.02723818,         0.01380762 )

dorsal_36p = c(0.02859892,         0.03485262,         0.02735879,         0.03036421,         0.02166711,         0.02831179,         0.01885161)

salven_36p = c(0.02699801,         0.02735879,         0.03314610,         0.03005899 ,        0.01891312 ,        0.02250103 ,        0.01758764 )

sommot_36p = c(0.02171142 ,        0.03036421,         0.03005899,         0.03854712,         0.01987309 ,        0.02453822,         0.01641454)

cont_36p =c(0.01512215  ,          0.02166711,        0.01891312 ,         0.01987309 ,        0.03953128  ,       0.02060578 ,        0.01428757  )

vis_36p =c (0.02723818  ,          0.02831179,         0.02250103,          0.02453822 ,       0.02060578 ,        0.04024686 ,        0.02146984 )

limb_36p  = c(0.01380762  ,        0.01885161,        0.01758764 ,          0.01641454 ,       0.01428757 ,        0.02146984,         0.03049468 )



network_36p = c(default_36p,dorsal_36p,salven_36p,sommot_36p,cont_36p,vis_36p,limb_36p)


Std_error = c(network_a,network_pval,network_gsr,network_36p)

nC <- 7; nM <- 4; nA = 49

networks = c("Default","Dorsal","Salven","Sommot","Cont","Vis","Limb")
methods = c("aroma","aroma_pval","aroma_gsr","36p")
labels = c("default","dorsal","salven", "sommot","cont","vis","limb")

HCHS_grid <- data.frame(Control1 = rep(networks[1:nC], each = nC),
                  Control2 = rep(networks[1:nC]), 
                  measure = rep(methods[1:nM], each = nA),
                  value = Change_of_Connectivity,
                  Std_error = Std_error)



bp =ggplot(HCHS_grid,aes(x=measure, y=value, fill=measure))+ geom_bar(stat = "identity", width = 0.25) +theme(axis.text.x=element_blank())+geom_errorbar(aes(ymin=value-Std_error,ymax=value+Std_error),width=.1)

bp + facet_grid(Control1 ~ Control2)


