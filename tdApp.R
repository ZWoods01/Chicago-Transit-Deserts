# set wd and load relevant libraries

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(dashboardthemes)
library(rgdal)
library(rgeos)
library(tmap)
library(leaflet)
library(sf)

# load data

chiTracts <- read_sf("tracts_26971.shp")
railLines <- read_sf("railLines/CTA_RailLines.shp")
busLines <- read_sf("busRoutes/CTA_BusRoutes.shp")
bikeRoutes <- read_sf("bikeRoutes/geo_export_d5b2a8a7-f33d-4a3b-ac07-ec016dc1088b.shp")
busStops <- read_sf("busStops/CTA_BusStops.shp")
railStops <- read_sf("railStops/CTA_RailStations.shp")
bikeRoutes <- read_sf("bikeRoutes/geo_export_d5b2a8a7-f33d-4a3b-ac07-ec016dc1088b.shp")
chiRoads <- read_sf("chiRoads/geo_export_6c7ad2b5-cc81-4e18-a45b-471d70ced40f.shp")

# define ui
ui <- navbarPage("Chicago Transit Deserts",
           tabPanel("Supply",
                    sidebarLayout(
                      
                      # Sidebar panel for inputs ----
                      sidebarPanel(
                        h3("Choose display variable"),
                        helpText("Create an interactive map of Chicago"),
                        
                        selectInput("Census_var", 
                                    label = "Choose a variable to display",
                                    choices = list("Number of transit stops", 
                                                   "Service frequency",
                                                   "Number of transit routes", 
                                                   "Total sidewalk length",
                                                   "Total bike route length",
                                                   "Total road length",
                                                   "Intersection density"),
                                    selected = "Number of transit stops"),
                        h4("About"),
                        p("DESCRIPTION"),
                        
                        ),
                      
                      # Main panel for displaying outputs ----
                      mainPanel(
                        
                        textOutput("selected_var"),
                        
                        # Output: Tabset w/ plot, summary, and table ----
                        tabsetPanel(type = "tabs",
                                    tabPanel("Map", leafletOutput("working_map")),
                                    tabPanel("Histogram", plotOutput("vioplot"))
                                    
                        )
                        
                      )
                    )
           ),
           tabPanel("Demand",
                    sidebarLayout(
                      
                      # Sidebar panel for inputs ----
                      sidebarPanel(
                        h3("Choose display variable"),
                        helpText("Create an interactive map of Chicago"),
                        
                        selectInput("Census_var", 
                                    label = "Choose a variable to display",
                                    choices = list("Population with at least 1 vehicle", 
                                                   "Population with no vehicle",
                                                   "Population taking public transit to work"),
                                    selected = "Population taking public transit to work"),
                        
                        h4("About"),
                        p("DESCRIPTION"),
                        
                      ),
                      
                      # Main panel for displaying outputs ----
                      mainPanel(
                        
                        textOutput("selected_var"),
                        
                        # Output: Tabset w/ plot, summary, and table ----
                        tabsetPanel(type = "tabs",
                                    tabPanel("Map", leafletOutput("working_map")),
                                    tabPanel("Histogram", plotOutput("vioplot"))
                                    
                        )
                        
                      )
                    )
           ),
           tabPanel("Gaps",
                    sidebarLayout(
                      
                      # Sidebar panel for inputs ----
                      sidebarPanel(
                        h3("Choose display variable"),
                        helpText("Create an interactive map of Chicago"),
                        
                        selectInput("Census_var", 
                                    label = "Choose a variable to display",
                                    choices = list("Transit supply", 
                                                   "Transit demand",
                                                   "Transit gaps"), 
                                    selected = "Transit gaps"),
                        
                        h4("About"),
                        p("DESCRIPTION"),
                        
                      ),
                      
                      # Main panel for displaying outputs ----
                      mainPanel(
                        
                        textOutput("selected_var"),
                        
                        # Output: Tabset w/ plot, summary, and table ----
                        tabsetPanel(type = "tabs",
                                    tabPanel("Map", leafletOutput("working_map")),
                                    tabPanel("Histogram", plotOutput("vioplot"))
                                    
                        )
                        
                      )
                    )
           ),
           navbarMenu("More",
                      tabPanel("About this app",
                               fluidRow(
                                 column(12,
                                        includeMarkdown("about.Rmd")

                                 )
                                 )
                      ),
                      tabPanel("Data information",
                               fluidRow(
                                 column(12,
                                        includeMarkdown("data.Rmd")
                               )
                          )
                      )
           )
)

# define server
server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(cars, type=input$plotType)
  })
  
  output$summary <- renderPrint({
    summary(cars)
  })
  
  output$table <- DT::renderDataTable({
    DT::datatable(cars)
  })
}

# run app
shinyApp(ui = ui, server = server)

