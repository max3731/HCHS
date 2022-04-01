library(tidyverse)

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)
library(skimr)

setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")


#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/without_age/HCHS_conn_0_aroma.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.7_aroma_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/36/HCHS_conn_0.5_36_abs.csv")
HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_abs.csv")
T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
HCHS["T_tuk"] <- T_tuk

x <- 9

sqrt(x)

#== (Pipen von value on the left und function on the right)

x %>% sqrt()


gp1 <- HCHS %>%
  ggplot(aes(x = T_tuk, y = mean_conn_all)) +geom_point() +   geom_smooth(method=lm)

## subsets rows in a table baseed on values in a column

age <- filter(HCHS, age == "75")
head(age)

#quick way to just take the unique rows in a table. The function can be called with zero or more columns specified.
#If any columns are specified, only unique rows for those columns will be returned.

cldData <- distinct(HCHS, age, mean_conn_all)
dim(cldData)

subdat <- dplyr:: select(HCHS, age, mean_conn_all)
head(subdat)

# adding columns? This can be done with the mutate function.
#Suppose instead of concentrations, we want to look at the data with log2 concentrations.
#We can add a new column to the table with the following call.

HCHS %>%
  dplyr::mutate(logratio = log2(ratio)) %>%
  head()

HCHS = HCHS %>%
  dplyr::mutate(logratio = log2(ratio)) 
HCHS

#Another useful set of functions in the dplyr package allow for aggregating across the rows of a table. 
#Suppose we want to compute some summary measures of the viability scores.
HCHS %>%
  summarize(minConn = min(mean_conn_all),
            maxConn = max(mean_conn_all),
            avgConn = mean(mean_conn_all))

#For the simple case of counting the occurrences of the unique values in a column, use count. 
#The following example counts the number of rows in the table corresponding to each study.
count(HCHS, age)

#Summarization of the entire table is great, but often we want to summarize by groups. For example, instead of just computing the minimum, 
#maximum and average viability across all viability measures, what about computing these values for the CCLE and GDSC studies separately?
HCHS %>%
  group_by(age) %>%
  summarize(minConn = min(mean_conn_all),
            maxConn = max(mean_conn_all),
            avgConn = mean(mean_conn_all))
#Tip: Always remember to upgroup your data after you're finished performing operations on the groups.
#Forgetting that your data is still "grouped" can cause major headaches while performing data analysis! 
#If you're not sure if the data is grouped, just ungroup!
HCHS %>%
  group_by(age) %>%
  mutate(ratio = ratio / max(ratio) * 100) %>%
  ungroup()

#Finally, the dplyr package includes several functions for combining multiple tables. 
#These functions are incredibly useful for combining multiple tables with partially overlapping data. For example, 
#what if we want to combine the raw and summarized pharmacological datasets?

fullData <- full_join(HCHS, sumData, by = c("age"))
head(fullData)






library(gapminder)
library(dplyr)



# Filter for the year 1957, then arrange in descending order of population
gapminder %>% filter(year == 1957) %>% arrange(desc(pop))





library(gapminder)
library(dplyr)

# Filter, mutate, and arrange the gapminder dataset
gapminder %>% filter(year == 2007) %>%
  mutate(lifeExpMonths = 12 * lifeExp) %>%
  arrange(desc(lifeExpMonths))

download.file(url = "https://gitlab.com/stragu/DSH/raw/master/R/tidyverse_next_steps/data_wb_climate.csv",
              destfile = "data_wb_climate.csv")


climate_raw <- read_csv( "https://gitlab.com/stragu/DSH/raw/master/R/tidyverse_next_steps/data_wb_climate.csv")
# ` wird genutzt um anzuzeigen, dass die Zahl eine Variable ist, COlumns von 1990 bis 2011
#neue Säule mit Jahren kreieren`
climate_long = pivot_longer(climate_raw, `1990`:`2011`,
                            names_to = "year",
                            values_to = "value") %>%
# um Jahre als Zahlen zu speichern
  mutate(year = as.integer(year))
# HCHS Bsp 
HCHS2 = pivot_longer(HCHS, age:logratio, names_to = "category", values_to = "value")
# use tidyr to widen the data
#1. store the codebook
codes = unique(climate_long[ ,c("Series code" , "Series name")])
#2.widen
climate_tidy = climate_long %>% select(-`Series name`, -SCALE.-Decimals)%>% 
  pivot_wider(names_from = `Series code`, values_from = value)
#remove certain elements from data set
group = c("75","72")
HCHS3 = HCHS %>% filter(!`age` %in% group)
# visualize
HCHS %>% ggplot(aes(x = T_tuk, y=mean_conn_all, group = id)) + geom_point()
#visualize global emssions
climate_tidy %>% 
  groub_by(year) %>% 
  summarise(CO2 = sum (EN.ATM.CO2E.KT, na.rm = TRUE)) %>% 
  ggplot(aes(x = year, y = CO2)) + geom_point()
#remove years without data 
climate_tidy %>% 
  groub_by(year) %>% 
  summarise(CO2 = sum (EN.ATM.CO2E.KT, na.rm = TRUE)) %>% 
  filter (year < 2009) %>% 
  ggplot(aes(x = year, y = CO2)) + geom_point()
## Using purr fpr iterating with functional programming 
mtcars
# buld a propper loop
output = vector ("double", ncol(HCHS))
for (i in seq_along(HCHS)) { 
   output[[i]]= median(HCHS[[i]])
}
output
# the map family in purr
HCHS$id <- NULL
HCHS_median = map_dbl(HCHS, median)
## different data type as output
map_lgl(HCHS, is_character)
## change the default behaviour of function appliead
map_dbl(HCHS, mean,trim = 0.2)
## use mor elaborate formulas
map_dbl(HCHS, ~ round(mean(.x)))
# find number of uniq values in each var. of starwars
map_int(starwars, ~ length(unique(.x)))
#splitting data
unique(mtcars$cyl)
mtcars %>% 
  split(.$cyl) %>% 
  map(summary)

unique(mtcars$cyl)
mtcars %>% 
  split(.$cyl) %>% 
  map(~ ggplot(.,aes(mpg,wt))+ geom_point()+geom_smooth())
# pedicates
str(iris)
HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_abs.csv")
T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
HCHS["T_tuk"] <- T_tuk

# mean without chracter values 
HCHS %>% 
  discard(is.character) %>% 
  map_dbl(mean)
## only the variables that are character
 starwars %>% 
   keep(is.character)%>% 
   map_int(~length(unique(.x)))
## keep everything but apply function on some
 HCHS%>%
   map_if(is.numeric, round) %>%  
   str()
# cumulative and yearly change (CO2 emissions) 
 as_tibble(HCHS)#
 #finding na vlaues
 na_val = HCHS %>% map_df(~sum(is.na(.)))
 #finding missing val and change to na
 missing = HCHS %>% na_if("") %>% count(id)
 #examine numeric columns
 HCHS %>% skimr::skim()
 
 clinic= HCHS_clinic %>% skimr::skim()
 #
 matcars %>% mutate(cylinder = str_split(cy))
 ##Fehler finden
 reprex::reprex()