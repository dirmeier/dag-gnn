library(dagitty)
library(dplyr)

library(igraph)
library(tensorflow)
library(keras)
library(tfprobability)


adjmatrix_to_dagitty <- function(adjmatrix) {
  if (is.null(rownames(adjmatrix)) | is.null(colnames(adjmatrix)) | !identical(rownames(adjmatrix), colnames(adjmatrix))) {
    warning("Matrix column names or rownames are either missing or not compatible. They will be replaced by numeric node names")
    nodes <- 1:nrow(adjmatrix)
  } else {
    nodes <- rownames(adjmatrix)
  }

  from_to <- which(adjmatrix == 1, arr.ind = T)

  dag_string <- paste0(
    "dag { \n",
    paste0(nodes, collapse = "\n"),
    "\n",
    paste0(apply(from_to, 1, function(x) paste0(nodes[x[1]], " -> ", nodes[x[2]])),
           collapse = "\n"
    ),
    "\n } \n"
  )
  return(dagitty:::dagitty(dag_string))
}

n <- 200L
p <- 5L

adj <- pcalg::randomDAG(p, .6)
adj <- igraph.from.graphNEL(adj)
plot(adj)
adj <- as.matrix(as_adj(adj))
adj
A   <- adj * rnorm(p * p, 3, 1)
A


dat <- A %>%
  adjmatrix_to_dagitty() %>%
  simulateSEM(N = n) %>%
  as.data.frame() %>%
  as.matrix() %>%
  tf$cast("float32")

vae <- sem.vae(n, p)
vae$call(dat)
train(vae, dat, 1, 1e-3, threshold = 0.3, alpha = 0)

vae$A$numpy()
vae$trainable_variables
vae$A$numpy() %>%
  graph_from_adjacency_matrix() %>%
  is.dag()

par(mfrow=c(1, 2))
graph_from_adjacency_matrix(A) %>% plot()
graph_from_adjacency_matrix(vae$A$numpy()) %>%plot()



A <- tf$cast(A, "float32")

.h(A, 10)
