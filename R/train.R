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
optim <- function(
                  data,
                  n_in,
                  n_hidden,
                  n_epochs = 100,
                  learning_rate = 0.01,
                  threshold = 0.3,
                  c = 1,
                  lambda = 0,
                  alpha = 1 / data$shape[[2]],
                  beta = 0,
                  eta = 1,
                  gamma = 1,
                  tol = 1e-8) {
  best.model <- NULL
  lang.old <- 0
  while (c < 1000) {
    vae <- sem.vae(n, p)
    loss <- train(
      model = vae,
      data = data,
      n_epochs = n_epochs,
      learning_rate = learning_rate,
      threshold = threshold,
      c = c,
      lambda = lambda,
      alpha = alpha,
      beta = beta
    )
    model <- list(vae = vae, loss = loss)

    if (is.null(best.model) || (model$loss < best.model$loss)$numpy()) {
      best.model <- model
    }

    lang <- h(vae, alpha)
    lambda <- lambda + c * lang
    if ((tf$abs(lang) > gamma * tf$abs(lang.old))$numpy()) {
      c <- c * eta
    }
    lang.old <- lang

    if (lang$numpy() < tol) {
      break
    }
  }

  best.model
}

#' @noRd
#' @importFrom tensorflow tf
train <- function(
                  model,
                  data,
                  n_epochs,
                  learning_rate,
                  threshold = 0.3,
                  c = 1,
                  lambda = 0,
                  alpha = 1 / data$shape[[2]],
                  beta = 0,
                  msg = FALSE) {
  optimizer <- optimizer_adam(learning_rate)

  data <- tf$cast(data, "float32")
  for (ep in seq_len(n_epochs)) {
    with(tf$GradientTape() %as% t, {
      lo <- loss(data, model, alpha, lambda, c, beta)
    })

    gradients <- t$gradient(lo, model$trainable_variables)
    optimizer$apply_gradients(purrr::transpose(list(
      gradients, model$trainable_variables
    )))

    if (msg) {
      tf$print("Loss:", lo)
    }
  }

  model$sem <- tf$math$multiply(
    model$A, tf$cast(tf$abs(model$A) > threshold, "float32")
  )

  invisible(lo)
}
