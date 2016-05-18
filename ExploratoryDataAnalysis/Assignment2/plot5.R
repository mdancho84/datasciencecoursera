# This script plots the PM2.5 Emissions for motor vehicle sources
# in Baltimore City from 1999 to 2008
################################################################################

# Load packages
library(dplyr)
library(tidyr)
library(ggplot2)

# Load data if not already loaded
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}

# Filter ON-ROAD, Baltimore data. Group by year and sum the emissions by year.
onroadBaltimoreEmission <- NEI %>%
        filter(type == "ON-ROAD") %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarize(Emissions = sum(Emissions))

# Plot Emissions by Year
png("plot5.png")

ggplot(data=onroadBaltimoreEmission, aes(x=factor(year), y=Emissions)) +
        geom_bar(stat="identity") +
        ggtitle("PM2.5 Emissions for Motor Vehicle Sources in Baltimore from 1999 to 2008") +
        xlab("Year") +
        ylab("Total PM2.5 Emissions (tons)")

dev.off()