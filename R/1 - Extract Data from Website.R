# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(rvest)
library(jsonlite)
library(xml2)



# Connect to URL ----------------------------------------------------------

url <- "https://www.forbes.com/sites/brettknight/2024/12/18/the-worlds-highest-paid-female-athletes-2024/"


forbes_2024_webpage <- 
  read_html(url) 

# Prepare data

top_20_df <- data.frame(matrix(1:20, 20))


# get names
athletes <- forbes_2024_webpage |> 
  html_elements("h2") |> 
  html_text() |> 
  as_tibble()


top_20_df$name <- athletes$value

# get total paid
athletes_data_total_paid <- forbes_2024_webpage |> 
  html_elements("h3") |> 
  html_text() |> 
  as_tibble() 

athletes_data_total_paid <- 
   athletes_data_total_paid[-(1:2), ]
  

top_20_df$total_paid <- athletes_data_total_paid$value


# all other data

athletes_data_all_data <- forbes_2024_webpage |> 
  html_elements("h4") |> 
  html_text() |> 
  as_tibble()

# remove first row
athletes_data_all_data <- athletes_data_all_data[-1, ]
# remove last rows
athletes_data_all_data <- athletes_data_all_data[1:20, ]
  

top_20_df$all_other_data <- athletes_data_all_data$value


# save data --------------------------------------------------------------

top_20_df <- 
  top_20_df |> 
  select(name, total_paid, all_other_data)


saveRDS(top_20_df, 
        "./data_processed/top_20.rds")
