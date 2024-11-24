library(tidyverse)
library(tidymodels)
library(baguette)
library(vip)
library(vetiver)
library(pins)
library(plumber)

tidymodels_prefer()

options(scipen = 999, digits = 2)

load("data/diabetes.RData")
load("diabetes_rf_final_model.RData")
load("diabetes_rf_final_fit.RData")

data(diabetes)

invisible(diabetes_rf_final_model)

predictors <- diabetes_rf_final_model$forest$independent.variable.names
predictors

#define mode function for factors
fmode <- function(x) {
  unique_x <- unique(x)
  unique_x[which.max(tabulate(match(x, unique_x)))]
}

diabetes |>
  select(all_of(predictors)) |>
  summarise(across(where(is.factor), ~ fmode(.), .names = "{.col}_mode"),
            across(where(is.numeric), ~ mean(., na.rm = TRUE), .names = "{.col}_mean")) |>
  t()

predictions <-
  diabetes_rf_final_fit |>
  extract_workflow() |>
  predict(diabetes) |>
  bind_cols(diabetes) |>
  select(.pred_class, Diabetes)
predictions

accuracy_metric <-
  predictions |> 
  metrics(truth = Diabetes, estimate = .pred_class) |>
  filter(.metric == "accuracy")
accuracy_metric

conf_matrix <-conf_mat(predictions, truth = Diabetes, estimate = .pred_class)
conf_matrix
