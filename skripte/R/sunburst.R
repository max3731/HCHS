

library(ggplot2)
library(plotly)
library(sunburstR)





fig <- plot_ly(
  labels = c("Artciles", "CSVD", "Healthy", "Other", "Patients/Controls", "Patients only", "N > 100 P", "N < 100 P", "Depression", "MCI non-vascular", "Sjörgen Syndrome"),
  parents = c("", "Artciles", "Artciles", "Artciles", "CSVD", "CSVD", "Healthy", "Healthy", "Other", "Other", "Other"),
  values = c(38, 19, 11, 8, 15, 4, 8, 3, 4, 3, 1 ),
  type = 'sunburst',
  branchvalues = 'total'
)

fig



fig <- plot_ly(
  labels = c("Resting state", "Data driven", "External parcellation"),
  parents = c("", "Resting state", "Resting state"),
  values = c(43,27, 16),
  type = 'sunburst',

)

fig


fig <- plot_ly(
  labels = c("Cognition", "General", "Executive ", "Memory","MoCa/MMSE","MoCa","MMSE","TMT","Stroop"),
  parents = c("", "Cognition", "Cognition", "Cognition","General","General","General","Executive","Executive"),
  values = c(130, 40, 60, 30,20,10,10,20,20),
  type = 'sunburst',
  branchvalues = 'total'
)

fig


fig <- plot_ly(
  labels = c("Resting state", "CSVD", "other", "Healthy Population","Other with WMH as Covariate", "CSVD only", "CSVD+Healthy "),
  parents = c("", "Resting state", "Resting state", "other", "other", "CSVD", "CSVD"),
  values = c(43,23, 20, 12, 8,5, 18),
  type = 'sunburst',
  branchvalues = 'total'
)

fig


fig <- plot_ly(
  labels = c("Resting state", "Data driven", "External parcellation", "ICA","SCA", "ALLF", "ReHo","fALLF","Eigenvector","Temp.based rotation", "Desikan-Killiany", "AAL90", "H-1024", "Schaefer", "Power Atl", "CONN Atl", "Brainatome","Netw ROIs"),
  parents = c("", "Resting state", "Resting state", "Data driven", "Data driven", "Data driven", "Data driven", "Data driven", "Data driven", "Data driven", "External parcellation","External parcellation","External parcellation","External parcellation","External parcellation","External parcellation","External parcellation","External parcellation"),
  values = c(43,27, 16, 8, 11,2, 2,1,1,2,3,5,2,1,1,1,1,2),
  type = 'sunburst',
  branchvalues = 'total'
)
fig

fig <- plot_ly(
  labels = c("Resting state", "Data driven", "External parcellation", "ICA"),
  parents = c("", "Resting state", "Resting state", "data driven"),
  values = c(43,27, 16, 8),
  type = 'sunburst',
  branchvalues = 'total'
)
fig



d <- data.frame(
  ids = c("CSVD", "Healthy Population", "other conditions", "CSVD - CSVD only", "CSVD - CSVD+Control",
          "Healthy Population - >100 participants", "<100 particpants","other conditions - Depression", "MCI", "SJS", "AD"),

  labels = c("CSVD", "Healthy<br>Population", "other<br>conditions", "CSVD only", "CSVD+Control",">100<br>participants", "<100<br>particpants",
             "Depression", "MCI", "SJS", "AD"),
  
  parents = c("", "", "", "CSVD", "CSVD","Healthy Population", "Healthy Population","other conditions", "other conditions", "other conditions",
              "other conditions"),
  
  stringsAsFactors = FALSE
    )
fig <- plot_ly(d, ids = ~ids, labels = ~labels, parents = ~parents, values = c(23 ,12, 8, 5, 18,8 , 4 , 3, 3,1, 1),  branchvalues = 'total',type = 'sunburst')
fig
















d <- data.frame(
  ids = c(
    "CSVD", "Healthy Population", "other conditions", "CSVD - CSVD only", "CSVD_Control", "data_driven", "external parcellation",
    "Healthy Population - >100 participants", "<100 particpants", "data_driven", 
    "other conditions - Depression", "MCI", "SJS", "AD"
  ),
  labels = c(
    "CSVD", "Healthy<br>Population", "other<br>conditions", "CSVD only", "CSVD_Control",  "data_driven", "external<br>parcellation", 
    ">100<br>participants", "<100<br>particpants", "data_driven", 
    "Depression", "MCI", "SJS", "AD"
  ),
  parents = c(
    "", "", "", "CSVD", "CSVD", "CSVD - CSVD only","CSVD - CSVD only", 
    "Healthy Population", "Healthy Population", "Healthy Population - >100 participants ", 
    "other conditions", "other conditions", "other conditions",
    "other conditions"
  ),
  stringsAsFactors = FALSE
)

fig <- plot_ly(d, ids = ~ids, labels = ~labels, parents = ~parents, values = c(23 ,12, 8, 5, 18, 2, 3 , 6, 6,6, 3, 1, 1, 3 ), type = 'sunburst')

fig
values = c(23 ,12, 8, 5, 18, 2, 3, 2 , 6, 6, 3, 1, 1, 3 ),

## SUnburstR


library(sunburstR)
packageVersion("sunburstR")
#> [1] '2.1.5'

d <- data.frame(
  ids = c(
    "North America", "Europe", "Australia", "North America - Football", "Soccer",
    "North America - Rugby", "Europe - Football", "Rugby",
    "Europe - American Football","Australia - Football", "Association",
    "Australian Rules", "Autstralia - American Football", "Australia - Rugby",
    "Rugby League", "Rugby Union"
  ),
  labels = c(
    "North<br>America", "Europe", "Australia", "Football", "Soccer", "Rugby",
    "Football", "Rugby", "American<br>Football", "Football", "Association",
    "Australian<br>Rules", "American<br>Football", "Rugby", "Rugby<br>League",
    "Rugby<br>Union"
  ),
  parents = c(
    "", "", "", "North America", "North America", "North America", "Europe",
    "Europe", "Europe","Australia", "Australia - Football", "Australia - Football",
    "Australia - Football", "Australia - Football", "Australia - Rugby",
    "Australia - Rugby"
  ),
  stringsAsFactors = FALSE
)

fig <- plot_ly(d, ids = ~ids, labels = ~labels, parents = ~parents, type = 'sunburst')

fig
