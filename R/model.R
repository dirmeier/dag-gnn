

sem.vae <- function(n, p) {
  vae <- .model(n, p)
  vae
}

.model <- function(n, p){
  keras_model_custom(function(self) {
    self$A <- tf$Variable(
      tf$zeros(shape(p, p)), name = "A", trainable = TRUE
    )
    self$I <- tf$eye(p)
    self$z_mean <- NULL
    self$z_var <- NULL

    self$dense1  <- dense("d1", p, "relu")
    self$dense21 <- dense("d21", p, "linear")
    self$dense22 <- dense("d22", p, "linear")

    self$dense3  <- dense("d3", p, "relu")
    self$dense41 <- dense("d41", p, "linear")
    self$dense42 <- dense("d42", p, "linear")

    self$encoder <- function(x, tri) {
      self$z_mean <- x %>%
        self$dense1() %>%
        self$dense21() %>%
        tf$matmul(tri)

      self$z_var <- x %>%
        self$dense1() %>%
        self$dense22() %>%
        tf$matmul(tri) %>%
        tf$exp()

      tfp$distributions$Normal(
        loc = self$z_mean, scale = tf$sqrt(self$z_var)
      )
    }

    self$decoder <- function(z, tri.inv) {
      x_mean <- z %>%
        tf$matmul(tri.inv) %>%
        self$dense3() %>%
        self$dense41()

      x_var <- z %>%
        tf$matmul(tri.inv) %>%
        self$dense3() %>%
        self$dense42()  %>%
        tf$exp()

      tfp$distributions$Normal(
        loc = x_mean, scale = tf$sqrt(x_var)
      )
    }

    self$sample_encoder <- function(x) {
      tri <- self$I - self$A
      self$encoder(x, tri)$sample()
    }

    function(x, mask = NULL, training = FALSE) {
      tri <- self$I - self$A
      tri.inv <- tf$linalg$inv(tri)

      self$z_mean <- x %>%
        self$dense1() %>%
        self$dense21() %>%
        tf$matmul(tri)

      self$z_var <- x %>%
        self$dense1() %>%
        self$dense22() %>%
        tf$matmul(tri) %>%
        tf$exp()

     z <-  tfp$distributions$Normal(
       loc = self$z_mean, scale = tf$sqrt(self$z_var)
     )$sample()

      x_mean <- z %>%
        tf$matmul(tri.inv) %>%
        self$dense3() %>%
        self$dense41()

      x_var <- z %>%
        tf$matmul(tri.inv) %>%
        self$dense3() %>%
        self$dense42()  %>%
        tf$exp()

      tfp$distributions$Normal(
        loc = x_mean, scale = tf$sqrt(x_var)
      )
    }
  })
}

