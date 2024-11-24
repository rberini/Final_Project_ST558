library(tidyverse)
library(tidymodels)
library(baguette)
library(vip)
library(vetiver)
library(pins)
library(plumber)

conflicts_prefer(dplyr::lag)
conflicts_prefer(dplyr::filter)
tidymodels_prefer()

options(scipen = 999, digits = 2)

