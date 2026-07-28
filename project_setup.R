# Project Setup
# ST 503 Project
#
# Author: Benjamin Glickauf
#
# This script loads the data, prepares the variables, and fits the final logistic regression model.

# Load data
TMH <- read.csv("Teen_Mental_Health_Dataset.csv", stringsAsFactors = FALSE)

# Prepare variables
TMH$gender <-
  factor(
    TMH$gender,
    levels = c("female", "male")
  )

TMH$social_interaction_level <-
  factor(
    TMH$social_interaction_level,
    levels = c("low", "medium", "high")
  )


# Fit final logistic regression model
final_model <- glm(
  depression_label ~
    gender +
    daily_social_media_hours +
    sleep_hours +
    stress_level +
    anxiety_level,
  data = TMH,
  family = binomial(link = "logit")
)


# Objects created

  # TMH
  # final_model