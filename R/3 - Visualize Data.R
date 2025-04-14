# load libraries

library(tidyverse)
library(ggflags)
library(countrycode)


# load data

top_20 <- read_rds("./data_processed/top_20.rds")

# process data

top_20 <- 
  top_20 |> 
  mutate(total = on_field + off_field)

top_20_ordered <- 
  top_20 |> 
  arrange(total) |> 
  mutate(
    nationality_for_flag = countrycode(nationality, 
                                       origin = 'country.name', 
                                       destination = 'iso2c', 
                                       warn = FALSE) ,
    nationality_for_flag = str_to_lower(nationality_for_flag)
                                       
  )


ordered_data_long <- ordered_data_long %>%
  mutate(
    nationality_for_flag = countrycode,
    nationality_for_flag = tolower(nationality_for_flag)
  )

# 2. Order the data frame by the total
ordered_data <- data_with_total %>%
  arrange(total)

# 3. Convert the data to long format for stacking
ordered_data_long <- 
  top_20_ordered |> 
  pivot_longer(
    cols = c(on_field, off_field), 
    names_to = "earnings", values_to = "millions")

# 4. Create the ggplot
ggplot(data_long, aes(x = factor(group, levels = ordered_data$group), 
                      y = value, 
                      fill = variable)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Stacked Bar Chart of Two Columns",
    x = "Group",
    y = "Total Value",
    fill = "Column"
  ) +
  theme_minimal()

# Visualization -----------------------------------------------------------

ordered_data_long |> 
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
    y = "Millions USD",
    x = ""
  ) +
  scale_fill_manual(
    values = c("darkorchid1", "darkorchid4")
  )



