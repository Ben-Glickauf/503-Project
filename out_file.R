############################################################
# Simulation Output
# ST 503 Project
#
# Author: Benjamin Glickauf
#
# This script summarizes the results of the simulation
# study and produces tables and plots.
############################################################


############################################################
# Load project files
############################################################

source("project_setup.R")

results <- readRDS("simulation_results.rds")


############################################################
# Basic simulation summary
############################################################

cat("Number of simulations:", results$B, "\n")
cat("Models converged:", sum(results$converged), "\n")
cat("Average RMSE:", mean(results$rmse), "\n")
cat("Average AIC:", mean(results$aic), "\n")
cat("Average BIC:", mean(results$bic), "\n")


############################################################
# Coefficient summary table
############################################################

coef_summary <- data.frame(
  
  Parameter = names(results$beta_true),
  
  True_Value = results$beta_true,
  
  Mean_Estimate = colMeans(results$coef_store),
  
  Bias = colMeans(results$coef_store) -
    results$beta_true,
  
  SD = apply(results$coef_store, 2, sd)
  
)

print(coef_summary)


############################################################
# RMSE summary
############################################################

summary(results$rmse)


############################################################
# AIC summary
############################################################

summary(results$aic)


############################################################
# BIC summary
############################################################

summary(results$bic)


############################################################
# Histogram of RMSE
############################################################

hist(
  results$rmse,
  main = "RMSE Across Simulations",
  xlab = "RMSE"
)


############################################################
# Histogram of AIC
############################################################

hist(
  results$aic,
  main = "AIC Across Simulations",
  xlab = "AIC"
)


############################################################
# Histogram of BIC
############################################################

hist(
  results$bic,
  main = "BIC Across Simulations",
  xlab = "BIC"
)


############################################################
# Sampling distributions of coefficients
############################################################

par(mfrow = c(2, 3))

for(i in seq_along(results$beta_true)){
  
  hist(
    results$coef_store[, i],
    main = names(results$beta_true)[i],
    xlab = "Estimate"
  )
  
  abline(
    v = results$beta_true[i],
    lwd = 2,
    lty = 2
  )
  
}

par(mfrow = c(1, 1))