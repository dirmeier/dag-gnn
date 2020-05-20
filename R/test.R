library(dagitty)
library(ggdag)

library(tensorflow)
library(keras)
library(tfprobability)


n <- 20L
p <- 5L
dag <- randomDAG(p, .0)

dat <- simulateSEM(dag, N = n) %>%
  as.data.frame() %>%
  as.matrix() %>%
  tf$cast("float32")

vae <- linsem.vae(n, p)
train(vae, dat, 10, 0.1)

vae$A
