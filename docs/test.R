suppressMessages({
  library(dplyr)
  library(igraph)
  library(ggraph)
  library(tidyverse)
  library(colorspace)
  library(patchwork)

  library(pcalg)
  library(daggnn)
})

plot.adj <- function(adj) {
  igraph::graph_from_adjacency_matrix(adj, weighted = TRUE) %>%
    ggraph::ggraph(layout = "sugiyama") +
    ggraph::geom_edge_link(
      ggplot2::aes(
        start_cap = label_rect(node1.name),
        end_cap = label_rect(node2.name)
      ),
      arrow = arrow(length = unit(4, "mm"))
    ) +
    ggraph::geom_node_text(ggplot2::aes(label = name), size = 5) +
    ggraph::scale_edge_color_viridis("Coefficient", end = .8, option = "B") +
    ggraph::scale_edge_width("Direction", range = c(.5, 2), limits = c(.5, 1)) +
    ggraph::theme_graph()
}

n <- 1000
p <- 7

set.seed(123)
dag <- pcalg::randomDAG(p, prob = 0.7)

A <- dag %>%
  igraph::graph_from_graphnel() %>%
  igraph::as_adj() %>%
  as.matrix()

ordering <- sample(1:p)
A <- A[ordering ,ordering]
colnames(A) <- rownames(A) <- LETTERS[1:p]

plot.adj(A)

f <- function(.) .

Z <- matrix(rnorm(n * p, 0, 1), n)
X <- f(Z) %*% solve(diag(p) - A)

head(Z)
head(X)

# compute X
f(Z[1, ]) %*% solve(diag(p) -  A)
head(X)

# compute Z
f(X[1, ]) %*% (diag(p) -  A)
head(Z)

sem <- train(X, c = 1000, lambda = 1000)

A
sem(sem)

sem <- optim(X)

plot.adj(sem(sem))
