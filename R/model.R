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
#' @importFrom tensorflow tf shape
#' @importFrom keras keras_model_custom
#' @importFrom stats rnorm
model <- function(n, p, n_hidden) {
  keras_model_custom(function(self) {
    m <- matrix(stats::rnorm(p * p, 0, .1), p, p)

    self$A <- tf$Variable(
      m,
      name = "A", trainable = TRUE, dtype = "float32"
    )

    self$loss <- NA_real_
    self$data <- NULL
    self$I <- tf$eye(p, dtype = "float32")
    self$z_mean <- NULL
    self$z_var <- NULL

    self$dense11 <- dense("d11", n_hidden, "relu")
    self$dense21 <- dense("d21", p, "linear")
    self$dense22 <- dense("d22", p, "linear")

    self$dense31 <- dense("d31", n_hidden, "relu")
    self$dense41 <- dense("d41", p, "linear")
    self$dense42 <- dense("d42", p, "linear")


    self$prior <- function() {
      tfp$distributions$Independent(
        tfp$distributions$Normal(
          loc = tf$zeros(shape(n, p)), scale = tf$ones(shape(n, p))
        )
      )
    }

    # Z = f(g(X)) * (I - A)
    self$posterior <- function(x) {
      tri <- self$I - self$A

      self$z_mean <- x %>%
        self$dense11() %>%
        self$dense21() %>%
        tf$matmul(tri)

      self$z_var <- x %>%
        self$dense11() %>%
        self$dense22() %>%
        tf$matmul(tri) %>%
        tf$exp()

      tfp$distributions$Independent(
        tfp$distributions$Normal(
          loc = self$z_mean, scale = tf$sqrt(self$z_var)
        )
      )
    }

    # X = f(g( Z * solve(I - A) ))
    self$likelihood <- function(z) {
      tri.inv <- tf$linalg$inv(self$I - self$A)

      x_mean <- tf$matmul(z, tri.inv) %>%
        self$dense31() %>%
        self$dense41()

      x_var <- tf$matmul(z, tri.inv) %>%
        self$dense31() %>%
        self$dense42() %>%
        tf$exp()

      tfp$distributions$Independent(
        tfp$distributions$Normal(
          loc = x_mean, scale = tf$sqrt(x_var)
        )
      )
    }

    function(x, mask = NULL, training = FALSE) {
      tf$where(
        tf$math$is_nan(self$A), tf$zeros_like(self$A), self$A
      )
      tf$where(
        tf$math$is_inf(self$A), tf$zeros_like(self$A), self$A
      )

      enc <- self$posterior(x)
      z <- enc$sample()
      dec <- self$likelihood(z)
      dec
    }
  })
}
