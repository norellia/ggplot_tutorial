##### ggplot2 Tutorial

##### Install or load packages ------------------------------------------------

# Tidyverse is the uber-package containing ggplot

#install.packages("tidyverse")
require(tidyverse)

# Palmer penguins is the data set we'll be using

#install.packages("palmerpenguins")
require(palmerpenguins)



##### Clean Data --------------------------------------------------------------

# The dataset "penguins" now exists because the package is loaded
head(penguins)

# Remove NAs
clean_penguins <- penguins %>%
  filter(!is.na(body_mass_g))
# notice that 2 rows were removed, these had NA's in all columns but species and island.
#waldo::compare(penguins, clean_penguins)

#look at the different types of data available
str(clean_penguins)

# Choosing the plots to consider
# Flow chart: https://www.data-to-viz.com/


# Let's focus on the relationship between bill depth and bill length.
# Possible hypothesis: bill length depends on bill depth, because a larger base allows for a longer beak.



##### Ggplot2 core functions --------------------------------------------------

###### 1. Data ######

# First we tell ggplot what data to use.

ggplot(data = clean_penguins)


###### 2. Mapping ######

# Then we break down the specific columns of data we want to use and "map" them
# to x and y within the aes() function.

ggplot(data = clean_penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm))

# aes = aesthetics
# Axes are generating but no data points.
# We're mapping out what data we will use, but there are no geometry
# layers yet to tell ggplot what to do with the data.



###### 3. Geom Layers ######

# There are a lot of different geom layers that all start with "geom_" they have
# a variety of requirements.  The best reference is the ggplot cheatsheet or
# start typing "?geom_" to learn about specific plots.

ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point()

# Layers are added with "+" signs at the end of each line.

# You can have multiple geom layers, and they do not need to reference the same
# data, as long as you set their own data/aes().
# Here we will add a horizontal line at the mean of bill length.
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point() +
  geom_hline(yintercept = 40, linetype = "dashed") +
  geom_line(data = penguins, aes(x = body_mass_g, y = flipper_length_mm))

# you can even add completely irrelevant data that ruins the scale, so be
# mindful of what layers you're adding.


###### 4. Adding aes to layers ######

# You can color by discrete data columns to look at trends
# Color by species
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species))

# You can also color data that is continuous
# Color by body size
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = body_mass_g)) +
  geom_point()



###### 5. Scale ######

# Scale allows you to redefine the default aesthetic settings
# For example, the default colors for ggplot2 are blue, red, and green.
# you can use scale to choose a different preset-value for the colors
# "?scale_" lets you explore all the options.


# Color by species, recolor by color names or hexes
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4"))
#scale_color_manual(values = c("#ff6e00","#c45ccb","#057276"))
#https://imagecolorpicker.com/

# Color by body size using the viridis scale for continuous data
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = body_mass_g)) +
  geom_point() +
  scale_color_viridis_c()




###### 6. Facets ######

# Facets break up a figure into multiple panels. This works great if you have
# multiple factors to compare.

clean_penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(data = .,
         mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  facet_wrap(~sex)#, ncol = 1)

# There is a clear sex effect, but that's not part of the question we originally
# asked.  Faceting isn't nessecary for this plot.



###### 7. Coordinates ######

# The default is coord_cartesian() which zooms the graph range to include all
# your data.  This setting can be used to zoom in on different parts of the
# graph, switch axes, or more specialized transformations.

# First we can change the range shown with coord_cartesian()
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  #coord_cartesian(xlim = c(15,20)) # zooms in, does not remove data
  xlim(c(15,20)) # limits the data, notice the warning message
# or we can use xlim()

# The axes can be flipped with coord_flip()
ggplot(data = clean_penguins,
       mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(values = c("darkorange","darkorchid","cyan4")) +
  coord_flip()



###### 8. Theme ######

# Theme controls the look of all the non-data elements of the plot, axes, fonts,
# background, labels, etc. There are a lot of pre-built settings but you can
# also highly customize it and build your own theme.
# Type "?theme_" to scroll through all the options, or "?theme" to see all
# the settings included in theme.

# Here will we use a pre-set theme and change the legend position.

clean_penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(
    data = .,
    mapping = aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  scale_color_manual(name = "Species",
                     values = c("darkorange", "darkorchid", "cyan4")) +
  theme_bw() +
  theme(legend.position = "top") +
  xlab("Bill Depth (mm)") + ylab("Bill Length (mm)") +
  labs(color = "Species")

##### Final plot --------------------------------------------------------------

# The relationship between bill length and bill depth for 3 species of penguins

clean_penguins %>%
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

ggsave("penguins_bill_length_depth.jpeg", width = 4, height = 3, units = "in")
