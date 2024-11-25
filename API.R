library(tidyverse)
library(tidymodels)
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

pred_defaults <-
  diabetes |>
  summarise(across(where(is.factor), ~ fmode(.), .names = "{.col}"),
            across(where(is.numeric), ~ mean(., na.rm = TRUE), .names = "{.col}")) |>
  as.list()
pred_defaults

pred_diabetes <- function(HighBP = pred_defaults$HighBP,
                        HighChol = pred_defaults$HighChol,
                        BMI = pred_defaults$BMI,
                        HeartDiseaseorAttack = pred_defaults$HeartDiseaseorAttack,
                        GenHlth = pred_defaults$GenHlth,
                        MentHlth = pred_defaults$MentHlth,
                        PhysHlth = pred_defaults$PhysHlth,
                        Sex = pred_defaults$Sex,
                        Age = pred_defaults$Age,
                        Income = pred_defaults$Income) {
  pred_tibble <-
    tibble(
      Diabetes = pred_defaults$Diabetes,
      HighBP = HighBP,
      HighChol = HighChol,
      CholCheck = pred_defaults$CholCheck,
      BMI = BMI,
      Smoker = pred_defaults$Smoker,
      Stroke = pred_defaults$Stroke,
      HeartDiseaseorAttack = HeartDiseaseorAttack,
      PhysActivity = pred_defaults$PhysActivity,
      Fruits = pred_defaults$Fruits,
      Veggies = pred_defaults$Veggies,
      HvyAlcoholConsump = pred_defaults$HvyAlcoholConsump,
      AnyHealthcare = pred_defaults$AnyHealthcare,
      NoDocbcCost = pred_defaults$NoDocbcCost,
      GenHlth = GenHlth,
      MentHlth = MentHlth,
      PhysHlth = PhysHlth,
      DiffWalk = pred_defaults$DiffWalk,
      Sex = Sex,
      Age = Age,
      Education = pred_defaults$Education,
      Income = Income
  )
  
  pred <-
    diabetes_rf_final_fit |>
    extract_workflow() |>
    predict(pred_tibble) |>
    bind_cols(pred_tibble) |>
    select(.pred_class, Diabetes)
  
  return(pred)
}

pred_diabetes()

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
