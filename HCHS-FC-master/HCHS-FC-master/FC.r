
setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")


#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/without_age/HCHS_conn_0_aroma.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.7_aroma_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/36/HCHS_conn_0.5_36_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0_aroma.csv")
HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_pval_abs.csv")
#HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_gsr_abs.csv")
#HCHS2 = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS_conn_aroma_abs.csv")

library(ggplot2)
library(car)
library(scatterplot3d)
library(rgl)
library(MASS)
library(rcompanion)








require(tidyverse)
require(fs)
require(ggplot2)

n <- 200
m <- matrix(NA, ncol = n, nrow = n)
m[lower.tri(m, diag = FALSE)] <- seq(1, n*(n-1)/2)
arrayIND <- sapply(seq(1, n*(n-1)/2), function(k)which(m == k, arr.ind = TRUE)) %>% 
  t() %>% 
  as_tibble() %>% setNames(c('i','j'))


schaefer200x7 <- read.csv('schaefer200x7NodeNames.txt', header = FALSE, stringsAsFactors = FALSE)$V1
networks <- str_match(schaefer200x7, "_\\s*(.*?)\\s*_")[,2]


fcn.read.csv <- function(s){
  read_csv(s, col_names = FALSE, col_types = cols(X1 = col_double())) %>% 
    rowid_to_column('linIND') %>% 
    add_column(arrayIND) %>% 
    mutate(I = map_chr(i,~networks[.]), J = map_chr(j, ~networks[.])) %>% 
    mutate(IJ = map2_chr(I, J, ~paste(sort(c(.x, .y)), collapse = '-')))
}
fcn.load.data <- function(dsn){
  dd <- file.path('xcpengine', dsn) %>% 
    list.files(recursive = TRUE, pattern = "schaefer200x7_network") %>% 
    file.path(file.path('xcpengine', dsn), .) %>% 
    .[1:100] %>% 
    setNames(., .) %>% # mirror behaviour of fs::dir_ls
    map_dfr(fcn.read.csv, .id = "source") %>% 
    mutate(sub = str_extract(source,"sub-[0-9a-f]{8}")) %>% 
    mutate(dsn = dsn)
  dd
}

dd <- lapply(c('aroma', '36p'), fcn.load.data) %>% 
  do.call(bind_rows, .)

CM <- dd %>% 
  group_by(sub,IJ) %>% 
  filter(I == J) %>% 
  filter(dsn == '36p') %>% 
  summarise(m = mean(X1)) %>% 
  pivot_wider(id_cols = sub, names_from = IJ, values_from = m, ) %>% 
  ungroup() %>% 
  dplyr::select(-sub) %>% 
  as.matrix() %>% 
  cor()

require(corrplot)
corrplot(CM, order = 'hclust')


require(ggsci)
WML <- read.csv('WML_FCON.dat') %>% rename(sub = 'ID')
dd %>% 
  group_by(sub, IJ, dsn) %>% 
  mutate(m = mean(X1)) %>% 
  dplyr::select(-X1, -linIND, -i, -j) %>% distinct() %>% 
  #dplyr::filter(I == J) %>% 
  merge(WML) %>% 
  ggplot(aes(x = log(WML), y = m, color = dsn)) +
  geom_point() +
  geom_smooth(aes(group = dsn), method = 'lm', se = T) +
  facet_grid(I ~ J, scales = 'free') +
  scale_fill_material() +
  theme_minimal()


dd %>% 
  mutate(X2 = abs(X1)) %>%
  pivot_longer(starts_with('X'), names_to = 'abs', values_to = 'X') %>% 
  group_by(sub, IJ, dsn, abs) %>% 
  mutate(m = mean(X)) %>% 
  dplyr::select(-X, -linIND, -i, -j) %>% distinct() %>% 
  #dplyr::filter(I == J) %>% 
  merge(WML) %>% 
  group_by(IJ, dsn, abs) %>% 
  nest() %>% 
  mutate(mdl = map(data, ~lm(m ~ log(WML), data = .))
         , tidy = map(mdl, ~broom::tidy(., conf.int = TRUE))) %>% 
  unnest(c(tidy)) %>% unnest(data) %>% 
  filter(term == 'log(WML)') %>% 
  dplyr::select(dsn, I, J, estimate, p.value, conf.low, conf.high) %>% distinct() %>% 
  ggplot(aes(x = dsn, y = estimate, fill = abs)) +
  geom_col(aes(alpha = if_else(p.value < 0.05, 1, .5)), position = position_dodge()) +
  geom_linerange(aes(ymin = conf.low, ymax = conf.high
                     , alpha = if_else(p.value < 0.05, 1, .5)), position = position_dodge(width=1)) + 
  facet_grid(I ~ J, scales = 'fixed') +
  guides(alpha = FALSE, size = FALSE)


require(magrittr)
dd %>% 
  group_by(sub, IJ) %>% 
  mutate(m = mean(V1)) %>% 
  dplyr::select(-V1, -linIND, -i, -j) %>% distinct() %>% 
  #dplyr::filter(I == J) %>% 
  filter(I == 'Default') %>% 
  merge(WML) %>% 
  filter(is.finite(m) & WML > 0) %>% 
  group_by(I,J) %>% 
  nest() %>% 
  mutate(mdl = map(data, ~lm(m ~ log(WML), data = .))
         , tidy = map(mdl, broom::tidy)) %>% 
  unnest(tidy) %>% 
  filter(term == 'log(WML)') %>% 
  arrange(p.value) %>%
  print(n=Inf)

## Mahalanobis
x <- dd %>% 
  group_by(sub, IJ) %>% 
  mutate(m = mean(V1)) %>%  
  select(IJ, sub, m) %>% distinct() %>%
  pivot_wider(id_cols = IJ, names_from = sub, values_from = m) %>% 
  ungroup() %>% 
  select(starts_with('sub')) 

xx <- x %>% 
  as.matrix() %>% t() 

Sx <- cov(xx)
D2 <- mahalanobis(xx, colMeans(xx), Sx)
plot(density(D2, bw = 0.5),
     main="Squared Mahalanobis distances") ; rug(D2)
qqplot(qchisq(ppoints(100), df = dim(x)[[1]]), D2,
       main = expression("Q-Q plot of Mahalanobis" * ~D^2 *
                           " vs. quantiles of" * ~ chi[dim(x)[[1]]]^2))
abline(0, 1, col = 'gray')



tibble(sub = colnames(x), D2 = D2) %>% 
  merge(WML) %>% 
  filter(WML > 0) %>% 
  ggplot(aes(x = log(WML), y = D2)) + 
  geom_point() +
  geom_smooth(method = 'lm', se = TRUE)
