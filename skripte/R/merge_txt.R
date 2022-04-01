setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/cortical")

mypath = "C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/cortical"

library("lessR")
library(utils)
library(stringr)


library(reshape)

file_list <- list.files(path=mypath, pattern="*.txt")

t_files_df <- lapply(file_list,header = F, read.delim, sep = " ") # Read in each file if its a csv file or `read.table` or `read.delim`


combined_df <- do.call("rbind", lapply(t_files_df, as.data.frame))


library(tidyverse)
library(dplyr)
combined_df %>% group_by("V3") %>% summarise(avg = median(expr.value))

df <- data.frame(
  var1 = c(1, 2),
  var2 = c(2, 4),
  var3 = c(3, 6)
)

select_vars <- c("var2", "var3")

combined_df$mean <-
  with (combined_df, ave( V3, findInterval(V2, c(-Inf, "^Default^", Inf)), FUN= mean) )

DF <- data.frame(Genre = sample(c("Action", "Fantasy", "SciFi"), 15, replace = TRUE),
                 Score = runif(15, min = 1, max = 10))

Stats <- aggregate(V3 ~ V1, data = combined_df, FUN =mean )
Stats



combined_df[combined_df$Dept=="rh", c('Gender', 'Dept', 'Salary')]

combined_df[.(V2=="default"), .(V1:V3)]


combined_df[combined_df$V2=="rh_7Networks_RH_SalVentAttn_TempOccPar_1_thickness",]

combined_df[.(V1=="sub-0e92323e" & V2=="rh_7Networks_RH_SalVentAttn_TempOccPar_1_thickness"), ]

combined_df[grep("^-0e92323e",rownames(combined_df)),]

combined_df[grepl(glob2rx('rh*'), rownames(combined_df)),]

str_locate("aaa12xxx", "[0-9]+")

ed_exp3 <- combined_df[which(combined_df$V1==2.862),names(combined_df) %in% c("State","Minor.Population","Education.Expenditures")]

