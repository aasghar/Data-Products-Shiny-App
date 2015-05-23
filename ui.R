library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel("Electricity Tariff vs. Unsubsidized Renewables"),
    
    # Sidebar with controls to select the variable to plot against mpg
    # and to specify whether outliers should be included
    sidebarPanel(
        selectInput("country", "Country/States:",
                    list("Country" = "Country", 
                         "States" = "State")),   
        
        selectInput("variable", "Sector:",
                    list("Residential" = "Residential.2015", 
                         "Commercial" = "Commercial.2015", 
                         "Industrial" = "Industrial.2015")),
        
        checkboxInput("pvr", "PV - Residential", FALSE),
        checkboxInput("pvc", "PV - Commercial", FALSE),
        checkboxInput("pvu", "PV - Industrial", FALSE),
        checkboxInput("windo", "Wind - Onshore", FALSE)
        
    ),
    
    # Show the caption and plot of the requested variable against mpg
    mainPanel(
        h3(textOutput("caption")),
                
        tabsetPanel(
            tabPanel("Documentation", verbatimTextOutput("documentation")), 
            tabPanel("Main", plotOutput("mpgPlot")), 
            tabPanel("Histogram", plotOutput("hist")), 
            tabPanel("Summary", verbatimTextOutput("alcoe")),
            tabPanel("Table", tableOutput("table"))
        )
    )
))
