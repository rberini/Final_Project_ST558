library(tidyverse)
library(tidymodels)
library(plumber)

tidymodels_prefer()

options(scipen = 999, digits = 2)

load("data/diabetes.RData")
load("diabetes_rf_final_model.RData")
load("diabetes_rf_final_fit.RData")

attach(diabetes)

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
  summarise(across(where(is.factor), ~ as.character(fmode(.), .names = "{.col}")),
            across(where(is.numeric), ~ mean(., na.rm = TRUE), .names = "{.col}")) |>
  as.list()
pred_defaults


#* Predict diabetes diagnosis
#* Predicts diabetes diagnosis based on provided inputs or defaults.
#* <br>
#* <br>
#* Override defaults for the following parameters to customize prediction:
#* - `highbp`: Whether individual has high blood pressure (i.e., "Yes", "No")
#* - `highchol`: Whether individual has high cholesterol (i.e., "Yes", "No")
#* - `bmi`: Body Mass Index as a numeric value between 10-100
#* - `heartdiseaseorattack`: Whether the individual has history of heart disease or attack (i.e., "Yes", "No")
#* - `genhlth`: General health rating as a numeric value between 1 (excellent) and 5 (poor)
#* - `menthlth`: Days of poor mental health over last 30 days as a numeric value between 0-30
#* - `physhlth`: Days of poor physical health over last 30 days as a numeric value between 0-30
#* - `sex`: Gender (i.e., "Female", "Male")
#* - `age`: Age group (i.e., "18 to 24", "25 to 29", "30 to 34", "35 to 39", "40 to 44", "45 to 49", "50 to 54", "55 to 59", "60 to 64", "65 to 69", "70 to 74", "75 to 79", "80 or older")
#* - `income`: Household income group (i.e., "Less than $10,000", "$10,000 to less than $15,000", "$15,000 to less than $20,000", "$20,000 to less than $25,000", "$25,000 to less than $35,000", "$35,000 to less than $50,000", "$50,000 to less than $75,000", "$75,000 or more")
#* <br>
#* <br>
#* __Example calls:__
#* - `/pred?highbp=Yes&highchol=Yes&bmi=80&heartdiseaseorattack=Yes&genhlth=2&menthlth=2&physhlth=2&sex=Male&age=70%20to%2074&income=%2410%2C000%20to%20less%20than%20%2415%2C000`
#* - `/pred?highbp=No&highchol=No&bmi=25&heartdiseaseorattack=No&genhlth=1&menthlth=2&physhlth=2&sex=Female&age=25%20to%2029&income=%2450%2C000%20to%20less%20than%20%2475%2C000`
#* - `/pred?highbp=No&highchol=No&bmi=50&heartdiseaseorattack=No&genhlth=5&menthlth=0&physhlth=0&sex=Male&age=60%20to%2064&income=%2475%2C000%20or%20more`
#* - `/pred` (uses all default values)
#* 
#* @param highbp Yes or No
#* @param highchol Yes or No
#* @param bmi:numeric Number between 10-100
#* @param heartdiseaseorattack Yes or No
#* @param genhlth:numeric Number between 1-5
#* @param menthlth:numeric Number between 0-30
#* @param physhlth:numeric Number between 0-30
#* @param sex Female or Male
#* @param age Age group
#* @param income Income group
#* 
#* @get /pred
pred_diabetes <- function(highbp = pred_defaults$HighBP,
                        highchol = pred_defaults$HighChol,
                        bmi = pred_defaults$BMI,
                        heartdiseaseorattack = pred_defaults$HeartDiseaseorAttack,
                        genhlth = pred_defaults$GenHlth,
                        menthlth = pred_defaults$MentHlth,
                        physhlth = pred_defaults$PhysHlth,
                        sex = pred_defaults$Sex,
                        age = pred_defaults$Age,
                        income = pred_defaults$Income) {
  pred_tibble <-
    tibble(
      Diabetes = pred_defaults$Diabetes,
      HighBP = highbp,
      HighChol = highchol,
      CholCheck = pred_defaults$CholCheck,
      BMI = as.double(bmi),
      Smoker = pred_defaults$Smoker,
      Stroke = pred_defaults$Stroke,
      HeartDiseaseorAttack = heartdiseaseorattack,
      PhysActivity = pred_defaults$PhysActivity,
      Fruits = pred_defaults$Fruits,
      Veggies = pred_defaults$Veggies,
      HvyAlcoholConsump = pred_defaults$HvyAlcoholConsump,
      AnyHealthcare = pred_defaults$AnyHealthcare,
      NoDocbcCost = pred_defaults$NoDocbcCost,
      GenHlth = as.double(genhlth),
      MentHlth = as.double(menthlth),
      PhysHlth = as.double(physhlth),
      DiffWalk = pred_defaults$DiffWalk,
      Sex = sex,
      Age = age,
      Education = pred_defaults$Education,
      Income = income
  )
  
  temp_pred <-
    diabetes_rf_final_fit |>
    extract_workflow() |>
    predict(pred_tibble)
  
  temp_prob <-
    diabetes_rf_final_fit |>
    extract_workflow() |>
    predict(pred_tibble, type = "prob")
  
  pred <-
    bind_cols(temp_pred, temp_prob, pred_tibble |> select(-Diabetes))
  
  return(pred)
}




#* Return name and final project website
#* @serializer html
#* @get /info
function() {
  "<!DOCTYPE html>
  <html>
  <head><title>Plumber HTML</title></head>
  <body>
    <h4>Rob Berini</h4>
    <a href='https://rberini.github.io/Final_Project_ST558/'>Final Project Website</a>
  </body>
  </html>"
}


#* Get confusion matrix for entire data set
#* @serializer print
#* @get /confusion
function() {
  predictions <-
    diabetes_rf_final_fit |>
    extract_workflow() |>
    predict(diabetes) |>
    bind_cols(diabetes) |>
    select(.pred_class, Diabetes)
  
  conf_matrix <-conf_mat(predictions, truth = Diabetes, estimate = .pred_class)
  conf_matrix
  }

