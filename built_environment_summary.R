# load packages
library(tidyverse)
library(dplyr)
library(tidyr)
library(readxl)
library(magrittr)
library(urbnthemes)
library(ggplot2)
library(openxlsx)
library(lubridate)
library(janitor)
library(naniar)
library(scales)
library(ggrepel) 
library(stringr)
library(utils)
library(tidylog)
library(rrapply)
library(mdthemes)
library(sf)
library(skimr)
library(stringi)
library(tigris)
library(ggridges)
library(ggtext)

options(scipen = 100)

# load data 
finaldata <- st_read("https://services.arcgis.com/neT9SoYxizqTHZPH/arcgis/rest/services/Built_Environment_Indicators/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson", quiet = TRUE) %>%
  mutate(GEOID = as.character(GEOID)) %>%
  st_drop_geometry()

# get DC tracts
dc_tracts <- tracts(
  state = "DC",
  year = 2021,
  progress_bar = FALSE
) %>%
  st_transform(crs = 6487)

# get DC wards
dc_wards <- st_read("https://maps2.dcgis.dc.gov/dcgis/rest/services/DCGIS_DATA/Administrative_Other_Boundaries_WebMercator/MapServer/53/query?outFields=*&where=1%3D1&f=geojson", quiet = TRUE) %>%
  st_transform(crs = 6487) %>%
  select(WARD, NAME, GEOID, geometry)

#----------- series of ridgeline plots for each driver
set_urbn_defaults(style = "print")

finaldata %>%
  select(m1_1_schools:m1_9_recreation_center) %>%
  pivot_longer(
    cols = m1_1_schools:m1_9_recreation_center,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m1_1_schools" ~ "Schools (within 15-minute walk)",
                           measure == "m1_2_quality" ~ "Modernized schools (within 15-minute walk)",
                           measure == "m1_3_playgrounds" ~ "Playgrounds (within 10-minute walk)",
                           measure == "m1_4_crossing_guards" ~ "Crossing guards (within 2-minute walk)",
                           measure == "m1_5_safe_passage" ~ "Safe Passage area",
                           measure == "m1_6_library" ~ "Libraries (within 15-minute walk)",
                           measure == "m1_7_wireless_hotspot" ~ "Wireless hotspots (within 15-minute walk)",
                           measure == "m1_8_broadband" ~ "Broadband internet access",
                           measure == "m1_9_recreation_center" ~ "Recreation center (within 15-minute walk)")) %>%
  mutate(label = factor(label, levels = c("Safe Passage area", "Crossing guards (within 2-minute walk)",
                                          "Modernized schools (within 15-minute walk)", 
                                          "Broadband internet access",
                                          "Playgrounds (within 10-minute walk)",
                                          "Libraries (within 15-minute walk)",
                                          "Recreation center (within 15-minute walk)",
                                          "Wireless hotspots (within 15-minute walk)",
                                          "Schools (within 15-minute walk)"))) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn() + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") +
  ggtitle("Distribution of Education Data Measures Across DC Neighborhoods") 

ggsave("ridgeline1.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m2_1_commute) %>%
  pivot_longer(
    cols = m2_1_commute,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m2_1_commute" ~ "Commute less than 45 minutes")) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_yellow) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of the Employment Data Measure Across DC Neighborhoods") 

ggsave("ridgeline2.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m3_1_banks, m3_2_check_cashing) %>%
  pivot_longer(
    cols = m3_1_banks:m3_2_check_cashing,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m3_1_banks" ~ "Banking institutions (within 15-minute walk)",
                           measure == "m3_2_check_cashing" ~ "Check cashing places (not within 15-minute walk)")) %>%
  mutate(label = factor(label, levels = c("Check cashing places (not within 15-minute walk)",
                                          "Banking institutions (within 15-minute walk)"))) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_magenta) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Financial Institution Data Measures Across DC Neighborhoods") 

