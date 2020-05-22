# daggnn: a variational autoencoder to learn the DAG of a structural equations model
#
# Copyright (C) 2020 Simon Dirmeier
#
# This file is part of daggnn
#
# daggnn is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# daggnn is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with daggnn If not, see <http://www.gnu.org/licenses/>.


#' @noRd
#' @importFrom tensorflow tf
loss <- function(data, model, alpha, lambda, c, beta) {
  likelihood <- model$call(data)
  z <- model$sample_encoder(data)

  logpx_z <- tf$reduce_sum(
    likelihood$log_prob(data),
    axis = 1L
  )
  logpz <- tf$reduce_sum(
    tfp$distributions$Normal(0, 1)$log_prob(z),
    axis = 1L
  )
  logqz <- tf$reduce_sum(tfp$distributions$Normal(
    model$z_mean, tf$sqrt(model$z_var)
  )$log_prob(z), axis = 1L)
  obj <- -tf$reduce_mean(logpx_z - logqz + logpz)

  lang <- h(model, alpha)
  lang <- lambda * lang + 0.5 * c * lang^2
  sprs <- ell1(model, beta)

  loss <- obj + lang + sprs
  loss
}


#' @noRd
h <- function(model, alpha) {
  A <- model$A
  .h(A, alpha)
}


#' @noRd
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


#' @noRd
ell1 <- function(model, beta) {
  if (beta == 0) {
    return(0)
  }
  beta * tf$reduce_sum(tf$abs(model$A))
}
