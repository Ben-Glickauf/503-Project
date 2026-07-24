source("Project-so-far.qmd") # doesn't work but you need to run this file first

set.seed(123)

compare_models <- function(model, data, B = 100) {
  
  warnings <- 0
  successes <- 0
  
  coef_store <- matrix(NA,
                       nrow = B,
                       ncol = length(coef(model)))
  
  colnames(coef_store) <- names(coef(model))
  
  for(i in 1:B){
    
    # Generate synthetic predictors
    X_sim <- data[, names(model$xlevels)]
    
    # Add numeric predictors
    X_sim$daily_social_media_hours <- data$daily_social_media_hours
    X_sim$sleep_hours <- data$sleep_hours
    if("academic_performance" %in% names(data))
      X_sim$academic_performance <- data$academic_performance
    X_sim$stress_level <- data$stress_level
    X_sim$anxiety_level <- data$anxiety_level
    
    # Generate probabilities
    p <- predict(model,
                 newdata = X_sim,
                 type = "response")
    
    # Generate responses
    y <- rbinom(nrow(X_sim), 1, p)
    
    sim_data <- X_sim
    sim_data$depression_label <- y
    
    # Fit model
    fit <- withCallingHandlers(
      
      try(
        update(model,
               data = sim_data),
        silent = TRUE
      ),
      
      warning = function(w){
        warnings <<- warnings + 1
        invokeRestart("muffleWarning")
      }
      
    )
    
    if(!inherits(fit, "try-error")){
      
      successes <- successes + 1
      coef_store[successes, ] <- coef(fit)
      
    }
    
  }
  
  list(
    warnings = warnings,
    successes = successes,
    means = colMeans(coef_store[1:successes, , drop = FALSE],
                     na.rm = TRUE)
  )
  
}


result1 <- compare_models(reduced_model_1, TMH)
result2 <- compare_models(reduced_model_2, TMH)

result1$warnings
result2$warnings

result1$successes
result2$successes

result1$means
result2$means