##### ggplot2 Tutorial

##### Install or load packages ------------------------------------------------

# Tidyverse is the uber-package containing ggplot

#install.packages("tidyverse")
library(tidyverse)

# Palmer penguins is the data set we'll be using

#install.packages("palmerpenguins")
library(palmerpenguins)

##### Clean Data --------------------------------------------------------------

# The dataset "penguins" now exists because the package is loaded
head(penguins)

# Remove NAs
penguins_clean <- penguins %>%
  filter(!is.na(body_mass_g))
# notice that 2 rows were removed, these had NA's in all columns but species and island.
#waldo::compare(penguins, penguins_clean)

# Choosing the plots to consider
# Flow chart: https://www.data-to-viz.com/
str(penguins_clean)

# Let's focus on the relationship between bill depth and bill length.
# Possible hypothesis: bill length depends on bill depth, because a larger base allows for a longer beak.

##### Ggplot2 core functions --------------------------------------------------

# 1. Data

# Step 1 is telling ggplot what data to use.

ggplot(data = penguins_clean)

# 2. Mapping

ggplot(data = penguins_clean, mapping = aes(x = bill_depth_mm, y = bill_length_mm))

# aes = aesthetics
# Axes are generating but no data points.
# We're mapping out what data we will use, but there are no geometry
# layers yet.

# 3. Geom Layers

ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point()

# 4. Adding aes to layers

# Color by species
ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species))

# Color by sex
ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = sex))

# Piping to remove NAs
penguins_clean %>%
  filter(!is.na(sex)) %>%
  ggplot(mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = sex))

# Color by body size
ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = body_mass_g)) +
  geom_point()

# 5. Scale

# Color by body size
ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = body_mass_g)) +
  geom_point() +
  scale_colour_viridis_c()

# Color by species, recolor by hexes
ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4"))
#scale_color_manual(values = c("#ff6e00","#c45ccb","#057276"))
#https://imagecolorpicker.com/


# 6. Facets
penguins_clean %>%
  filter(!is.na(sex)) %>%
  ggplot(data = .,
         mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  facet_wrap(~sex)#, ncol = 1)

#There is a clear sex effect, but we're not including that in this plot.

# 7. Coordinates

ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  #coord_cartesian(xlim = c(15,20)) # zooms in, does not remove data
  xlim(c(15,20)) # limits the data, notice the warning message

ggplot(data = penguins_clean,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  coord_flip()

# 8. Theme

penguins_clean %>%
  filter(!is.na(sex)) %>%
  ggplot(
    data = .,
    mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(name = "Species",
                     values = c("darkorange", "darkorchid", "cyan4")) +
  theme_bw() +
  xlab("Bill Depth (mm)") + ylab("Bill Length (mm)") +
  labs(color = "Species")

##### Final plot --------------------------------------------------------------

# The relationship between bill length and bill depth for 3 species of penguins

penguins_clean %>%
  ggplot(
    data = .,
    mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = "lm") +
  scale_color_manual(name = "Species",
                     values = c("darkorange", "darkorchid", "cyan4")) +
  theme_bw() +
  xlab("Bill Depth (mm)") + ylab("Bill Length (mm)") +
  labs(color = "Species")

# save this plot as an image

ggsave("penguins_bill_length_depth.pdf", width = 4, height = 3, units = "in")
