library(shiny)
library(shinydashboard)
library(dplyr)
library(rgdal)
library(leaflet)
library(RColorBrewer)
library(ggvis)
library(DT)

shinyUI(dashboardPage(
        
        dashboardHeader(title = "Tweets during the Paris Attacks",
                        titleWidth = 400),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
                fluidRow(
                        column(width = 7, 
                               box(width = NULL,
                                   leafletOutput("map", height = 400))),
                        column(width = 5, 
                               box(width = NULL,
                                   sliderInput(inputId = "time_range",
                                               label = "Select the time range: ",
                                               value = c(as.POSIXct("2015-11-13 21:00:00", tz = "CET"),
                                                         as.POSIXct("2015-11-14 01:00:00", tz = "CET")), 
                                               min = as.POSIXct("2015-11-13 21:00:00", tz = "CET"),
                                               max = as.POSIXct("2015-11-15 06:00:00", tz = "CET"),
                                               step = 5 * 60,
                                               timeFormat = "%dth %H:%M",
                                               timezone = "+0100",
                                               animate = TRUE, 
                                               animationOptions(interval = 10)
                                               ),
                                   selectInput(inputId = "tag", 
                                               label = "Select a Twitter tag to map",
                                               choices = c("#PorteOuverte","#Paris", "#PrayForParis",
                                                           "#13novembre",
                                                           "#fusillade", "#Bataclan",
                                                           "Charonne", "Republique", "#ParisAttacks",
                                                           "Voltaire", "Stade de France", "#tristesse",
                                                           "NotAfraid", "Vendredi 13", "#NousSommesUnis",
                                                           "#Pray4Paris", "#rechercheParis", 
                                                           "#attentat"),
                                               selected = "#PorteOuverte"),
                                   hr(),
                                   tabBox(width = NULL,
                                          
                                          tabPanel("About",
                                                   br(),
                                                   p("In the midst of the tragic events last Friday in Paris, one bright spot was 
                                                     the way Parisians communicated, offered sanctuary, and showed support through 
                                                     social media. This application allows users to explore Tweets that had tags related 
                                                     to the attacks and that were geolocated within Paris between 9:00 PM Friday November 13 
                                                     and 6:00 AM Sunday November 15."),
                                                   strong("How to use"),
                                                   p("You can select tweets with a certain tag using the selection box 
                                                     and a time range using the slider. Once a tag and time range are selected, 
                                                     the map will map any tweets with these values that included 
                                                     latitude and longitude values. Many tweets did not have latitude and longitude data. These are represented in other output on this 
                                                     page (the Examples and Time tabs), but not on the map. For tweets that are geolocated, the Twitter user actively selected to override the default location option in their Twitter account to make location data publicly available through the Twitter API.
                                                     You can read a tweet on the map by clicking on it."),
                                                   p("You can further explore this data through the tabs. The", strong("Time"), "tab shows
                                                     the number of tweets for the selected tag over the full time period, with the
                                                     selected time range highlighted. The", strong("Examples"),"tab gives random examples
                                                     of tweets with the selected tag over the selected time range."),
                                                   strong("Data sources"),
                                                   p("I pulled all data from Twitter's API using the R package",
                                                     a("twitteR.",
                                                       href = "https://github.com/geoffjentry/twitteR"), 
                                                     "I pulled only tweets associated with a location within a 5 mile radius of 
                                                     the center of Paris. This means that these tweets might not include everything tweeted in Paris over this time period. Instead, these are tweets that either included geolocation data for the tweet (by the user enabling location on their Twitter account) or are from Twitter users whose profiles specify a general location for the user within 5 miles of the center of Paris. 
                                                     The tags used were selected in part
                                                     based on trending tags over November 13 and 14."),
                                                   strong("Credits"),
                                                   p("The code for this application was directly adapted from Henry Partridge's wonderful",
                                                     a("STATS19 scanner Shiny application",
                                                       href = "https://pracademic.shinyapps.io/STATS19_scanner"),
                                                     "(code for that Shiny application is ",
                                                     a("available here",
                                                       href = "https://github.com/cat-lord/STATS19_scanner"), 
                                                     "). Any derivations of this application should attribute that code. The application uses the ",
                                                     a("leaflet",
                                                       href = "https://rstudio.github.io/leaflet/"), " and ",
                                                     a("DT",
                                                       href = "https://rstudio.github.io/DT/"), " R packages."),
                                                   br(),
                                                   p("Repo here: ",
                                                     a(href = "https://github.com/geanders/RCourseFall2015/tree/master/Week12_Nov16/App-2", icon("github"), target = "_blank"))),
                                                   
                                                   tabPanel("Time",
                                                            h5("Number of tweets for the tag by time",
                                                               style = "color:black", align = "center"),
                                                            plotOutput("twitter_hist", height = "200px")
                                                   ),
                                                   tabPanel("Examples",
                                                            DT::dataTableOutput("examples"))
                                                   
                                                   
                                          )
                                          
                                          ))
                                   )
                ),
        skin = "black"))
        