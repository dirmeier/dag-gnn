
.new.dense <- function(name, activation) {
  layer_dense(
    name = name,
    units = p,
    activation = activation,
    kernel_regularizer = regularizer_l2(l = .1),
    use_bias = FALSE,
    kernel_initializer = "glorot_normal"
  )
}


linsem.vae <- function(n, p) {
  keras_model_custom(function(self) {
    self$A <- tf$Variable(tf$zeros(shape(p)), name = "A")
    self$I <- tf$eye(p)
    self$z_mean <- NULL
    self$z_var <- NULL

    self$dense1 <- .new.dense("d1", "relu")
    self$dense21 <- .new.dense("d21", "linear")
    self$dense22 <- .new.dense("d22", "linear")

    self$dense3 <- .new.dense("d3", "relu")
    self$dense41 <- .new.dense("d41", "linear")
    self$dense42 <- .new.dense("d42", "linear")


    self$encoder <- function(x) {
      A <- tf$linalg$diag(self$A)
      tri <- self$I - A

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

    self$decoder <- function(z) {
      A <- tf$linalg$diag(self$A)
      tri <- self$I - A
      tri.inv <- tf$linalg$inv(tri)

      x_mean <- z %>%
        tf$matmul(tri.inv) %>%
        self$dense3() %>%
        self$dense41()

      x_var <- z %>%
        tf$matmul(tri.inv) %>%
        self$dense3() %>%
        self$dense42()  %>%
        tf$exp()

      tfp$distributions$Independent(
        tfp$distributions$Normal(
          loc = x_mean, scale = tf$sqrt(x_var)
        )
      )
    }

    function(x, mask = NULL, training = FALSE) {
      encoder <- self$encoder(x)
      z <- encoder$sample()
      x <- self$decoder(z)

      x
    }
  })
}



loss <- function(dat, model) {

  z <- model$encoder(dat)$sample()
  likelihood <- model$decoder(z)

  logpz <-  tf$reduce_sum(tfp$distributions$Normal(0, 1)$log_prob(z) ,axis=1)
  logqz <-  tf$reduce_sum(tfp$distributions$Normal(
    model$z_mean, tf$sqrt(model$z_var))$log_prob(z) ,axis=1)

  logpx_z <- likelihood$log_prob(dat)
  -tf$reduce_mean(logpx_z + logpz - logqz)
}


train <- function(model, sem, n_epochs, learning_rate) {
  optimizer <- optimizer_adam(learning_rate)
  train_loss <- tf$keras$metrics$Mean(name = "train_loss")

  epoch <- function() {
    with(tf$GradientTape() %as% t, {
      lo <- loss(dat, model)
    })

    gradients <- t$gradient(lo, model$trainable_variables)
    optimizer$apply_gradients(purrr::transpose(list(
      gradients, model$trainable_variables
    )))

    train_loss(lo)
    tf$print("Loss", train_loss$result())
    train_loss$reset_states()
  }

  for (ep in seq_len(n_epochs)) {
    current_loss <- epoch()
    cat(glue::glue("Epoch: {ep}, Loss: {as.numeric(current_loss)}"), "\n")
  }
}

