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


#' @title Create a \code{sem.vae} object
#'
#' @description Create a new \code{sem.vae} object, i.e., a structural
#'  equations model variational autoencoder. The \code{sem.vae} can be
#'  used to infer the directed acyclic graph unerlying the SEM.
#'
#' @export
#' @return returns a \code{sem.vae} object
sem.vae <- function() {
  .sem.vae$new()
}


#' @import R6
.sem.vae <- R6::R6Class(
  "sem.vae",
  private = list(
    .sem = NULL,
    .is_trained = FALSE
  ),
  public = list(
    initialize = function() {},
    train = function(data,
                     n_hidden = floor(sqrt(ncol(data))),
                     n_epochs = 100,
                     learning_rate = 0.01,
                     threshold = 0.3,
                     c = 10,
                     lambda = 1,
                     alpha = 1 / data$shape[[2]],
                     beta = 0,
                     debug = FALSE) {
      private$.sem <- model(ncol(data), n_hidden)
      train(
        private$.sem,
        data = data,
        n_epochs = n_epochs,
        learning_rate = learning_rate,
        threshold = threshold,
        c = c,
        lambda = lambda,
        alpha = alpha,
        beta = beta,
        debug = debug
      )
      private$.is_trained <- TRUE
    },
    optim = function(data,
                     n_hidden = floor(sqrt(ncol(data))),
                     n_epochs = 100,
                     learning_rate = 0.01,
                     threshold = 0.3,
                     c = 1,
                     lambda = 0,
                     alpha = 1 / data$shape[[2]],
                     beta = 0,
                     eta = 1,
                     gamma = 1,
                     tol = 1e-8,
                     debug = FALSE) {
      private$.sem <- optim(
        data,
        n_hidden = n_hidden,
        n_epochs = n_epochs,
        learning_rate = threshold,
        threshold = threshold,
        c = c,
        lambda = lambda,
        alpha = alpha,
        beta = beta,
        eta = eta,
        gamma = gamma,
        tol = tol
      )
      private$.is_trained <- TRUE
    },
    dag = function() {
      if (!private$.is_trained) {
        stop("sem.vae is not trained yet", call. = FALSE)
      }
      private$.sem$sem$numpy()
    }
  )
)
