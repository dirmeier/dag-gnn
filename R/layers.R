
#' #' @import tensorflow
#' #' @importFrom R6 R6Class
#' #' @importFrom keras KerasLayer
#' Dense <- R6::R6Class("Dense",
#'   inherit = KerasLayer,
#'
#'   public = list(
#'     n_out = NULL,
#'     activation = NULL,
#'     W = NULL,
#'
#'     initialize = function(num_outputs, activation) {
#'       self$n_out <- num_outputs
#'       self$activation <- activation
#'     },
#'
#'     build = function(input_shape) {
#'       self$W <- self$add_weight(
#'         name = "W",
#'         shape = list(input_shape[[2]], self$num_outputs)
#'       )
#'     },
#'
#'     call = function(x, mask = NULL) {
#'       self$activation(tf$matmul(x, self$W))
#'     }
#'   )
#' )
#'
#' #' @importFrom keras create_layer
#' layer_dense <- function(object, num_outputs, activation = tf$identity, name = NULL) {
#'   keras::create_layer(Dense, object, list(
#'     num_outputs = as.integer(num_outputs),
#'     activation = activation,
#'     name = name,
#'     trainable = TRUE
#'   ))
#' }
