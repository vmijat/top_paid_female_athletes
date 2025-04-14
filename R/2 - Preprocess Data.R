# load libraries

library(tidyverse)
library(readxl)

# load data

# top_20 <- readxl::read_xlsx("./data_raw/top_20_female_sports_players.xlsx") |> 
#   janitor::clean_names()

top_20 <- read_rds("./data_processed/top_20.rds") |> 
  janitor::clean_names()



# Extract from Raw Data ---------------------------------------------------

top_20 <- 
  top_20 |> 
  rename(raw_data = all_other_data) |> 
  # extract sport
  mutate(sport = str_extract(raw_data, "^Sport:.\\w+"),
         sport = str_extract(sport, "\\w+$")) |> 
  # extract nationality
  mutate(nationality = str_extract(raw_data, "Nationality:.+\\|"),
         nationality = str_remove(nationality, "^Nationality:."),
         nationality = str_extract(nationality, ".+?\\|"), 
         nationality = str_remove(nationality, "..$")) |> 
  # extract age
  mutate(age = str_extract(raw_data, "Age:.+\\|"),
         age = str_remove(age, "^Age:."),
         age = str_remove( age, "..$"),
         age = as.integer(age)) |> 
  # extract On-field earnings
  mutate(on_field = str_extract(raw_data, "On-Field:.+?•"),
         on_field = str_remove(on_field, "On-Field:."),
         on_field = str_remove(on_field, ".•$"),
         on_field = str_extract(on_field, "([0-9]|\\.)+"),
         on_field = as.numeric(on_field)) |> 
  # extract off-field earnings
  mutate(off_field = str_extract(raw_data, "Off-Field:.+"),
         off_field = str_extract(off_field, "([0-9]|\\.)+"),
         off_field = as.numeric(off_field))


# Save Data ---------------------------------------------------------------


top_20 |> 
  saveRDS("./data_processed/top_20_clean.rds")



