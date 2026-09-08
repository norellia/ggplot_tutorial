##### ggplot2 Tutorial

# Install or load packages

# Tidyverse is the uber-package containing ggplot
#install.packages("tidyverse")
library(tidyverse)
#install.packages("palmerpenguins")
library(palmerpenguins)

# The dataset "penguins" now exists because the package is loaded
penguins <- penguins
head(penguins)
str(penguins)

# Remove NAs
penguins %>%
  filter(!is.na(bill_depth_mm))

# 1. Data

ggplot(data = penguins)

# 2. Mapping

ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm))

# aes = aesthetics
# Axes are generating but no data points.
# We're mapping out what data we will use, but there are no geometry
# layers yet.

# 3. Geom Layers

ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point()

# 4. Adding aes to layers

# Color by species
ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species))

# Color by sex
ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = sex))

# Piping to remove NAs
penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = sex))

# Color by body size
ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = body_mass_g)) +
  geom_point()

# 5. Scale

# Color by body size
ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = body_mass_g)) +
  geom_point() +
  scale_colour_viridis_c()

# 6. Facets
ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = sex)) +
  geom_point() +
  scale_color_discrete() +
  facet_wrap(~species)

# 7. Coordinates
ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = sex)) +
  geom_point() +
  facet_wrap(~species)

# 8. Theme

ggplot(data = penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  facet_wrap(~sex, ncol = 1) +
  theme_bw() +
  xlab("Bill Depth (mm)") + ylab("Bill Length (mm)")