ggsave("ridgeline3.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m4_1_quality:m4_4_vacant_buildings) %>%
  pivot_longer(
    cols = m4_1_quality:m4_4_vacant_buildings,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m4_1_quality" ~ "Housing stock quality",
                           measure == "m4_2_share_since_1970" ~ "Share of homes built since 1970",
                           measure == "m4_3_affordable" ~ "Share of homes that are affordable",
                           measure == "m4_4_vacant_buildings" ~ "Vacant or blighted homes (not within 2-minute walk)")) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_green) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Housing Data Measures Across DC Neighborhoods") 

ggsave("ridgeline4.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m5_1_buses:m5_6_parking) %>%
  pivot_longer(
    cols = m5_1_buses:m5_6_parking,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m5_1_buses" ~ "Buses (within 2-minute walk)",
                           measure == "m5_2_metro" ~ "Metro stations (within 15-minute walk)",
                           measure == "m5_3_capital_bikeshare" ~ "Capital Bikeshare (within 5-minute walk)",
                           measure == "m5_4_bike_lanes" ~ "Road area covered by bike lanes",
                           measure == "m5_5_sidewalk_quality" ~ "311 requests that are not for sidewalk repair",
                           measure == "m5_6_parking" ~ "Not alleys or parking lots")) %>%
  mutate(label = factor(label, levels = c("Road area covered by bike lanes",
                                          "Buses (within 2-minute walk)",
                                          "Not alleys or parking lots",
                                          "Metro stations (within 15-minute walk)",
                                          "Capital Bikeshare (within 5-minute walk)",
                                          "311 requests that are not for sidewalk repair"))) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_gray) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Transportation Data Measures Across DC Neighborhoods") 

ggsave("ridgeline5.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m6_1_grocery_store:m6_6_liquor_store) %>%
  pivot_longer(
    cols = m6_1_grocery_store:m6_6_liquor_store,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m6_1_grocery_store" ~ "Grocery stores (within 15-minute walk)",
                           measure == "m6_2_low_food_access" ~ "Not in Low Food Access areas",
                           measure == "m6_3_farmers_markets" ~ "Farmers Markets (within 15-minute walk)",
                           measure == "m6_4_healthy_corner_store" ~ "Healthy corner stores (within 15-minute walk)",
                           measure == "m6_5_restaurants" ~ "Restaurants (within 5-minute walk)",
                           measure == "m6_6_liquor_store" ~ "Liquor stores (not within 15-minute walk)")) %>%
  mutate(label = factor(label, levels = c("Liquor stores (not within 15-minute walk)",
                                          "Not in Low Food Access areas",
                                          "Restaurants (within 5-minute walk)",
                                          "Healthy corner stores (within 15-minute walk)",
                                          "Farmers Markets (within 15-minute walk)",
                                          "Grocery stores (within 15-minute walk)"))) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_cyan) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Food Environment Data Measures Across DC Neighborhoods") 

ggsave("ridgeline6.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m7_1_health_care:m7_2_mental_health) %>%
  pivot_longer(
    cols = m7_1_health_care:m7_2_mental_health,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m7_1_health_care" ~ "Health care facilities (within 15-minute walk)",
                           measure == "m7_2_mental_health" ~ "Mental health facilities and providers (15-minute walk)")) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_magenta) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Medical Care Data Measures Across DC Neighborhoods") 

ggsave("ridgeline7.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m8_1_urban_tree_canopy:m8_6_flood_plains) %>%
  pivot_longer(
    cols = m8_1_urban_tree_canopy:m8_6_flood_plains,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m8_1_urban_tree_canopy" ~ "Urban tree canopy",
                           measure == "m8_2_parks" ~ "Parks (within 10-minute walk)",
                           measure == "m8_3_trails" ~ "Trails (within quarter-mile)",
                           measure == "m8_4_land_use" ~ "Mix of land uses",
                           measure == "m8_5_positive" ~ "Positive land use",
                           measure == "m8_6_flood_plains" ~ "Not within flood plain")) %>%
  mutate(label = factor(label, levels = c("Urban tree canopy",
                                          "Mix of land uses",
                                          "Trails (within quarter-mile)",
                                          "Parks (within 10-minute walk)",
                                          "Positive land use",
                                          "Not within flood plain"))) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_green) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Outdoor Environment Data Measures Across DC Neighborhoods") 

