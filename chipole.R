library(tidyverse)
library(ggplot2)
library(usmap)
library(leaflet)
library(maps)
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


plot_usmap(data = count, values = "count") + scale_fill_continuous(low = "white", high = "red", name = "count", label = scales::comma) + theme(legend.position = "right") 


# II. pin-points of chipole restaurants -----------------------------------



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



# us chipole marker -------------------------------------------------------

mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
    addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

m = leaflet() %>% addTiles()
df = data.frame(
    lat = location$latitude,
    lng = location$longitude,
    size = 1,
    color = sample(colors(), nrow(location), replace = TRUE)
)
m = leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
