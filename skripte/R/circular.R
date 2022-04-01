# install.packages("migest")
# install.packages("circlize")
library("migest")
library(circlize )

demo(cfplot_reg2, package = "migest", ask = FALSE)

set.seed(999)
mat = matrix(sample(18, 18), 3, 6) 
rownames(mat) = paste0("S", 1:3)
colnames(mat) = paste0("E", 1:6)
mat

df = data.frame(from = rep(rownames(mat), times = ncol(mat)),
                to = rep(colnames(mat), each = nrow(mat)),
                value = as.vector(mat),
                stringsAsFactors = FALSE)
df

chordDiagram(mat)

 from = c("Default", "Dorsal", "Dorsal", "Dorsal", "Salven", "Salven")
 to = c("Salven", "Salven", "Sommot", "Vis", "Sommot", "Cont")
value = c(3.306, 4.636 ,2.839  , 4.028 , 3.581 ,3.219 )

dc = data.frame(from,to,value)


circos.par(gap.after = c("Default" = 15, "Dorsal" = 15, "Salven" = 15, "Sommot" = 15, "Cont" = 15,
                         "Vis" = 15, "Limb" = 15))

col_mat = c("#FF3333", "#990000", "#FFCCCC", "#CC0000", "#FF0000", "#FF6666")


grid.col = c(Default = "#800000", Dorsal = "#800000", Salven = "#800000",
             Sommot = "#800000", Cont = "#800000", Vis = "#800000", Limb = "#800000")

#col_fun = function(x) ifelse(x < 4, "#00FF0040", "#FF000080")


chordDiagram(dc, grid.col = grid.col, col = col_mat)


#chordDiagram(dc, grid.col = grid.col, col = col_fun)


circos.clear()


chordDiagram(dc, grid.col = grid.col, col = col_mat)


circos.clear()


from = c("default", "default","default", "default","default", "default",
         "dorsal", "dorsal", "dorsal", "dorsal", "dorsal",
         "salven", "salven","salven", "salven",
         "sommot","sommot","sommot",
         "cont","cont",
         "vis"
         )

to = c("dorsal", "salven", "sommot", "cont", "vis", "limb",
       "salven", "sommot", "cont", "vis", "limb",
       "sommot", "cont", "vis", "limb",
       "cont","vis", "limb",
       "vis", "limb",
       "limb")

value = c(0,3.306, 0,0,2.949,0 ,4.636 ,2.839  ,0,  4.028 ,0, 3.581 ,3.219 , 0,0,0,0,0,0,0,0)

dc = data.frame(from,to,value)

circos.par(gap.after = c("default" = 15, "dorsal" = 15, "salven" = 15, "sommot" = 15, "cont" = 15,
                         "vis" = 15, "limb" = 15))



chordDiagram(dc)

circos.clear()