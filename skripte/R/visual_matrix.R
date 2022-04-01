setwd("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/")

HCHS = read.csv("C:/Users/mschu/Documents/Documents/CSI/R-Skripte/HCHS/HCHS_conn_0.5_aroma_abs.csv")


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

T_tuk = transformTukey(HCHS$ratio, plotit=FALSE)
HCHS["T_tuk"] <- T_tuk


dd %>% 

  ggplot(aes(x = T_tuk, y = estimate, fill = abs)) +
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