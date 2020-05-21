
optim <- function(
  data,
  n_epochs,
  learning_rate,
  c = 1,
  lambda = 0,
  alpha = 1 / data$shape[[2]],
  beta = 0) {
  while (c < 1e10) {
    mod <- sem.vae(n, p)
    m <- train(mod, data, n_epochs, learning, c, lambda)
  }
}

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

  model$A <- tf$math$multiply(
    model$A, tf$cast(tf$abs(model$A) > threshold, "float32")
  )
  invisible(lo)
}
