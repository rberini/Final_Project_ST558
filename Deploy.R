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

v_diabetes_rf_final_fit <-
  diabetes_rf_final_fit |>
  extract_workflow() |>
  vetiver_model(model_name = "diabetes-rf")

board <-
  board_connect()

board |>
  vetiver_pin_write(v_diabetes_rf_final_fit)

vetiver_write_plumber(board, "rmberin2@ncsu.edu/diabetes-rf", rsconnect = FALSE)
vetiver_write_docker(v_diabetes_rf_final_fit)
