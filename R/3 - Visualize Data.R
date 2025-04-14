# load libraries

library(tidyverse)


# load data

top_20 <- read_rds("./data_processed/top_20.rds")

# process data

top_20 <- 
  top_20 |> 
  mutate(total = on_field + off_field)

top_20_ordered <- 
  top_20 |> 
  arrange(total)

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
  geom_bar(stat = "identity") +
  coord_flip()

