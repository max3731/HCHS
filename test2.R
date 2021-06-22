
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








#age

default_age = c(-0.0009039,-0.0005374  ,-0.0006599  ,-1.557e-05 ,-0.0002186  ,-0.0006264  ,0.0001602  )

dorsal_age = c( -0.0005374  ,-0.0013870  ,-0.0008531  ,-0.0005088  ,-0.0001527  ,-0.0007393  ,0.0001018  )

salven_age = c( -0.0006599  ,-0.0008531  ,-0.0016782  ,-0.0008092  ,-0.0004505  ,-0.0004119  ,4.479e-05  )

sommot_age = c( -1.557e-05,-0.0005088  ,-0.0008092  ,-0.0015187  ,-0.0001915  ,-0.0004185  ,0.0001148  )

cont_age = c( -0.0002186  ,-0.0001527  ,-0.0004505  ,-0.0001915  ,-0.0006708  ,-0.0002146  ,1.419e-04  )

vis_age = c( -0.0006264  ,-0.0007393  ,-0.0004119  ,-0.0004185  ,-0.0002146  ,-0.0013865  ,0.0001118  )

limb_age  = c( 0.0001602  ,0.0001018  ,4.479e-05  ,0.0001148  ,1.419e-04  ,0.0001118  ,-0.0002232  )


network_age = c(default_age,dorsal_age,salven_age,sommot_age,cont_age,vis_age,limb_age)



## wmh

default_wmh = c( -0.0196685 ,-0.0326721  ,-0.0189162  ,1.326e-02  ,0.0102498  ,0.0406824  ,0.0176900  )

dorsal_wmh  = c( -0.0326721  ,-0.0181442  ,0.0346593  ,0.0397684  ,-0.0034876  ,0.0317453  ,0.0205281  )

salven_wmh  = c( -0.0189162  ,0.0346593  ,-0.0142305  ,-0.0132986  ,0.0276550  ,0.0449680  ,3.478e-02  )

sommot_wmh  = c( 1.326e-02  ,0.0397684  ,-0.0132986  ,-0.0310151  ,0.0139317  ,0.0274218  ,0.0450649  )

cont_wmh  = c( 0.0102498  ,-0.0034876  ,0.0276550 ,0.0139317  ,-0.0392803  ,0.0167808  ,2.029e-02  )

vis_wmh  =c(0.0406824  ,0.0317453  ,0.0449680  ,0.0274218  ,0.0167808  ,-0.0237481  ,0.0234550  )

limb_wmh   = c( 0.0176900  ,0.0205281  ,3.478e-02  ,0.0450649  ,2.029e-02  ,0.0234550  ,0.0681270  )


network_wmh= c(default_wmh,dorsal_wmh,salven_wmh,sommot_wmh,cont_wmh,vis_wmh,limb_wmh)


Change_of_Connectivity = c(network_age,network_wmh)


#Change_of_Connectivity = c(network_wmh)


#age

default_age_p = c(0.0002146   ,0.0002083  ,0.0001996  ,1.279e-04  ,0.0001243  ,0.0002124  ,0.0001088     )

dorsal_age_p = c(0.0002083  ,0.0002615  ,0.0001840,0.0001792  ,0.0001510  ,0.0001835  ,0.0001138   )

salven_age_p = c(0.0001996  ,0.0001840  ,0.0002737  ,0.0002260  ,0.0001400  ,0.0001555  ,1.196e-04   )

sommo_age_p =c(1.279e-04  ,0.0001792  ,0.0002260  ,0.0003063  ,0.0001312  ,0.0001651  ,0.0001078   )

cont_age_p = c(0.0001243  ,0.0001510  ,0.0001400  ,0.0001312  ,0.0003043  ,0.0001619  ,9.969e-05   )

vis_age_p = c(0.0002124  ,0.0001835  ,0.0001555  ,0.0001651  ,0.0001619  ,0.0003614  ,0.0001323   )

limb_age_p  = c(0.0001088   ,0.0001138   ,1.196e-04   ,0.0001078   ,9.969e-05   ,0.0001323   ,0.0002134  )

network_age_p= c(default_age_p,dorsal_age_p,salven_age_p,sommo_age_p,cont_age_p,vis_age_p,limb_age_p)



## aroma_pval_0.5

default_wmh_p =c(0.0304202  ,0.0295253  ,0.0282979  ,1.813e-02   ,0.0176153   ,0.0301030   ,0.0154289   )

dorsal_wmh_p = c(0.0295253  ,0.0370619  ,0.0260816   ,0.0253999   ,0.0213977  ,0.0260158   ,0.0161363   )

salven_wmh_p = c(0.0282979  ,0.0260816   ,0.0387980  ,0.0320280  ,0.0198381   ,0.0220425   ,1.695e-02   )

sommot_wmh_p = c(1.813e-02   ,0.0253999   ,0.0320280  ,0.0434173  ,0.0186041   ,0.0234004   ,0.0152772   )

cont_wmh_p =c(0.0176153   ,0.0213977  ,0.0198381   ,0.0186041   ,0.0431347  ,0.0229471  ,1.413e-02   )

vis_wmh_p =c(0.0301030   ,0.0260158   ,0.0220425   ,0.0234004   ,0.0229471  ,0.0512241  ,0.0187503   )

limb_wmh_p  = c(0.0154289   ,0.0161363   ,1.695e-02   ,0.0152772   ,1.413e-02   ,0.0187503   ,0.0302491   )




network_wmh_p = c(default_wmh_p,dorsal_wmh_p,salven_wmh_p,sommot_wmh_p,cont_wmh_p,vis_wmh_p,limb_wmh_p)





Std_error = c(network_age_p,network_wmh_p)
#Std_error = c(limb_wmh_p)

nC <- 7; nM <- 2; nA = 49
#nC <- 7; nM <- 1; nA = 49


networks = c("Default","Dorsal","Salven","Sommot","Cont","Vis","Limb")
methods = c("age", "wmh")
labels = c("default","dorsal","salven", "sommot","cont","vis","limb")

HCHS_grid <- data.frame(Control1 = rep(networks[1:nC], each = nC),
                        Control2 = rep(networks[1:nC]), 
                        measure = rep(methods[1:nM], each = nA),
                        value = Change_of_Connectivity,
                        Std_error = Std_error)
                    


bp =ggplot(HCHS_grid,aes(x=measure, y=value, fill=measure))+ geom_bar(stat = "identity", width = 0.25) +theme(axis.text.x=element_blank())+geom_errorbar(aes(ymin=value-Std_error,ymax=value+Std_error),width=.1)  +scale_fill_manual("legend", values = c("wmh" = "blue", "age" = "#D55E00"))

bp + facet_grid(Control1 ~ Control2) 


