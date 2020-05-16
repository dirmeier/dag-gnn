#' @importFrom R6 R6Class
#' @import tensorflow
LINSEM.VAE <- R6::R6Class(
  classname = "LINSEM-VAE",
  public = list(
    A = NULL,
    I = NULL,
    layers = NULL,
    initialize = function(n, p) {
      init <- tf$initializers$glorot_normal(23L)

      self$layers <- list()
      self$layers[[1]] <- layer_dense(num_outputs = p, activation = tf$nn$relu)
      self$layers[[2]] <- layer_dense(num_outputs = p, activation = tf$identity)

      self$A <- tf$Variable(init(shape(p, p)))
      self$I <- tf$eye(p)
    },
    encode = function(X, al) {
      z <-self$layers[[1]](X)
      z <-self$layers[[2]](z)
      tf$matmul(z, self$I - self$A)
    },
    call = function(X) {
      al <- self$I - self$A
      Z <- self$encode(X, al)
      Z
    }
  )
)


#' @export
linsem.vae <- function(n, p) {
  LINSEM.VAE$new(as.integer(n), as.integer(p))
}

# linsem.vae <- function(n, p) {
#   keras_model_custom(function(self) {
#     init <- tf$initializers$glorot_normal(23L)
#     self$A <- tf$Variable(init(shape(p, p)))
#     self$I <- tf$eye(p)
#
#     self$dense1 <- layer_dense(num_outputs = p, activation = tf$nn$relu)
#     self$dense2 <- layer_dense(num_outputs = p, activation = tf$identity)
#
#     function(X, mask = NULL, training = FALSE) {
#       z <- X %>%
#         self$dense1() %>%
#         self$dense2()
#       tf$matmul(z, self$I - self$A)
#     }
#   })
# }

