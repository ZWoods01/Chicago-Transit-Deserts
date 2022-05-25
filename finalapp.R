# set wd, load libraries, load data
setwd("~/Desktop/chiTransitDesertsProj")
library(sf)
library(shiny)
library(rgdal)
library(rgeos)
library(tmap)
library(leaflet)
library(plotly)
chiTracts <- read_sf("chiTractsZ.shp")

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Chicago Transit Desert Explorer"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      h3("Select variable"),
      helpText("Create an interactive map of Chicago"),
      selectInput("Census_var", 
                  label = "Choose a variable to display",
                  choices = list("Number of transit stops", 
                                 "Number of transit routes", 
                                 "Total sidewalk length",
                                 "Total bike route length",
                                 "Total road length",
                                 "Intersection density",
                                 "Population with at least 1 vehicle", 
                                 "Population with no vehicle",
                                 "Population taking public transit to work",
                                 "Transit supply", 
                                 "Transit demand",
                                 "Transit gaps"),
                  selected = "Transit gaps"),
      h4("About"),
      p("This is not raw data being displayed, but instead is a calculated z-score. This is how much the raw data value differs from the standard deviation.")),
    # Main panel for displaying outputs ----
    mainPanel(
      textOutput("selected_var"),
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Map", leafletOutput("working_map")),
                  tabPanel("About", includeMarkdown("about.Rmd")),
                  tabPanel("Data", includeMarkdown("data.Rmd"))
      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  
  output$working_map <- renderLeaflet({
    data <- switch(input$Census_var, 
                   "Number of transit stops" = "zTSD", 
                   "Number of transit routes" = "zNRD", 
                   "Total sidewalk length" = "zPctSW",
                   "Total bike route length" = "zBRD",
                   "Total road length" = "zRLD",
                   "Intersection density" = "zID",
                   "Population with at least 1 vehicle" = "z1CD", 
                   "Population with no vehicle" = "zNCD",
                   "Population taking public transit to work" = "zPTWD",
                   "Transit supply" = "zTS", 
                   "Transit demand" = "zTD",
                   "Transit gaps" = "zTG")
    color <- switch(input$Census_var, 
                    "Number of transit stops" = "darkgreen", 
                    "Number of transit routes" = "black", 
                    "Total sidewalk length" = "darkorange",
                    "Total bike route length" = "darkviolet",
                    "Total road length" = "darkblue",
                    "Intersection density" = "darkred",
                    "Population with at least 1 vehicle" = "darkblue", 
                    "Population with no vehicle" = "darkred",
                    "Population taking public transit to work" = "darkviolet",
                    "Transit supply" = "darkblue", 
                    "Transit demand" = "darkred",
                    "Transit gaps" = "darkviolet")
    legend <- switch(input$Census_var, 
                     "Number of transit stops" = "Transit stops z-score", 
                     "Number of transit routes" = "Transit routes z-score", 
                     "Total sidewalk length" = "Sidewalk length z-score",
                     "Total bike route length" = "Bike route length z-score",
                     "Total road length" = "Road length z-score",
                     "Intersection density" = "Intersection density z-score",
                     "Population with at least 1 vehicle" = "Pop. w/ 1 vehicle z-score", 
                     "Population with no vehicle" = "Pop. w/ no vehicle z-score",
                     "Population taking public transit to work" = "Pop. taking public transit to work z-score",
                     "Transit supply" = "Transit supply z-score", 
                     "Transit demand" = "Transit demand z-score",
                     "Transit gaps" = "Transit gap z-score")
    working_map <- tm_shape(chiTracts) + tm_fill(data, title=input$Census_var, style="jenks", palette = "magma") + tm_layout(legend.outside = TRUE)
    tmap_leaflet(working_map)
  })
}

# Create Shiny app ----
shinyApp(ui, server)