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


plot_usmap(data = count, values = "count") + scale_fill_continuous(low = "white", high = "red", name = "count", label = scales::comma) + theme(legend.position = "right")

