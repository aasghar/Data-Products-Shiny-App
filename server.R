
library(ggplot2)
library(dplyr)
data <- tbl_df(read.csv("./Data/Electricity Tariffs.csv", header = TRUE))



# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
    
    
    state <- reactive({
        filter(data, Division.State == input$country)
    })
    
    
    # Compute the forumla text in a reactive expression since it is 
    # executed by the output$mpgPlot expression
    
    formulaText <- reactive({
        paste("reorder(Census.Division.and.State,", input$variable, ")")
    })
    
    var <- reactive({
        paste(input$variable)
    })
    
    summ <- reactive({
        
        if (input$variable == "Residential.2015")
        {
            summ <- 2
        }
        else if (input$variable == "Commercial.2015")
            {
                summ <- 4
            }
            
        else if (input$variable == "Industrial.2015")
            {
                summ <- 6
            }
        
        
       
    })
    
    # Return the formula text for printing as a caption
    output$caption <- renderText({
        var()
        
    })
    
    output$table <- renderTable({
        data.frame(state())
    })
    
    output$alcoe <- renderPrint({
        summary(state()[summ()])
    })
    
    output$documentation <- renderText({
        "This App shows the 2014 electricity tariffs of different sectors in selected countries around the world and in the 50 states of USA. It further allows you to see the range of the levelized cost of electricity(LCOE) produced through several renewable energy sources. 
    
This app can help the user do a preliminary analysis to see if installing renewables would be economically beneficial for their facility be it home (Residential), office building(Commercial), or industry(Industrial).
        
First, go to the 'Main' tab and select if you want to view electricity tariffs of selected countries or the 50 states from the drop down 'Country/State' menu.
        
Electricity prices are normally different for residential, commerical or industrial sectors. Therefore, next, you should choose which sector you would like to view using the 'Sector' drop down menu
        
Lastly, choose the appropriate type of renewable energy you would like to install. For example, if you want to install solar panels on your home roof, you would choose 'Residential' in the 'Sector' drop down menu and you should check the 'PV - Residential' checkbox. 

A histrogram of the chosen data is shown in the 'Histogram' tab to show what electricity tariff range is the most common wihtin the states/countries.
        
The electricity tariff data was obtained from IEA website and the range of renewable energy LCOE was obtained from Lazard's 'Levelized cost of energy analsyis report': http://www.lazard.com/PDF/Levelized%20Cost%20of%20Energy%20-%20Version%208.0.pdf"
        
        
    })
        
    output$hist <- renderPlot({
        
        ggplot(data = state(), aes_string(x = input$variable)) + geom_histogram(binwidth = 5)
    }) 

    # Generate a plot of the requested variable against Country/State and only 
    # include range of LCOEs of renewable energy sources if requested
    
    output$mpgPlot <- renderPlot({
        
        g <- ggplot(state(), aes_string(x = formulaText(), y = input$variable)) + geom_point() +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
            xlab("State") + ylab("Electricity Tariff (c/kWh)") + 
            ylim(0, 40)
        
        if(input$pvr == TRUE){
            g <- g + geom_abline(intercept = 18, slope = 0, colour = "yellow", size = 2) + 
                geom_abline(intercept = 26.5, slope = 0, colour = "yellow", size = 2)
        }
        
        if(input$pvc == TRUE){
            g <- g + geom_abline(intercept = 12.6, slope = 0, colour = "yellow", size = 2) + 
                geom_abline(intercept = 17.7, slope = 0, colour = "yellow", size = 2)
        }
        
        if(input$pvu == TRUE){
            g <- g + geom_abline(intercept = 6, slope = 0, colour = "yellow", size = 2) + 
                geom_abline(intercept = 13, slope = 0, colour = "yellow", size = 2)
        }
        
        if(input$windo == TRUE){
            g <- g + geom_abline(intercept = 3.7, slope = 0, colour = "cyan", size = 2) + 
                geom_abline(intercept = 8.1, slope = 0, colour = "cyan", size = 2)
        }
        
        
        g
                
                
    })
})

