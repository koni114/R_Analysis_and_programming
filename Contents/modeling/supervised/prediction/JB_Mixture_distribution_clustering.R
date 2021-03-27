######################
### 혼합 분포 군집 ###
######################
#' 혼합분포군집은 모형 기반의 군집방법
#' 데이터가 k개의 모수적 모형의 가중합으로 표현되는 모집단 모형으로부터 나왔다는 가정하에서 
#' 모수와 함께 가중치를 자료로부터 추정하는 방법 사용
#' k개의 각 모형은 군집을 의미
#' 각 데이터는 추정된 k개의 모형 중 어느 모형으로부터 나왔을 확률이 높은지에 따라 군집의 분류가 이루어짐

library(ggplot2)
library(dplyr)
options(scipen = 999)
p <- ggplot(faithful, aes(x = waiting)) + geom_density()
p

p + geom_vline(xintercept = 53, col = "red", size = 2) + geom_vline(xintercept = 80, col = "blue", size = 2)


install.packages("mixtools")
library("mixtools")
set.seed(1)

#' Plot a Mixture Component
#' @param x Input data
#' @param mu Mean of component
#' @param sigma Standard deviation of component
#' @param lam Mixture weight of component
plot_mix_comps <- function(x, mu, sigma, lam) {
   lam * dnorm(x, mu, sigma)
}

wait   <- faithful$waiting
mixmdl <- normalmixEM(wait, k = 2)

mixmdl$mu
mixmdl$sigma

post.df <- as.data.frame(cbind(x = mixmdl$x, mixmdl$posterior))

post.df %>%
  mutate(label = ifelse(comp.1 > 0.3, 1, 2)) %>% 
  ggplot(aes(x = factor(label))) +
  geom_bar() +
  xlab("Component") +
  ylab("Number of Data Points")


wait1 <- normalmixEM(faithful$waiting, lambda = .5, mu = c(55,80), sigma = 5)
plot(wait1, density = TRUE, cex.axis=1.4, cex.lab=1.4, cex.main=1.8, main2="Time between Old faithful eruptions", xlab2="Minutes")

install.packages("mclust")

library(mclust)
mc <- Mclust(iris[,1:4], G = 3)
summary(mc, parameters = TRUE)
plot.Mclust(mc)

mc$classification
mc_pred <- predict(mc, data=iris)
mc_pred$classification