library(dagitty)
library(ggdag)

library(tensorflow)
library(keras)


n <- 100L
p <- 5L
dag <- randomDAG(p, .75)
dat <- simulateSEM(dag, N = n)
ggdag(dag)

dat <- simulateSEM(dag)
vae <- linsem.vae(n, p)


vae(dat)
