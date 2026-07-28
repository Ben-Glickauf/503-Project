# Run Simulation Study
# ST 503 Project
# Benjamin Glickauf

# This script generates synthetic data, runs the simulation study, and saves the results for later analysis.

# Load project files
source("project_setup.R")
source("helper.R")

# Set random number seed
set.seed(123)


# Run simulation study
cat("Running simulation study...\n")

results <- run_simulation(
  model = final_model,
  data = TMH,
  B = 1000
)

# Save results
saveRDS(
  results,
  file = "simulation_results.rds"
)

# Finished
cat("Simulation study complete.\n")
cat("Results saved to simulation_results.rds\n")