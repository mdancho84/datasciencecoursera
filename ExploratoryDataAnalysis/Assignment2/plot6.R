# This script plots the PM2.5 Emissions for motor vehicle sources
# in Baltimore City vs Los Angeles County from 1999 to 2008
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
onroadEmission.BaltimoreVsLosAngeles <- NEI %>%
        filter(type == "ON-ROAD") %>%
        filter(fips == "24510" | fips == "06037") %>%
        group_by(year, fips) %>%
        summarize(Emissions = sum(Emissions)) %>%
        mutate(city = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

# Plot Emissions by Year
png("plot6.png")

ggplot(data=onroadEmission.BaltimoreVsLosAngeles, aes(x=factor(year), y=Emissions, color=city)) +
        geom_line(aes(group=city)) +
        geom_point(aes(shape=city), size=5, alpha=0.5) +
        ggtitle("PM2.5 Emissions for Motor Vehicle Sources in Baltimore and Los Angeles from 1999 to 2008") +
        xlab("Year") +
        ylab("Total PM2.5 Emissions (tons)")

dev.off()