ggsave("ridgeline8.png", bg="white", height = 6, width = 8)

finaldata %>%
  select(m9_1_vacant_lots:m9_5_HIN) %>%
  pivot_longer(
    cols = m9_1_vacant_lots:m9_5_HIN,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  mutate(label = case_when(measure == "m9_1_vacant_lots" ~ "Vacant lots (not within 2-minute walk)",
                           measure == "m9_2_streetlights" ~ "Sidewalks covered by streetlights",
                           measure == "m9_3_police" ~ "Police departments (within 15-minute walk)",
                           measure == "m9_4_fire_stations" ~ "Fire stations (within 15-minute walk)",
                           measure == "m9_5_HIN" ~ "High Injury Network Corridor (not within 250 feet)")) %>%
  mutate(label = factor(label, levels = c("Sidewalks covered by streetlights",
                                          "Police departments (within 15-minute walk)",
                                          "High Injury Network Corridor (not within 250 feet)",
                                          "Fire stations (within 15-minute walk)",
                                          "Vacant lots (not within 2-minute walk)"))) %>%
  ggplot(mapping = aes(x = value, y = label, fill = stat(x))) + 
  geom_density_ridges_gradient(scale = 3, size = 0.3) + 
  scale_fill_gradientn(colors = palette_urbn_gray) + 
  labs(x = "Share of neighborhood with given built environment characteristic",
       y = NULL) + 
  scale_x_continuous(labels = scales::percent,
                     limits = c(-0.1, 1.1),
                     breaks = 0:5 * 0.2) +
  theme(legend.position = "none") + 
  ggtitle("Distribution of Community Safety Data Measures Across DC Neighborhoods") 

ggsave("ridgeline9.png", bg="white", height = 6, width = 8)


#--------------- series of maps for each driver
set_urbn_defaults(style = "map")

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d1_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2"
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) +
  ggtitle("Overall Education Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the nine education built environment features"))

