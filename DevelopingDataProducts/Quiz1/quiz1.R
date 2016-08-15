# Quiz 1

# Problem 1
library(manipulate)
myPlot <- function(s) {
        plot(cars$dist - mean(cars$dist), cars$speed - mean(cars$speed))
        abline(0, s)
}
manipulate(myPlot(s), s = slider(0, 2, step = 0.1))



# Problem 2
library(rCharts)
dTable(airquality, sPaginationType = "full_numbers")


# Problem 3
# A ui.R and server.R file or a A server.R file and a directory called www 
# containing the relevant html files.

# Problem 4
# Missing a comma in the sidebar panel

# Problem 4
# The server.R output name isn't the same as the plotOutput command used in 
# ui.R. Note that newHist and myHist are inconsistent.