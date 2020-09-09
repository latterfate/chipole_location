library(tidyverse)
library(ggplot2)
library(usmap)

# read date
location <- read_csv("chipotle_stores.csv")


# I. over look of chipole count by state ----------------------------------

count <- location %>%
    group_by(state) %>%
    tally()
colnames(count) <- c("full", "count")

data(statepop)

count <- count %>%
    left_join(statepop, by = "full")
count <- count[,1:4]


plot_usmap(data = count, values = "chipole restaurants count") + scale_fill_continuous(low = "white", high = "red", name = "count", label = scales::comma) + theme(legend.position = "right") 


# II. pin-points of chipole restaurants -----------------------------------

library(leaflet)

greenLeafIcon <- makeIcon(
    iconUrl = "http://leafletjs.com/docs/images/leaf-green.png",
    iconWidth = 5, iconHeight = 5,
    iconAnchorX = 5, iconAnchorY = 5,
    shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
    shadowWidth = 5, shadowHeight = 5,
    shadowAnchorX = 5, shadowAnchorY = 5
)

leaflet() %>%
    addTiles() %>%  # Add map tiles
    addMarkers(lng=location[location$location == "Chicago",]$longitude, lat = location[location$location == "Chicago",]$latitude, popup = location$address)
