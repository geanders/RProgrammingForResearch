library(ggmap)
library(ggplot2)
library(BH)
library(dplyr)
library(lubridate)

source("helper.R")

shinyServer(function(input, output) {
        output$twitter_map <- renderPlot({
                plot_map(start.time = input$time_range[1],
                         end.time = input$time_range[2])
                })
})