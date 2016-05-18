# This script plots the total PM2.5 Emissions by Year
################################################################################

# Load packages
library(dplyr)

# Load data if not already loaded
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}

# Summarize NEI data by total Emissions
totalEmissionByYear <- NEI %>%
        group_by(year) %>%
        summarize(Emissions = sum(Emissions))

# Plot Emissions by Year using Base R
png("plot1.png")
with(totalEmissionByYear,
     barplot(height = Emissions,
             names.arg = year,
             main="Total Emission of PM2.5 from 1999 to 2008",
             xlab="Year", 
             ylab="Total PM2.5 Emissions (tons)"
     )
)
dev.off()