dense <- function(name, p, activation) {
  layer_dense(
    name = name,
    units = p,
    activation = activation,
    kernel_regularizer = regularizer_l2(l = .1),
    use_bias = FALSE,
    kernel_initializer = "glorot_normal"
  )
}
