# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(rvest)
library(jsonlite)
library(xml2)



# Connect to URL ----------------------------------------------------------

url <- "https://www.forbes.com/sites/brettknight/2024/12/18/the-worlds-highest-paid-female-athletes-2024/"


forbes_2024_webpage <- 
  read_html(url) 

aa <- forbes_2024_webpage |> 
  html_elements("h2") 

bb <- 
  aa |> 
  unlist()

# TODO
