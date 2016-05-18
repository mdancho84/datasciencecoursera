# This script plots the PM2.5 Emissions for Baltimore City, Maryland
# (fips=="24510") to compare 1999 to 2008
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

# Filter Baltimore data. Group by year and sum the emissions by year.
baltimoreEmission <- NEI %>%
        filter(fips=="24510") %>%
        group_by(year) %>%
        summarize(Emissions = sum(Emissions))

# Plot Emissions by Year using Base R
png("plot2.png")
with(baltimoreEmission,
     barplot(height = Emissions,
             names.arg = year,
             main="PM2.5 Emissions for Baltimore City, MD from 1999 to 2008",
             xlab="Year", 
             ylab="Total PM2.5 Emissions (tons)"
     )
)
dev.off()