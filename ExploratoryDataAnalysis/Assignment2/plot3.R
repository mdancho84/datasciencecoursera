# This script plots the PM2.5 Emissions for Baltimore City, Maryland
# (fips=="24510") to compare types (point, nonpoint, onroad, nonroad) 
# from 1999 to 2008
################################################################################

# Load packages
library(dplyr)
library(ggplot2)

# Load data if not already loaded
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}

# Filter Baltimore data. Group by year and type. Sum emissions by year.
baltimoreEmission.type <- NEI %>%
        filter(fips=="24510") %>%
        group_by(year, type) %>%
        summarize(Emissions = sum(Emissions))

# Plot Emissions by Year using ggplot2
png("plot3.png")

ggplot(data=baltimoreEmission.type, aes(x=factor(year), y=Emissions, col=type)) +
        geom_line(aes(group=type)) +
        geom_point(aes(shape=type), size=5, alpha=0.5) +
        ggtitle("PM2.5 Emissions for Baltimore City, MD from 1999 to 2008 by Type") +
        xlab("Year") +
        ylab("Total PM2.5 Emissions (tons)")
        
dev.off()