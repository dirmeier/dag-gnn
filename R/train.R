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


#' @rdname train-methods
#' @importFrom methods new
#' @importFrom tensorflow tf
#' @importFrom purrr transpose
#' @importFrom keras optimizer_adam
setMethod(
  "train",
  signature = signature(data = "matrix"),
  function(data,
           n_hidden,
           n_epochs,
           learning_rate,
           threshold,
           c,
           lambda,
           alpha,
           beta,
           debug) {
    vae <- model(nrow(data), ncol(data), n_hidden)
    data <- tf$cast(data, "float32")

    optimizer <- keras::optimizer_adam(learning_rate)

    for (ep in seq_len(n_epochs)) {
      with(tf$GradientTape() %as% t, {
        lo <- loss(data, vae, alpha, lambda, c, beta)
      })

      gradients <- t$gradient(lo, vae$trainable_variables)
      optimizer$apply_gradients(purrr::transpose(list(
        gradients, vae$trainable_variables
      )))

      if (debug) {
        tf$print("Loss:", lo)
      }
    }

    vae$loss <- lo
    vae$sem <- tf$math$multiply(
      vae$A, tf$cast(tf$abs(vae$A) > threshold, "float32")
    )

    methods::new(
      "sem_vae",
      sem = vae,
      data = data
    )
  }
)


#' @rdname optim-methods
#' @importFrom methods new
#' @importFrom tensorflow tf
setMethod(
  "optim",
  signature = signature(data = "matrix"),
  function(data,
           n_hidden,
           n_epochs,
           learning_rate,
           threshold,
           c,
           lambda,
           alpha,
           beta,
           eta,
           gamma,
           tol) {
    best.model <- NULL
    lang.old <- 0

    while (c < 1000) {
      vae <- train(
        data = data,
        n_hidden = n_hidden,
        n_epochs = n_epochs,
        learning_rate = learning_rate,
        threshold = threshold,
        c = c,
        lambda = lambda,
        alpha = alpha,
        beta = beta,
        debug = FALSE
      )

      model <- list(model = vae@sem, loss = vae@sem$loss)
      if (is.null(best.model) || (loss < best.model$loss)$numpy()) {
        best.model <- model
      }

      lang <- h(vae@sem, alpha)
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
)
