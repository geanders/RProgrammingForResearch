library(ggmap)
library(ggplot2)
library(BH)
library(dplyr)
library(lubridate)
library(ggthemes)
library(scales)


paris_twitter <- read.csv("data/final_tweets.csv", as.is = TRUE) %>%
        mutate(twitter_tag = factor(tag),
               text = iconv(text, to='ASCII//TRANSLIT'))
paris_twitter$created <- as.POSIXct(paris_twitter$created, tz = "CET")
paris_twitter_map <- filter(paris_twitter, complete.cases(paris_twitter))



shinyServer(function(input, output, session) {
               
        to_plot <- reactive({paris_twitter_map %>% 
                        filter(as.numeric(created) >= input$time_range[1] &
                                       as.numeric(created) <= input$time_range[2] & 
                                       tag %in% input$tag)
                })
        
        dataInBounds <- reactive({
                #df <- to_plot()
                df <- paris_twitter %>% filter(tag %in% input$tag)
                if (is.null(input$map_bounds))
                        return(df[FALSE,])
                bounds <- input$map_bounds
                latRng <- range(bounds$north, bounds$south)
                lngRng <- range(bounds$east, bounds$west)
                
                subset(df,
                       latitude >= latRng[1] & latitude <= latRng[2] &
                               longitude >= lngRng[1] & longitude <= lngRng[2])
        })
        
        output$map <- renderLeaflet({
                leaflet(paris_twitter_map) %>%  addProviderTiles("CartoDB.Positron") %>%
                        fitBounds(~min(longitude, na.rm = TRUE),
                                  ~min(latitude, na.rm = TRUE),
                                  ~max(longitude, na.rm = TRUE),
                                  ~max(latitude, na.rm = TRUE))
        })
        
        observe({
                if(nrow(to_plot())==0) { leafletProxy("map") %>% clearMarkers()} 
                else {
                       leafletProxy("map", data = to_plot()) %>% 
                                clearMarkers() %>%
                               addCircleMarkers(~longitude, ~latitude, 
                                                radius = 4,
                                                stroke = FALSE,
                                                fillOpacity = 0.5,
                                                popup = ~text
                                                ) 
                }
        })
        
        df <- reactive({
                paris_twitter %>% filter(tag %in% input$tag) %>%
                        mutate(in_time = factor(as.numeric(created) >= input$time_range[1] &
                                       as.numeric(created) <= input$time_range[2],
                               levels = c(TRUE, FALSE)))
        })
        
        output$twitter_hist <- renderPlot({
                ggplot(df(), aes(x = created, fill = in_time)) + 
                        geom_histogram(binwidth = 20 * 60) + 
                        scale_x_datetime(name = "Time of tweet",
                                         limits = c(as.POSIXct("2015-11-13 21:00:00", tz = "CET"),
                                                    as.POSIXct("2015-11-15 06:00:00", tz = "CET")),
                                         breaks = date_breaks("6 hour"),
                                         labels = date_format("%I %p")) + 
                        ylab("# of tweets") +
                        theme_bw() + 
                        scale_fill_manual(values=c("blue", "gray"),
                                          guide = FALSE)
        })
        
        df2 <- reactive({
                paris_twitter %>% filter(tag %in% input$tag & 
                                         as.numeric(created) >= input$time_range[1] &
                                         as.numeric(created) <= input$time_range[2])
        })
        
        output$examples <- DT::renderDataTable({
                df2() %>% select(text) %>% mutate(text = sample(text))
        }, rownames = FALSE, colnames = c("Example tweets for selected tag and time"),
        filter = 'none', options = list(
                pageLength = 5, autoWidth = TRUE))
})