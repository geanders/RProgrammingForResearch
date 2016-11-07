shinyUI(fluidPage(
        
        titlePanel("Tweets during Paris Attack"),
        
        sidebarLayout(position = "right",
                sidebarPanel("Choose what to display",
                             sliderInput(inputId = "time_range",
                                         label = "Select the time range: ",
                                         value = c(as.POSIXct("2015-11-13 00:00:00", tz = "CET"),
                                                   as.POSIXct("2015-11-15 06:00:00", tz = "CET")), 
                                         min = as.POSIXct("2015-11-13 00:00:00", tz = "CET"),
                                         max = as.POSIXct("2015-11-14 12:00:00", tz = "CET"),
                                         step = 60,
                                         timeFormat = "%dth %H:%M",
                                         timezone = "+0100")),
                mainPanel("Map of tweets",
                          plotOutput("twitter_map"))
        )
))