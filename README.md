# Final_Project_ST558

## Robert Berini

This project considers the Diabetes Health Indicators data set. Exploratory Data Analysis is first performed to review, manipulate, and summarize the data. Modeling is then performed to compare and select the best model for predicting a diabetes diagnosis. The best model is then made available as an API, which is then saved in a Docker image. This repository contains all files used and created for the project aside from the Docker image, which, due to size, is stored here:

Find links below to the code and output for the EDA and Modeling phases respectively.

[EDA Webpage](https://rberini.github.io/Final_Project_ST558/EDA.html "EDA")

[Modeling Webpage](https://rberini.github.io/Final_Project_ST558/Modeling.html "Modeling")

More information about the data set can be found via the links and table below.

[Diabetes Dataset](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset/?select=diabetes_binary_health_indicators_BRFSS2015.csv "Diabetes Dataset")

[Codebook for Variables](https://www.cdc.gov/brfss/annual_data/2015/pdf/CODEBOOK15_LLCP.pdf "Codebook")

### About the variables

|  |  |  |  |  |
|----|----|----|----|----|
| **Variable** | **Role** | **Type** | **Modified R Type** | **Levels** |
| Diabetes | Target | Binary | Factor | 0 = no diabetes 1 = prediabetes or diabetes |
| HighBP | Feature | Binary | Factor | 0 = no high BP 1 = high BP |
| HighChol | Feature | Binary | Factor | 0 = no high cholesterol 1 = high cholesterol |
| CholCheck | Feature | Binary | Factor | 0 = no cholesterol check in 5 years 1 = yes cholesterol check in 5 years |
| BMI | Feature | Integer | Double | Body Mass Index |
| Smoker | Feature | Binary | Factor | Have you smoked at least 100 cigarettes in your entire life? \[Note: 5 packs = 100 cigarettes\] 0 = no 1 = yes |
| Stroke | Feature | Binary | Factor | (Ever told) you had a stroke. 0 = no 1 = yes |
| HeartDiseaseorAttack | Feature | Binary | Factor | coronary heart disease (CHD) or myocardial infarction (MI) 0 = no 1 = yes |
| PhysActivity | Feature | Binary | Factor | physical activity in past 30 days - not including job 0 = no 1 = yes |
| Fruits | Feature | Binary | Factor | Consume Fruit 1 or more times per day 0 = no 1 = yes |
| Veggies | Feature | Binary | Factor | Consume Vegetables 1 or more times per day 0 = no 1 = yes |
| HvyAlcoholConsump | Feature | Binary | Factor | Heavy drinkers (adult men having more than 14 drinks per week and adult women having more than 7 drinks per week) 0 = no 1 = yes |
| AnyHealthcare | Feature | Binary | Factor | Have any kind of health care coverage, including health insurance, prepaid plans such as HMO, etc. 0 = no 1 = yes |
| NoDocbcCost | Feature | Binary | Factor | Was there a time in the past 12 months when you needed to see a doctor but could not because of cost? 0 = no 1 = yes |
| GenHlth | Feature | Integer | Double | Would you say that in general your health is: scale 1-5 1 = excellent 2 = very good 3 = good 4 = fair 5 = poor |
| MentHlth | Feature | Integer | Double | Now thinking about your mental health, which includes stress, depression, and problems with emotions, for how many days during the past 30 days was your mental health not good? scale 1-30 days |
| PhysHlth | Feature | Integer | Double | Now thinking about your physical health, which includes physical illness and injury, for how many days during the past 30 days was your physical health not good? scale 1-30 days |
| DiffWalk | Feature | Binary | Factor | Do you have serious difficulty walking or climbing stairs? 0 = no 1 = yes |
| Sex | Feature | Binary | Factor | 0 = female 1 = male |
| Age | Feature | Integer | Ordered Factor | 13-level age category (\_AGEG5YR see codebook) 1 = 18-24 9 = 60-64 13 = 80 or older |
| Education | Feature | Integer | Ordered Factor | Education level (EDUCA see codebook) scale 1-6 1 = Never attended school or only kindergarten 2 = Grades 1 through 8 (Elementary) 3 = Grades 9 through 11 (Some high school) 4 = Grade 12 or GED (High school graduate) 5 = College 1 year to 3 years (Some college or technical school) 6 = College 4 years or more (College graduate) |
| Income | Feature | Integer | Ordered Factor | Income scale (INCOME2 see codebook) scale 1-8 1 = less than \$10,000 5 = less than \$35,000 8 = \$75,000 or more |
