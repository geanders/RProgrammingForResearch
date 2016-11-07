# paris_map <- get_map("paris", zoom = 12, color = "bw")
# save(paris_map, file = "data/paris_map.RData")
load("data/paris_map.RData")

# paris_locations <- c("Stade de France", "18 Rue Alibert",
#                      "50 Boulevard Voltaire", "92 Rue de Charonne",
#                      "Place de la Republique")
# paris_locations <- paste(paris_locations, "paris france")
# paris_locations <- cbind(paris_locations, geocode(paris_locations))
# save(paris_locations, file = "data/paris_locations.RData")
load("data/paris_locations.RData")

# paris_twitter <- read.csv("data/final_tweets.csv", as.is = TRUE) %>%
#         mutate(tag = factor(tag))
# paris_twitter$created <- as.POSIXct(paris_twitter$created, tz = "CET")
# save(paris_twitter, file = "data/paris_twitter.RData")
load("data/paris_twitter.RData")

# Plot contour map of tweet locations
plot_map <- function(tag = "all", df = paris_twitter, 
                     start.time = "2015-11-13 00:00:00",
                     end.time = "2015-11-15 06:00:00"){
        library(ggmap)
        library(dplyr)
        
        start.time <- as.POSIXlt(start.time, tz = "CET")
        end.time <- as.POSIXlt(end.time, tz = "CET")
        
        df <- dplyr::select(df, tag, latitude, longitude, created) %>%
                filter(!is.na(longitude) & created > start.time & created < end.time) %>%
                mutate(tag = as.character(tag))
        
        if(tag != "all"){
                if(!(tag %in% df$tag)){
                        stop(paste("That tag is not in the data. Try one of the following tags instead: ", paste(unique(df$tag), collapse = ", ")))
                }
                to_plot <- df[df$tag == tag, ]
        } else {
                to_plot <- df
        }
        
        my_map <- ggmap(paris_map, extent = "device") + 
                geom_point(data = to_plot, aes(x = longitude, y = latitude),
                           color = "darkgreen", alpha = 0.75) +
                geom_density2d(data = to_plot, 
                               aes(x = longitude, latitude), size = 0.3) + 
                stat_density2d(data = to_plot, 
                               aes(x = longitude, y = latitude,
                                   fill = ..level.., alpha = ..level..),
                               size = 0.01, bins = round(nrow(to_plot) / 3.3),
                               geom = "polygon") +
                scale_fill_gradient(low = "green", high = "yellow", guide = FALSE) + 
                scale_alpha(guide = FALSE) + 
                geom_point(data = paris_locations, aes(x = lon, y = lat),
                           color = "red", size = 5, alpha = 0.75) 
        return(my_map)
}