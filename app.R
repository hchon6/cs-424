library(shiny)
library(shinydashboard)
library(ggplot2)
library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(leaflet)
library(scales)
library(data.table)  
library(plyr)
library(dplyr)

colnames = c("challengeId","litterjoinId","litterId","litterTimestamp","lat", "lon", "tags", "url", "user_id", "username")

input <- if (file.exists("litterati challenge-65.csv")) {
  "litterati challenge-65.csv"
} else {
  "https://www.evl.uic.edu/aej/424/litterati challenge-65.csv"
}

litterati <- fread(input)
litterati

#litterati <- read.table(file = "litterati challenge-65.csv", sep = "\t", header = TRUE)

# Create the shiny dashboard
ui <- dashboardPage(
  dashboardHeader(title = "CS 424 Spring 2020 Project 1"),
  dashboardSidebar(disable = FALSE, collapsed = FALSE,
                   
                   sidebarMenu(
                     menuItem("", tabName = "cheapBlankSpace", icon = NULL),
                     menuItem("", tabName = "cheapBlankSpace", icon = NULL),
                     menuItem("", tabName = "cheapBlankSpace", icon = NULL),
                     menuItem("", tabName = "cheapBlankSpace", icon = NULL),
                     menuItem("", tabName = "cheapBlankSpace", icon = NULL)),
                   menuItem("", tabName = "cheapBlankSpace", icon = NULL)
                   
                   #selectInput("Year", "Select the year to visualize", years, selected = 2019),
                   #selectInput("Room", "Select the room to visualize", listNamesGood, selected = "Meeting Room")
  ),
  dashboardBody(
    fluidRow(
      column(5,
             fluidRow(
               box(title = "Leaflet Map", solidHeader = TRUE, status = "primary", width = 500,
                   leafletOutput("leaf", height = 300)
               )
             ),
             
             fluidRow(
               box(title = "Total Litter Collected: 12646", solidHeader = TRUE, status = "primary", width = 12,
               )
             )
      ),
      
      column(8,
             fluidRow(
               box( title = "Top Ten", solidHeader = TRUE, status = "primary", width = 12,
                    plotOutput("topten", height = 200)
               )
             )
      )
      
     
    )
  ))

server <- function(input, output) {
  
  # increase the default font size
  theme_set(theme_grey(base_size = 18)) 
  
  output$leaf <- renderLeaflet({
    leaflet(data = litterati[1:1000,]) %>% addTiles() %>%
      addMarkers(~lon, ~lat, popup = "Litter")
  })
  
  output$topten <- renderDataTable({
    litterati %>% add_tally()
    
  })
  
}

shinyApp(ui = ui, server = server)
