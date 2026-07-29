# Simulation Output
# ST 503 Project
# Author: Benjamin Glickauf

# This script summarizes the results of the simulation study and produces tables and plots.


# Load project files
source("project_setup.R")

results <- readRDS("simulation_results.rds")


# Real coefficients

real_coef <- data.frame(
  Estimate = coef(final_model)
)

write.csv(real_coef,
          "coefficient_estimates.csv",
          row.names = TRUE)


# Coefficient summary table

coef_summary <- data.frame(
  Parameter = names(results$beta_true),
  True_Value = results$beta_true,
  Mean_Estimate = colMeans(results$coef_store),
  Median_Estimate = apply(results$coef_store, 2, median),
  Bias_Mean = colMeans(results$coef_store) - results$beta_true,
  Bias_Median = apply(results$coef_store, 2, median) - results$beta_true,
  SD = apply(results$coef_store, 2, sd),
  IQR = apply(results$coef_store, 2, IQR)
)

# Round numeric columns
coef_summary[-1] <- round(coef_summary[-1], 4)

coef_summary

write.csv(
  coef_summary,
  "coef_summary.csv",
  row.names = FALSE
)


# Extreme coefficient estimates

extreme <- apply(abs(results$coef_store), 1, max) >= 100

extreme_summary <- data.frame(
  Total_Simulations = results$B,
  Extreme_Simulations = sum(extreme),
  Percent_Extreme = round(100 * mean(extreme), 2)
)

extreme_summary

write.csv(
  extreme_summary,
  "extreme_summary.csv",
  row.names = FALSE
)


# Simulation summary table

simulation_summary <- data.frame(
  Simulations = results$B,
  Convergence_Rate = mean(results$converged),
  Mean_RMSE = mean(results$rmse),
  Mean_Accuracy = mean(results$accuracy),
  Mean_AIC = mean(results$aic),
  Mean_BIC = mean(results$bic)
)

simulation_summary

write.csv(
  simulation_summary,
  "simulation_summary.csv",
  row.names = FALSE
)


# Odds ratios

or_table <- data.frame(
  Parameter = names(coef(final_model)),
  Odds_Ratio = exp(coef(final_model))
)

or_table

write.csv(
  or_table,
  "odds_ratios.csv",
  row.names = FALSE
)


# Confidence Intervals

ci_table <- data.frame(
  Parameter = rownames(confint(final_model)),
  Lower = exp(confint(final_model))[,1],
  Upper = exp(confint(final_model))[,2]
)

ci_table

write.csv(
  ci_table,
  "confidence_intervals.csv",
  row.names = FALSE
)


# Histogram of RMSE

pdf("rmse_histogram.pdf")

hist(
  results$rmse,
  main = "RMSE Across Simulations",
  xlab = "RMSE"
)

dev.off()


# Histogram of AIC

pdf("aic_histogram.pdf")

hist(
  results$aic,
  main = "AIC Across Simulations",
  xlab = "AIC"
)

dev.off()


# Histogram of BIC

pdf("bic_histogram.pdf")

hist(
  results$bic,
  main = "BIC Across Simulations",
  xlab = "BIC"
)

dev.off()


# Histogram of Classification Accuracy

pdf("accuracy_histogram.pdf")

hist(
  results$accuracy,
  main = "Classification Accuracy Across Simulations",
  xlab = "Accuracy"
)

dev.off()


# Sampling distributions of coefficients
  # Extreme coefficient estimates caused by quasi-complete separation are omitted from these plots to better        display the typical sampling distributions.

pdf("coefficient_histograms.pdf")

par(mfrow = c(2, 3))

for(i in seq_along(results$beta_true)){
  
  x <- results$coef_store[, i]
  
  hist(
    x[abs(x) < 100],
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

dev.off()