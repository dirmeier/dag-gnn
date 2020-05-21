loss <- function(data, model, alpha, lambda, c, beta) {

  likelihood <- model$call(dat)
  z <- model$sample_encoder(data)

  logpx_z <-tf$reduce_sum(
    likelihood$log_prob(data), axis=1L
  )
  logpz <- tf$reduce_sum(
    tfp$distributions$Normal(0, 1)$log_prob(z), axis=1L
  )
  logqz <- tf$reduce_sum(tfp$distributions$Normal(
    model$z_mean, tf$sqrt(model$z_var))$log_prob(z), axis=1L
  )
  obj  <- -tf$reduce_mean(logpx_z - logqz + logpz)

  lang <- h(model, alpha)
  lang <- lambda * lang + 0.5 * c * lang^2
  sprs <- ell1(model, beta)

  loss <- obj + lang  + sprs
  loss
}


h <- function(model, alpha) {
  A <- model$A
  .h(A, alpha)
}


.h <- function(A, alpha) {
  n <- A$shape[[1]]
  p <- A$shape[[2]]
  assertthat::assert_that(n == p)

  I <- tf$eye(p)
  e <- I + alpha * tf$math$multiply(A, A)
  er <- e
  for (i in seq(2, p)) {
    er <- tf$matmul(er, e)
  }

  tf$linalg$trace(er) - p
}


ell1 <- function(model, beta) {
  if (beta == 0)
    return(0)
  beta * tf$reduce_sum(tf$abs(model$A))
}
