library(readr)
library(dplyr)
library(tibble)
library(ranger)
library(workflows)
library(parsnip)
library(yardstick)
library(vetiver)
library(pins)
library(plumber)

options(scipen = 999, digits = 2)

curdir <- getwd()
setwd("./vet")

diabetes <- readRDS("../data/diabetes.rds")

load("../model/diabetes_rf_final_model.RData")
load("../model/diabetes_rf_final_fit.RData")

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

setwd(curdir)