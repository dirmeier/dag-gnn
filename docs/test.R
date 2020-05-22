library(dagitty)
library(dplyr)

library(igraph)
library(tensorflow)
library(keras)
library(tfprobability)

n <- 1000L
p <- 5L

adj <- pcalg::randomDAG(p, 1)
adj <- igraph.from.graphNEL(adj)
plot(adj)
adj <- as.matrix(as_adj(adj))
adj

A  <- adj * rnorm(p * p, 3, 1)
Z  <-  matrix(rnorm(n * p, 0, 1), n)

X <- Z %*% solve(diag(5) - A) %>%
  tf$cast("float32")
Z <- Z %>%
  tf$cast("float32")
A <- A %>%
  tf$cast("float32")



vae <- sem.vae(n, p, 2L)
s <- train(vae, X, 10, 1e-3, c=100, lambda = 100, threshold = 0.01, msg=TRUE)

s


vae$A$numpy() %>%
  graph_from_adjacency_matrix(weighted=TRUE) %>%
  is.dag()


par(mfrow=c(1, 2))
graph_from_adjacency_matrix(A) %>% plot()
graph_from_adjacency_matrix(vae$A$numpy()) %>%plot()



A <- tf$cast(A, "float32")

.h(A, 10)

z <- matrix(rnorm(10 * 5), 10)
x <- (z %*% solve(diag(5) - A))




