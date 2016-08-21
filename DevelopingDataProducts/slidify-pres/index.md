---
title       : Developing Data Products Course Project
subtitle    : Sales Analytics Dashboard
author      : Matt Dancho
job         : Coursera Data Science Specialization
framework   : revealjs        # {io2012, html5slides, shower, dzslides, ...}
revealjs    :
  theme: night
  transition: convex
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : zenburn      # 
widgets     : []            # {mathjax, quiz, bootstrap}
ext_widgets : {rCharts: [libraries/nvd3, libraries/leaflet]}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<link href="https://fonts.googleapis.com/css?family=Open+Sans|Permanent+Marker" rel="stylesheet">

<!-- font-family: 'Permanent Marker', cursive; -->
<!-- font-family: 'Open Sans', sans-serif; -->

<style>
.reveal h1 {
    font-size: 2em;
    // color: #0000b3;
    padding-bottom: 10px;
    font-family: 'Permanent Marker', Impact, sans-serif;
}

.reveal h2 {
    font-size: 1.5em;
    //color: #fff7e6;
    padding-bottom: 10px;
    font-family: 'Permanent Marker', Impact, sans-serif;
}


.reveal p, .reveal em {
    padding-bottom: 10px;
    width: 960px;
    font-family: 'Open Sans', Verdana, sans-serif;
}

.reveal p {
    font-size: .75em;
}

.reveal small {
    width: 500px;
}

.reveal .slides {
    text-align: left;
}

.reveal .roll {
    vertical-align: text-bottom;
}

code {
    color: red;
}

.reveal pre code { 
     height: 250px;
}

</style>



# Developing Data Products
---------------------

## Course Project: [Sales Analytics Dashboard](https://mdancho84.shinyapps.io/shiny-app/)

Coursera Data Science Specialization

<small> [Matt Dancho](http://www.mattdancho.com) / [GitHub](https://github.com/mdancho84) / [LinkedIn](https://www.linkedin.com/in/mattdancho) </small>

<center>
_"Turn sales information into insight through the magic of Shiny"_
</center>

---  

# The Assignment 

The goal of this assignment is to build:

1. __A Shiny application__ that has widget input, ui input in `server.R`, reactive output using server calculations, and supporting documentation.

2. __A Reproducible Pitch Presentation__ that contains five slides in either Slidify or Rstudio Presenter that is pushed to and hosted on GitHub or Rpubs and contains embedded `R` code that runs. 

# Links to Project App & Docs

1. Shiny App: [Link](https://mdancho84.shinyapps.io/shiny-app/)

2. `server.R` and `ui.R` files: [Link](https://github.com/mdancho84/datasciencecoursera/tree/master/DevelopingDataProducts/shiny-app) 

---
# The Data

The data was simulated using a set of scripts I created as part of a side project called `orderSimulatoR`. The data simulation is intended to mimic real-world sales data for an organization. The data contains information related to customer orders such as order.id, products purchased, customer information (name and location), unit price, quantity sold, and so on. The simulated data was then used for analysis purposes as part of the __Sales Analytics Dashboard__. 

If your interested, the product names and prices came from the bicycle manufacturer, _[Cannondale](http://www.cannondale.com/en/USA)_, but the customer names and order details are all made up from the `orderSimulatoR` scripts. For more information on the data set, you can view my [orderSimulatoR blog post](http://www.mattdancho.com/business/2016/07/12/orderSimulatoR.html).

--- 

# The Sales Analytics Dashboard

#### Make Selections to Unlock Insights

There's a lot you can do with the __Sales Analytics Dashboard__. Here's a few suggestion to get started:

* Imagine you are an executive at _Cannondale_ in charge of strategy and business development. Your goal is to understand which products _Cannondale's_ customers are purchasing, which customers are purchasing the most, and what the organization can do to improve sales.

* Use the __Reactive Inputs__ to filter by year, product unit price, product primary category, and product secondary category. 

* On the __Analysis__ tab, see how the filters can be used to drill into the information. See if there are any insights that you can come up with from the data.

* Switch to the __Data__ tab to see how the filters control the data. Subset the data, and try downloading the csv file. 

* Use the __Reset Fields__ button when finished. See how the data set refreshs to its original size and how all of the reactive inputs reset.

--- 

# Code Example



```r
library(leaflet)
library(htmlwidgets)
library(knitr)
library(dplyr)

# Load data
setwd("../shiny-app")
source("./scripts/helper.R")
orders.extended <- read.data()
setwd("../slidify-pres")

# Get sales by location
salesByLocation <- orders.extended %>%
        group_by(bikeshop.name, longitude, latitude) %>%
        summarise(total.sales = sum(price.extended)) %>%
        mutate(popup = paste0(bikeshop.name, 
                              ": ", 
                              scales::dollar(total.sales)))

# Use Leaflet package to create map visualizing sales by customer location
l <- leaflet(salesByLocation) %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lng = ~longitude, 
             lat = ~latitude,
             popup = ~popup) %>%
  addCircles(lng = ~longitude, 
             lat = ~latitude, 
             weight = 2,
             radius = ~(total.sales)^0.775)

# Move to img folder
setwd("./assets/img")
saveWidget(l, 'leaflet1.html') # Save widget html
setwd("../..")

# Source saved file
cat('<pre><iframe src="./assets/img/leaflet1.html" width=100% height=350px allowtransparency="true"> </iframe></pre>')
```

<pre><iframe src="./assets/img/leaflet1.html" width=100% height=350px allowtransparency="true"> </iframe></pre>


