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


#' @title Train a SEM-VAE
#'
#' @export
#' @docType methods
#' @rdname train-methods
#'
#' @param data a (n x p)-dimensional matrix of $n$ observations of $p$ variables
#' @param n_hidden number of nodes in the hidden layer
#' @param n_epochs number of epochs to train the model
#' @param learning_rate learning rate of ADAM optimizer
#' @param threshold thresholding parameter of edge weights of adjacency matrix. All edge
#'  weights smaller \code{threshold} are set to zero after training. See
#'  also the original publication.
#' @param c quadratic penalty of augmented Lagrangian
#' @param lambda Lagrange multiplier
#' @param alpha hyperparameter for acyclicity constraint
#' @param beta \eqn{\ell_1} penalty to induce sparsity
#' @param debug boolean to print debug messages
#'
#' @return a \code{sem_vae} object
#'
setGeneric(
  "train",
  function(data,
           n_hidden = ceiling(ncol(data)),
           n_epochs = 100,
           learning_rate = 0.01,
           threshold = 0.3,
           c = 10,
           lambda = 0,
           alpha = 1 / ncol(data),
           beta = 0,
           debug = FALSE) {
    standardGeneric("train")
  },
  package = "daggnn"
)


#' @title Optimize hyperparameters and fit a SEM-VAE to a data set
#'
#' @export
#' @docType methods
#' @rdname optim-methods
#'
#' @param data a (n x p)-dimensional matrix of $n$ observations of $p$ variables
#' @param n_hidden number of nodes in the hidden layer
#' @param n_epochs number of epochs to train the model
#' @param learning_rate learning rate of ADAM optimizer
#' @param threshold thresholding parameter of edge weights of adjacency matrix. All edge
#'  weights smaller \code{threshold} are set to zero after training. See
#'  also the original publication.
#' @param c  quadratic penalty of augmented Lagrangian
#' @param lambda Lagrange multiplier
#' @param alpha hyperparameter for acyclicity constraint
#' @param beta \eqn{\ell_1} penalty to induce sparsity
#' @param eta tuning parameter for optimization
#' @param gamma tuning parameter for optimization
#' @param tol tolerance to stop optimization
#'
#' @return a \code{sem_vae} object
#'
setGeneric(
  "optim",
  function(data,
           n_hidden = ceiling(ncol(data)),
           n_epochs = 100,
           learning_rate = 0.01,
           threshold = 0.3,
           c = 1,
           lambda = 0,
           alpha = 1 / ncol(data),
           beta = 0,
           eta = 1,
           gamma = 1,
           tol = 1e-8) {
    standardGeneric("optim")
  },
  package = "daggnn"
)


#' @title Get the SEM form a SEM-VAE
#'
#' @description Returns the SEM that underlies an S4 wrapper class
#'  as \code{matrix}
#'
#' @export
#' @docType methods
#' @rdname sem-methods
#'
#' @param obj  the object for which you want to extract the SEM
#' @return  returns a \code{matrix}
#'
setGeneric("sem", function(obj) standardGeneric("sem"))
