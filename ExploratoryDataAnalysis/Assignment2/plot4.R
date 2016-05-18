# This script plots the PM2.5 Emissions for coal combustion-related
# sources from 1999 to 2008
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

# Merge tables. Filter coal data. Group by year and sum the emissions by year.
mergeData <- left_join(NEI, SCC, by="SCC")

coalEmission <- mergeData %>%
        filter(grepl("coal", Short.Name, ignore.case=TRUE)) %>%
        group_by(year) %>%
        summarize(Emissions = sum(Emissions))

# Plot Emissions by Year
png("plot4.png")

ggplot(data=coalEmission, aes(x=factor(year), y=Emissions)) +
        geom_bar(stat="identity") +
        ggtitle("PM2.5 Emissions for Coal Combustion Sources from 1999 to 2008") +
        xlab("Year") +
        ylab("Total PM2.5 Emissions (tons)")

dev.off()