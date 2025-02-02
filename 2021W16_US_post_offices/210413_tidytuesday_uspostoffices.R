library(tidytuesdayR)
library(tidyverse)
library(maps)
library(gganimate)

setwd("~/Desktop/R/TidyTuesday/github_repo/2021W16_US_post_offices")

# Read in the data from the tidy tuesday library.
tuesdata <- tidytuesdayR::tt_load(2021, week = 16)
df_us_postoffices <- data.frame(tuesdata[1])

# This is the data for the basic map.
states <- map_data("state")

# Here I filter the dataframe to keep only the entries that I want to display.
df_us_postoffices_2 <- df_us_postoffices %>%
  filter(between(post_offices.longitude, -126, -60) &
           post_offices.established >= 1639)

# Now creating the basic map
theme_set(theme_void())
gg1 <- ggplot() +
  geom_polygon(data = states, aes(x = long, y = lat, group = group), fill = "tan", color = "grey94") +
  coord_fixed(1.3)

# Adding the points to it
plot_est <- gg1 +
  geom_point(data = df_us_postoffices_2, aes(x = `post_offices.longitude`, y = `post_offices.latitude`), 
             color = "#004B87", size = 0.001) +
  theme(plot.title = element_text(size = 17, family = "Serif", hjust = .25, 
                                margin = margin(b = -8, unit = "pt"), color = "#004B87")) +
  transition_manual(`post_offices.established`, cumulative = TRUE) +
  labs(title = "Post Offices established in mainland USA in: {current_frame}")

# Animating the map and saving it to the drive
anim <- animate(plot_est, height = 500, width = 800)
anim_save("US_postoffices_est.gif", anim)

