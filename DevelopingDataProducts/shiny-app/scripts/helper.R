library(xlsx)
library(dplyr)
library(lubridate)
library(tidyr)
library(stringr)

# Read & Manipulate Data -------------------------------------------------------
read.data <- function() {
        
        products <- read.xlsx2("./data/bikes.xlsx", sheetIndex = 1,
                               colClasses = c("numeric", "character", "character", 
                                              "character", "character", "numeric")
        )
        customers <- read.xlsx2("./data/bikeshops.xlsx", sheetIndex = 1,
                                colClasses = c("numeric", "character", "character", 
                                               "character", "numeric", "numeric")
        )
        orders <- read.xlsx2("./data/orders.xlsx", sheetIndex = 1, colIndex = 2:7,
                             colClasses = c("numeric", "numeric", "Date", "numeric", 
                                            "numeric", "numeric")
        )
        
        orders.extended <- merge(orders, customers, 
                                 by.x = "customer.id", by.y="bikeshop.id")
        orders.extended <- merge(orders.extended, products, 
                                 by.x = "product.id", by.y = "bike.id")
        
        orders.extended <- orders.extended %>%
                mutate(price.extended = price * quantity,
                       month = month(order.date, label = TRUE),
                       year = year(order.date),
                       category1 = as.character(category1),
                       category2 = as.character(category2)) %>%
                select(order.id, order.line, order.date, month, year,
                       bikeshop.name, bikeshop.state, latitude, longitude,
                       model, category1, category2, frame, 
                       quantity, price, price.extended) %>%
                arrange(order.id, order.line) 
        
        orders.extended
}




# Manipulate data for Plotly sales by state graph ------------------------------
aggregateByState <- function(df) {
        
        salesByCustomerAndState <- df %>%
                group_by(bikeshop.state, bikeshop.name) %>%
                summarize(total.sales = sum(price.extended)) %>%
                spread(key = bikeshop.name, value = total.sales)
        
        # Loop to get hover data in text field with breaks for plotly
        # Text is returned in format: 
        #     Customer: Sales<br>Customer: Sales<br>... 
        # for each state
        custListByState <- data.frame(1L)
        colnames(custListByState) <- c("hover")
        for (i in 1:nrow(salesByCustomerAndState)) {

                txt <- list()
                cnt <- 1
                for (j in 2:ncol(salesByCustomerAndState)) {
                        if (!is.na(salesByCustomerAndState[i, j])) {
                                txt[cnt] <- paste(colnames(salesByCustomerAndState)[j], 
                                                  scales::dollar(salesByCustomerAndState[[i, j]]), 
                                                  sep = ": ")
                                cnt <- cnt + 1
                        }
                }

                custListByState[i, 1] <- paste(txt, collapse ="<br>")

        }
        

        salesByState <- df %>%
                group_by(bikeshop.state) %>%
                summarize(total.sales = sum(price.extended)) %>%
                cbind(custListByState)
        
        salesByState
        
}

# Manipulate data for Top N Products graph -------------------------------------
computeTopNsales <- function(orders.extended, n) {
        
        topNsales <- orders.extended %>%
                group_by(product = model, category1, category2, price) %>%
                summarize(total.sales = sum(price.extended),
                          qty.total = sum(quantity)) %>%
                mutate(hover = str_c("Model: ", product, "<br>",
                                     "Primary Category: ", category1, "<br>",
                                     "Secondary Category: ", category2, "<br>",
                                     "Unit Price: ", scales::dollar(price), "<br>",
                                     "Total Sales: ", scales::dollar(total.sales), "<br>",
                                     "Quantity Sold: ", qty.total, collapse = "")) %>%
                ungroup() %>%
                arrange(desc(total.sales))
        
        topNsales <- head(topNsales, n)
        
        # Arrange factor product names in order of descending total.sales
        topNsales$product <- factor(topNsales$product,
                                    levels = arrange(topNsales, total.sales)$product)
        
        
        topNsales
        
}


        



