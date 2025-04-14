# load libraries

library(tidyverse)
library(ggflags)
library(countrycode)
library(gganimate)


# load data

top_20 <- read_rds("./data_processed/top_20.rds")




# Process Data ------------------------------------------------------------


top_20 <- 
  top_20 |> 
  mutate(total = on_field + off_field)

top_20_ordered <- 
  top_20 |> 
  arrange(total) |> 
  # add country codes (for drawing flags)
  mutate(
    nationality_for_flag = countrycode(nationality, 
                                       origin = 'country.name', 
                                       destination = 'iso2c', 
                                       warn = FALSE) ,
    nationality_for_flag = str_to_lower(nationality_for_flag)
                                       
  )



# convert to long 
ordered_data_long <- 
  top_20_ordered |> 
  pivot_longer(
    cols = c(on_field, off_field), 
    names_to = "earnings", values_to = "millions")


# Visualization -----------------------------------------------------------

p <- ordered_data_long |> 
  ggplot(
    aes(
      x = fct_reorder(name, total),
      y = millions,
      fill = earnings
    )
  ) +
  geom_bar(
    stat = "identity",
    alpha = 0.65) +
  coord_flip() +
  geom_flag(
    aes(country = nationality_for_flag), # Map nationality to country, convert to lowercase
    y = 0, 
    size = 6
  ) +
  theme_minimal() +
  labs(
    title = "Earnings For Top 20 Female Athletes",
    caption = "Data from Forbes.com | Visuals: Vlad Mijatovic",
    y = "Millions USD",
    x = ""
  ) +
  scale_fill_manual(
    values = c("darkorchid1", "darkorchid4")
  ) +
  transition_reveal(total)

p

# Animate -----------------------------------------------------------------


animate(p, 
        duration = 10, 
        fps = 20, 
        end_pause = 100,
        width = 100, 
        height = 100, 
        renderer = gifski_renderer("top_20_earnings.gif"))


animate(p, 
        duration = 10, 
        fps = 20, 
        end_pause = 100,
        width = 100, 
        height = 100, 
        renderer = av_renderer("top_20_earnings.mp4"))

