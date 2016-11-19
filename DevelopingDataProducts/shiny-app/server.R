# Load libraries ---------------------------------------------------------------
library(shiny)

# Data read & manipulation libraries
require(dplyr)
require(lubridate)
require(xlsx)
require(scales)

# Visualization libraries
require(rCharts)
require(DT)
require(leaflet)
require(plotly)


# Helper has server-side functions to read and manipulate data -----------------
source("./scripts/helper.R", local=T) 

orders.extended <- read.data() # helper.R function

# Setup inputs
cat1 <- sort(unique(orders.extended$category1))
cat2 <- sort(unique(orders.extended$category2))
yearMax <- max(orders.extended$year)
yearMin <- min(orders.extended$year)
unitPriceMax <- max(orders.extended$price)
unitPriceMin <- min(orders.extended$price)
selectorList <- c("Total Sales", "Quantity Sold", "Pct of Total Sales", "Pct of Qty Sold")

# Server logic -----------------------------------------------------------------
shinyServer(function(input, output, session) {
        
        # Setup reactive inputs ------------------------------------------------
        
        output$yearSlider <- renderUI({
                sliderInput(inputId = "year.in", 
                            label   = "Year Filter", 
                            min     = yearMin, 
                            max     = yearMax, 
                            step    = 1,
                            value   = c(yearMin, yearMax),
                            ticks   = T,
                            sep     = "")
        })
        
        output$unitPriceSlider <- renderUI({
                sliderInput(inputId = "price.in", 
                            label   = "Unit Price Filter", 
                            min     = unitPriceMin, 
                            max     = unitPriceMax, 
                            step    = 1000,
                            value   = c(unitPriceMin, unitPriceMax),
                            ticks   = T,
                            sep     = "")
        })
        
        output$cat1Controls <- renderUI({
                checkboxGroupInput('cat1', label = "Primary Bike Category",
                                   choices = cat1, selected = cat1)
        })

        output$cat2Controls <- renderUI({
                checkboxGroupInput('cat2', label = "Secondary Bike Category",
                                   choices = cat2, selected = cat2)
        })
        
        observe({
                if(input$reset != 0) {
                        updateCheckboxGroupInput(session, "cat1", choices = cat1, selected=cat1)
                        updateCheckboxGroupInput(session, "cat2", choices = cat2, selected=cat2)
                        updateSliderInput(session, "price.in", val = c(unitPriceMin, unitPriceMax))
                        updateSliderInput(session, "year.in", val = c(yearMin, yearMax))
                }
                
        })
        
        output$nProductsTextbox <- renderUI({
                numericInput("nProducts.in", "Top N Products", 50, min = 5, max = 100)
        })
        
        output$salesVsQtySelector <- renderUI({
                selectInput("salesVsQty.in", "Select Measure", 
                            choices = selectorList, 
                            selected = selectorList[1])
        })
        
        # Data Reactivity ------------------------------------------------------
        
        orders.extended.filtered <- reactive({
                # Error handling 
                if (is.null(input$year.in) | 
                    is.null(input$cat1)    | 
                    is.null(input$cat2)    |
                    is.null(input$price.in)
                    ) {
                        return(NULL)
                } 
                
                orders.extended %>%
                        filter(year      >=   input$year.in[1],
                               year      <=   input$year.in[2],
                               price     >=   input$price.in[1],
                               price     <=   input$price.in[2],
                               category1 %in% input$cat1,
                               category2 %in% input$cat2)
                
        })
        
        cat1SalesByYear <- reactive({
                orders.extended.filtered() %>%
                        group_by(year, category1) %>%
                        summarize(price.total = sum(price.extended), 
                                  qty.total   = sum(quantity))
        })
        
        cat2SalesByYear <- reactive({
                orders.extended.filtered() %>%
                        group_by(year, category2) %>%
                        summarize(price.total = sum(price.extended),
                                  qty.total   = sum(quantity))
        })
        
        salesByLocation <- reactive({
                orders.extended.filtered() %>%
                        group_by(bikeshop.name, longitude, latitude) %>%
                        summarise(total.sales = sum(price.extended)) %>%
                        mutate(popup = paste0(bikeshop.name, 
                                              ": ", 
                                              scales::dollar(total.sales)))
        })
        
        salesByState <- reactive({
                aggregateByState(orders.extended.filtered()) # Helper function
        })
        
        topNsales <- reactive({
                # Helper function
                computeTopNsales(orders.extended.filtered(), input$nProducts.in)
        })
        
        salesByUnitPrice <- reactive({
                orders.extended.filtered() %>%
                        group_by(product = model, category2, price) %>%
                        summarize(total.sales = sum(price.extended),
                                  total.qty = sum(quantity)) %>%
                        ungroup() %>%
                        mutate(pct.total.sales = total.sales / sum(total.sales),
                               pct.total.qty = total.qty / sum(total.qty))
        })
                
        
        # Plots on Analysis Tab ------------------------------------------------
        
        # rChart - Sales By Category1
        output$primaryBikeCatOut <- renderChart({
                # Error handling
                if (is.null(orders.extended.filtered())) return(rCharts$new())
                
                cat1SalesByYearOutDF <- nPlot(
                        price.total ~ year,
                        group = "category1",
                        data = cat1SalesByYear(),
                        type = "multiBarChart",
                        dom = "primaryBikeCatOut",
                        width = 550
                )
                
                cat1SalesByYearOutDF$chart(margin = list(left = 85))
                cat1SalesByYearOutDF$yAxis(axisLabel = "Sales", width = 80,
                                   tickFormat = "#! function(d) {return '$' + d/1000000 + 'M'} !#")
                cat1SalesByYearOutDF$xAxis(axisLabel = "Year", width = 70)
                cat1SalesByYearOutDF$chart(stacked = T)
                cat1SalesByYearOutDF
        })
        
        # rCharts - Sales By Category2
        output$secondaryBikeCatOut <- renderChart({
                # Error handling
                if (is.null(orders.extended.filtered())) return(rCharts$new())
                
                cat2SalesByYearOutDF <- nPlot(
                        price.total ~ year,
                        group = "category2",
                        data = cat2SalesByYear(),
                        type = "multiBarHorizontalChart",
                        dom = "secondaryBikeCatOut",
                        width = 550
                )
                cat2SalesByYearOutDF$yAxis(axisLabel = "Sales", width = 80,
                                           tickFormat = "#! function(d) {return '$' + d/1000000 + 'M'} !#")
                cat2SalesByYearOutDF$chart(stacked = T)
                cat2SalesByYearOutDF
        })
        
        # Leaflet - Customers by Location
        output$salesByLocOut <- renderLeaflet({
                # Error handling
                if (is.null(orders.extended.filtered())) return(NULL)
                
                leaflet(salesByLocation()) %>% 
                        addProviderTiles("CartoDB.Positron") %>%
                        addMarkers(lng = ~longitude, 
                                   lat = ~latitude,
                                   popup = ~popup) %>%
                        addCircles(lng = ~longitude, 
                                   lat = ~latitude, 
                                   weight = 2,
                                   radius = ~(total.sales)^0.775)
        })
        
        # Plotly - Sales By State        
        output$salesByStateOut <- renderPlotly({
                # Error handling
                if (is.null(orders.extended.filtered())) return(NULL)
                
                # give state boundaries a white border
                l <- list(color = toRGB("black"), width = 1)
                
                # specify some map projection/options
                g <- list(
                        scope = 'usa',
                        projection = list(type = 'albers usa'),
                        showlakes = TRUE,
                        lakecolor = toRGB('white')
                )
                
                plot_ly(salesByState(), z = total.sales, text = hover, 
                        locations = bikeshop.state, type = 'choropleth',
                        locationmode = 'USA-states', color = total.sales, colors = 'Blues',
                        marker = list(line = l), colorbar = list(title = "USD")) %>%
                        layout(geo = g)
                
        })        
        
        # Plotly - Top N Products
        output$topNout <- renderPlotly({
                # Error handling
                if (is.null(orders.extended.filtered())) return(NULL)
                
                m <- list(b = 300,
                          l = 85,
                          pad = 15)
                
                x <- list(title = "Bike Models")
                
                y <- list(title = "Total Sales")
                
                plot_ly(topNsales(), x=product, y=total.sales, hoverinfo="text", text=hover,
                        type='bar') %>%
                        layout(autosize = F, height = 675, width = 500, margin = m,
                               xaxis = x, yaxis = y)
                        
        })
        
        # Plotly - Dynamic Graphs By Unit Price
        output$salesByUnitPriceOut <- renderPlotly({
                # Error handling
                if (is.null(orders.extended.filtered())) return(NULL)
                
                # Get selection (add 3 to offset for first three columns)
                colIndex <- which(selectorList == input$salesVsQty.in) + 3
                
                gg <- ggplot(data=salesByUnitPrice(), aes_string(x=colnames(salesByUnitPrice()[3]), y=colnames(salesByUnitPrice()[colIndex]))) + 
                        geom_point(aes(text = paste("Model:", product)), size = 1.5) + 
                        geom_smooth(aes(color= category2, fill = category2)) + 
                        facet_wrap(~category2) +
                        theme(legend.position = "none",
                              axis.text.x  = element_text(angle=45)) +
                        scale_x_continuous(labels = scales::dollar) + 
                        scale_y_continuous(labels = ifelse(
                                colIndex == 4, dollar, 
                                ifelse(colIndex == 5, comma, percent)
                        )) +
                        xlab("Unit Price") +
                        ylab(input$salesVsQty.in)
                
                p <- ggplotly(gg)
                
                p %>%
                        layout(autosize = F, height = 650, width = 600, margin=list(l=150, b=110))
        })
        
        
        
        # Data and button on Data Tab-------------------------------------------
        
        output$table <- DT::renderDataTable({orders.extended.filtered()},
                                            rownames = F,
                                            options = list(bFilter = FALSE, 
                                                           iDisplayLength = 10)
                                            )
        
        output$downloadData <- downloadHandler(
                filename = function() {
                        paste0('data-', Sys.Date(), '.csv')
                        },
                content = function(file) {
                        write.csv(orders.extended.filtered(), file, row.names=FALSE)
                }
        )
  
  
})