ggsave("education.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d2_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_yellow
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Employment Driver Score") + 
  labs(caption = paste("**Note:**", "This driver consists of one employment built environment feature")) 

ggsave("employment.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d3_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    limits=c(0,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    na.value = "#d2d2d2",
    colors = palette_urbn_magenta
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Financial Institutions Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the two financial institutions built environment features")) 

ggsave("financialinstitutions.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d4_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_green
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Housing Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the four housing built environment features"))

ggsave("housing.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d5_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_gray
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Transportation Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the six transportation built environment features"))

ggsave("transportation.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d6_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_cyan
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Food Environment Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the six food environment built environment features"))

ggsave("foodenvironment.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d7_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_magenta
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Medical Care Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the two medical care built environment features"))

ggsave("medicalcare.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d8_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_green
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Outdoor Environment Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the six outdoor environment built environment features"))

ggsave("outdoor.png", bg="white", height = 8, width = 8)

dc_tracts %>%
  full_join(finaldata, by = c("GEOID")) %>%
  ggplot() + 
  geom_sf(aes(fill = d9_scale)) + 
  scale_fill_gradientn(
    #labels = scales::percent_format(),
    name = "Percentiles",
    breaks=c(0,0.25,0.5,0.75,1),
    labels = c("Lower", "", "Middle", "",  "Higher"),
    limits=c(0,1),
    na.value = "#d2d2d2",
    colors = palette_urbn_gray
  ) + 
  geom_sf(data = dc_wards, color = "white", fill = "transparent", linewidth = 1) +
  theme(legend.direction = "vertical", legend.box = "vertical",
        plot.caption = element_markdown(hjust = 0, size = 9),
        legend.title = element_text(face = "bold", size = 10)) + 
  ggtitle("Overall Community Safety Driver Score") + 
  labs(caption = paste("**Note:**", "This driver is a weighted average of the five community safety built environment features"))

ggsave("communitysafety.png", bg="white", height = 8, width = 8)

#-------------------------------- overall summary figure
library(urbnthemes)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggsvg)
library(ggdist)
library(ggtext)
library(scales)

set_urbn_defaults(style = "print")

#Use hex from RdYlGn palette in Colour Brewer
green_red_palette <- scales:::brewer_pal(type = "div", palette = "RdYlGn")(11)
green_red_palette_dark <- colorspace::darken(green_red_palette, amount = 0.2)

ggwashinfographic <- finaldata %>%
  select(m1_1_schools:m9_5_HIN) %>%
  pivot_longer(
    cols = m1_1_schools:m9_5_HIN,
    names_to = "measure",
    values_to = "value"
  ) %>%
  filter(!is.na(value)) %>%
  # create all labels
  mutate(label = case_when(measure == "m1_1_schools" ~ "Schools",
                           measure == "m1_2_quality" ~ "Modernized schools",
                           measure == "m1_3_playgrounds" ~ "Playgrounds",
                           measure == "m1_4_crossing_guards" ~ "Crossing guards",
                           measure == "m1_5_safe_passage" ~ "Safe Passage area",
                           measure == "m1_6_library" ~ "Libraries",
                           measure == "m1_7_wireless_hotspot" ~ "Wireless hotspots",
                           measure == "m1_8_broadband" ~ "Broadband internet access",
                           measure == "m1_9_recreation_center" ~ "Recreation center",
                           measure == "m2_1_commute" ~ "Commutes",
                           measure == "m3_1_banks" ~ "Banking institutions",
                           measure == "m3_2_check_cashing" ~ "Not close to check cashing places",
                           measure == "m4_1_quality" ~ "Housing stock quality",
                           measure == "m4_2_share_since_1970" ~ "Share of homes built since 1970",
                           measure == "m4_3_affordable" ~ "Share of homes that are affordable",
                           measure == "m4_4_vacant_buildings" ~ "Not close to vacant or blighted homes",
                           measure == "m5_1_buses" ~ "Buses",
                           measure == "m5_2_metro" ~ "Metro stations",
                           measure == "m5_3_capital_bikeshare" ~ "Capital Bikeshare",
                           measure == "m5_4_bike_lanes" ~ "Road area covered by bike lanes",
                           measure == "m5_5_sidewalk_quality" ~ "311 requests that are not for sidewalk repair",
                           measure == "m5_6_parking" ~ "Not alleys or parking lots",
                           measure == "m6_1_grocery_store" ~ "Grocery stores",
                           measure == "m6_2_low_food_access" ~ "Not in Low Food Access areas",
                           measure == "m6_3_farmers_markets" ~ "Farmers Markets",
                           measure == "m6_4_healthy_corner_store" ~ "Healthy corner stores",
                           measure == "m6_5_restaurants" ~ "Restaurants",
                           measure == "m6_6_liquor_store" ~ "Not close to liquor stores",
                           measure == "m7_1_health_care" ~ "Health care facilities",
                           measure == "m7_2_mental_health" ~ "Mental health facilities and providers",
                           measure == "m8_1_urban_tree_canopy" ~ "Urban tree canopy",
                           measure == "m8_2_parks" ~ "Parks",
                           measure == "m8_3_trails" ~ "Trails",
                           measure == "m8_4_land_use" ~ "Mix of land uses",
                           measure == "m8_5_positive" ~ "Positive land use",
                           measure == "m8_6_flood_plains" ~ "Not within flood plain",
                           measure == "m9_1_vacant_lots" ~ "Not close to vacant lots",
                           measure == "m9_2_streetlights" ~ "Sidewalks covered by streetlights",
                           measure == "m9_3_police" ~ "Police stations",
                           measure == "m9_4_fire_stations" ~ "Fire stations",
                           measure == "m9_5_HIN" ~ "Not close to High Injury Network Corridor"))

measure_data <- ggwashinfographic %>%
  # get the descriptive stats we need
  group_by(label) %>%
  summarize(mean = mean(value),
            N = n(),
            se = sd(value)/sqrt(n()),
            min = min(value),
            max = max(value)) %>%
  mutate(across(label, .fns = ~forcats::fct_reorder(., .x = mean, .fun = first))) %>% 
  arrange(desc(mean)) %>%
  mutate(rank_number = 1:n()) %>%
  ungroup()

plot_data <- ggwashinfographic %>%
  left_join(measure_data, by = "label") %>%
  mutate(across(label, .fns = ~forcats::fct_reorder(., .x = mean, .fun = first))) 

ggplot() + 
  stat_gradientinterval(data = plot_data, aes(y = label, x = value, color = mean, fill = mean, thickness = after_stat(pdf), width = 1),
                        scale = 1, slab_alpha = 0.6, fill_type = "gradient", geom = "slabinterval", 
                        point_interval = "mean_qi", size = 10, point_size = 0,
                        slab_linewidth = 5, position = "identity") + 
  geom_point(data = measure_data,
             aes(y = label, x = mean),
             shape = 21, size = 2, stroke = 0.25, color = "black", fill = "black",
             alpha = 0.4) +
  scale_color_gradientn(
    colors = green_red_palette_dark
  ) + 
  geom_vline(xintercept = c(0.75, 0.5, 0.25), lty = 2, size = 0.25) +
  geom_richtext(aes(x = c(0.875, 0.125),
                    y = 42,
                    label = c(paste0("<span style='color:",
                                     green_red_palette[11],
                                     ";'>High Proximity</span>"),
                              # paste0("<span style='color:",
                              #        green_red_palette[5],
                              #        ";'>Medium</span>"),
                              paste0("<span style='color:",
                                     green_red_palette[1],
                                     ";'>Low Proximity</span>"))),
                label.colour = NA, fontface = "bold",
                fill = NA, hjust = 0.5, vjust = -0.6) +
  #theme_classic() +
  theme(axis.ticks.y = element_blank(),
        axis.ticks.x = element_line(size = 0.25, lineend = "round"),
        axis.line = element_blank(),
        legend.position = "none",
        panel.grid.major = element_blank(),
        plot.margin = margin(r = 10, l = 20, t = 5, b = 5),
        #plot.background = element_rect(fill = "#fafafa", colour = NA),
        #panel.background = element_rect(fill = "#fafafa", colour = NA),
        plot.caption = element_markdown(hjust = 0, size = 8),
        plot.title = element_markdown(size = 12),
        plot.subtitle = element_markdown(size = 9)) + 
  geom_segment(aes(x = 1, xend = 0, y = 42, yend = 42),
               size = 0.25, lineend = "round") +
  scale_x_continuous(position = "top",
                     labels = scales::percent,
                     trans = "reverse", limits = c(1,0),
                     expand = c(0,0)) +
  scale_y_discrete(expand = c(0,0)) +
  coord_cartesian(clip = 'off') +
  ggtitle("How close are DC neighborhoods to parks, libraries, and other features of the built<br>environment?") +
  labs(y = NULL,
       x = NULL,
       subtitle = paste0("Neighborhoods are closer to education, transportation, and financial institution features but have lower levels of access to<br>affordable housing."),
       caption = paste0("**Source:** District of Columbia Built Environment Indicators and Health Interactive Map Tool<br>**Notes:** Black dots represent the average DC neighborhood"))

ggsave(filename = "infographic.png", bg="white", height = 7, width = 7)





