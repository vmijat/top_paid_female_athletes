# load libraries

library(tidyverse)
library(waffle)
library(pals)
library(showtext)
library(ggtext)


# load data of top 20 female players

top_20 <- read_rds("./data_processed/top_20_clean.rds")



# Modify dataset ----------------------------------------------------------

top_20 <- 
  top_20 |> 
  mutate(total_earning = on_field + off_field)



# Define fonts and texts --------------------------------------------------


font_add_google("Kanit", "title_font")
font_add_google("Roboto", "body_font")
showtext_auto()

title_font <- "title_font"
body_font <- "body_font"


#  Create the dataset and plot

p <- top_20 |> 
  mutate(name = fct_reorder(name, 
                            total_earning#, 
                            #desc
                            )) |> 
  ggplot(aes(
    fill = name, 
    values = total_earning
  )) +
  geom_waffle(color = "white", 
              size = .25, 
              n_rows = 10, 
              flip = TRUE) +
  facet_wrap(~ name,
             nrow = 10,
             strip.position = "bottom") +
  scale_x_discrete() + 
  scale_y_continuous(labels = function(x) x * 10, # make this multiplyer the same as n_rows
                     expand = c(0,0))+
  scale_fill_manual(values=unname(glasbey())) +
  coord_equal() +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_blank(),
    
    # legend
    legend.position = 'none',
    
    # TITLE
    plot.title.position = "plot",
    plot.title = element_textbox(margin = margin(0, 0, 0, 0),
                                 size = 26,
                                 family = title_font,
                                 face = "bold",
                                 width = unit(40, "lines")),
    
    # SUB-TITLE
    plot.subtitle = element_text(margin = margin(10, 0, 20, 0),
                                 size = 16,
                                 family = body_font,
                                 color = "grey15"),
    # Caption
    plot.caption = element_text(family=body_font,
                                face="plain",
                                size=14, 
                                color="grey40",
                                hjust=.5,
                                margin=margin(20,0,0,0))
    
  ) #+
  # labs(
  #   title = "Earnings of Top 20 Female Athletes",
  #   subtitle = "in 2024",
  #   caption = "Every Box represents $1M | Visual: Vlad Mijatovic"
  # )


# save

# Print plot to screen 
print(p)

ggsave(
  "images/waffle_top_20_female.png",
  plot = p,
  dpi=320, 
  width = 12, 
  height = 7,
  bg = "white"
)

showtext_auto(FALSE)



# Make dataframe for Christiano Ronaldo ----------------------------------------
# very simple - his total earnings in 2024 were $260M USD


christiano_df <- 
  as_tibble(
    list(
    name = "Christiano Ronaldo",
    total_earning = 260
    )
  )




# Draw Christiano Ronaldo -------------------------------------------------



christiano_df |> 
  mutate(name = fct_reorder(name, 
                            total_earning, 
                            desc)) |> 
  ggplot(aes(
    fill = name, 
    values = total_earning
  )) +
  geom_waffle(color = "white", 
              size = .25, 
              n_rows = 10, 
              flip = TRUE)+ 
  facet_wrap(~ name, 
             nrow = 10, 
             strip.position = "bottom") +
  scale_x_discrete() + 
  scale_y_continuous(labels = function(x) x * 10, # make this multiplyer the same as n_rows
                     expand = c(0,0))+
  scale_fill_manual(values=unname(glasbey())) +
  coord_equal() +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_blank(),
    
    # legend
    legend.position = 'none',
    
    # TITLE
    plot.title.position = "plot",
    plot.title = element_textbox(margin = margin(10, 0, 10, 0),
                                 size = 30,
                                 family = title_font,
                                 face = "bold",
                                 width = unit(40, "lines")),
    
    # SUB-TITLE
    plot.subtitle = element_text(margin = margin(10, 0, 20, 0),
                                 size = 16,
                                 family = body_font,
                                 color = "grey15"),
    # Caption
    plot.caption = element_text(family=body_font,
                                face="plain",
                                size=14, 
                                color="grey40",
                                hjust=.5,
                                margin=margin(20,0,0,0))
  ) #+
  # labs(
  #   title = "Earnings of Christiano Ronaldo",
  #   subtitle = "in 2024"
  # )
  # 



showtext_opts(dpi = 320)



# Save Plot ---------------------------------------------------------------


ggsave(
  "img/graph/web-waffle-for-time-evolution.png",
  dpi=320, width = 12, height = 9
)
showtext_auto(FALSE)
