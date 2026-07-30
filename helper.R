# Helper Functions
# ST 503 Project
# Benjamin Glickauf
#
# This file contains helper functions used throughout the simulation study


# Generate one synthetic dataset
generate_data <- function(data, model) {
  
  # Predictor variables
  X_sim <- data[, c(
    "gender",
    "daily_social_media_hours",
    "sleep_hours",
    "stress_level",
    "anxiety_level"
  )]
  
  # Predicted probabilities from fitted model
  p <- predict(
    model,
    newdata = X_sim,
    type = "response"
  )
  
  # Generate binary responses
  y_sim <- rbinom(
    n = nrow(X_sim),
    size = 1,
    prob = p
  )
  
  # Combine predictors and response
  sim_data <- X_sim
  sim_data$depression_label <- y_sim
  
  return(sim_data)
  
}


# Compute RMSE
compute_rmse <- function(actual, predicted) {
  
  sqrt(mean((actual - predicted)^2))
  
}


# Run simulation study
run_simulation <- function(model, data, B = 1000) {
  
  # True parameter values
  beta_true <- coef(model)
  
  p <- length(beta_true)
  
  # Storage
  coef_store <- matrix(
    NA,
    nrow = B,
    ncol = p
  )
  
  colnames(coef_store) <- names(beta_true)
  
  aic <- numeric(B)
  bic <- numeric(B)
  rmse <- numeric(B)
  accuracy <- numeric(B)
  converged <- logical(B)
  
  for (i in 1:B) {
    
    # Generate synthetic dataset
    sim_data <- generate_data(data, model)
    
    # Train/test split (80/20)
    train_index <- sample(
      seq_len(nrow(sim_data)),
      size = 0.8 * nrow(sim_data)
    )
    
    train_data <- sim_data[train_index, ]
    test_data  <- sim_data[-train_index, ]
    
    # Fit model on training data
    fit <- glm(
      formula(model),
      data = train_data,
      family = binomial(link = "logit")
    )
    
    # Evaluate on test set
    p_hat <- predict(
      fit,
      newdata = test_data,
      type = "response"
    )
    
    # Convert probabilities to predicted classes
    pred_class <- ifelse(p_hat >= 0.5, 1, 0)
    
    # Classification accuracy
    accuracy[i] <- mean(pred_class == test_data$depression_label)
    
    rmse[i] <- compute_rmse(
      actual = test_data$depression_label,
      predicted = p_hat
    )
    
    # Store results
    coef_store[i, ] <- coef(fit)
    
    aic[i] <- AIC(fit)
    bic[i] <- BIC(fit)
    converged[i] <- fit$converged
    
  }
  
  results <- list(
    beta_true = beta_true,
    coef_store = coef_store,
    aic = aic,
    bic = bic,
    rmse = rmse,
    accuracy = accuracy,
    converged = converged,
    B = B
  )
  
  return(results)
  
}