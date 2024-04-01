#### Preamble ####
# Purpose: Cleans the Auschwitz raw data for use in the shiny app
# Author: Abbass Sleiman
# Date: 31 March 2024
# Contact: abbass.sleiman@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(here)

#### Clean data ####
raw_data <- read_csv(here("data/raw_data/Auschwitz_data.csv"))

cleaned_data <- raw_data |>
  janitor::clean_names() |>
  mutate(date_of_birth = as.Date(date_of_birth)) |>
  mutate(date_of_death = as.Date(date_of_death)) |>
  na.omit()

#### Save Data ####
write_csv(cleaned_data, "Auschwitz_interactive_data/cleaned_Auschwitz_data.csv")

