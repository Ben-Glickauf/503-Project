# ST 503 Final Project Workflow
# Benjamin Glickauf
#
# This file describes the order in which the project files should be run to reproduce all results in the final report.


# Step 1
# Set the working directory to the project folder containing
# all project files and the Teen Mental Health dataset.


# Step 2
# Run project_setup.R

# This script:
  # Loads the dataset
  # Performs data cleaning/preparation
  # Fits the logistic regression model
  # Stores the fitted model for later use

source("project_setup.R")


# Run run_file.R

# This script:
  # Generates 1,000 synthetic datasets
  # Fits a logistic regression model to each dataset
  # Calculates RMSE, AIC, BIC, classification accuracy, and coefficient estimates
  # Saves all simulation results

source("run_file.R")


# Run out_file.R

# This script creates:
  # coefficient_estimates.csv
  # coef_summary.csv
  # simulation_summary.csv
  # odds_ratios.csv
  # confidence_intervals.csv
  # rmse_histogram.pdf
  # aic_histogram.pdf
  # bic_histogram.pdf
  # accuracy_histogram.pdf
  # coefficient_histograms.pdf

source("out_file.R")


# Step 5
# Run eda.R

# This script creates:
  # response_distribution.pdf
  # gender_vs_depression.pdf
  # sleep_boxplot.pdf
  # social_media_boxplot.pdf
  # stress_boxplot.pdf
  # anxiety_boxplot.pdf
  # response_distribution.csv
  # response_proportion.csv
  # gender_vs_depression.csv
  # correlation_matrix.csv
  # descriptive_statistics.txt

source("eda.R")


# Notes

# Running the scripts in the order above reproduces all tables, figures, and numerical results presented in the final report.

# Random number generator seeds are set within the project to ensure reproducibility.