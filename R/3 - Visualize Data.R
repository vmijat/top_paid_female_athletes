# load libraries

library(tidyverse)
library(ggflags)
library(countrycode)
library(gganimate)
library(magick)


# load processed data

top_20 <- read_rds("./data_processed/top_20_clean.rds")

# image created with gemini 
img <- image_read("./images/female_tennis_player.png") 



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



# convert to long format
ordered_data_long <- 
  top_20_ordered |> 
  pivot_longer(
    cols = c(
      on_field, 
      off_field
      ), 
    names_to = "earnings", 
    values_to = "millions"
    )


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
    alpha = 0.75) +
  
  coord_flip() +
  geom_flag(
    aes(country = nationality_for_flag), 
    y = 0, 
    size = 6
  ) +
  annotation_raster(raster = img,
                    xmin = 0, xmax = 14, 
                    ymin = 15, ymax = 30
  ) +
  geom_text(aes(label = total,
                y = total),
            hjust = -1) +
  
  theme_minimal() +
  labs(
    title = "Earnings For Top 20 Female Athletes",
    caption = "Data from Forbes.com | Visuals: Vlad Mijatović",
    y = "Millions USD",
    x = ""
  ) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank(), 
    axis.text = element_text(face = "bold"),
    legend.position = "top",
    legend.title = element_blank()
  ) +
  scale_fill_manual(
    values = c("darkorchid1", "darkorchid4"),
    labels = c("Off Field", "On Field")

  ) +
  annotation_raster(raster = img,
                    xmin = 0, xmax = 14, 
                    ymin = 15, ymax = 30
                    ) +
  transition_reveal(total)


p

# Animate -----------------------------------------------------------------


animate(p, 
        duration = 12, 
        fps = 20, 
        end_pause = 100,
        width = 800, 
        height = 600, 
        renderer = gifski_renderer("top_20_earnings.gif"))





