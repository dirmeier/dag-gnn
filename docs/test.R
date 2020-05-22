library(dagitty)
library(dplyr)
library(daggnn)
library(igraph)

n <- 100L
p <- 10L

adj <- pcalg::randomDAG(p, 0.25)
adj <- igraph.from.graphNEL(adj)
plot(adj)
adj <- as.matrix(as_adj(adj))
adj

A  <- adj * rnorm(p * p, 0, 1)
sam <- sample(1:p)
A <- A[sam,sam]
colnames(A) <- rownames(A) <- seq(p)
adj <- A

igraph::graph_from_adjacency_matrix(A, weighted=TRUE) %>%
  is.dag()
igraph::graph_from_adjacency_matrix(A, weighted=TRUE) %>%
  plot()

Z  <-  matrix(rnorm(n * p, 0, 1), n)

X <- Z %*% solve(diag(p) - A)
data <- X



vae <- train(data, n_epochs = 300, c = 10000, lambda=10)


vae



optim(data)
