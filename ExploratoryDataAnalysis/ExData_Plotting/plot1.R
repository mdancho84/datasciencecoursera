plot1 <- function() {
        
        # Read in data
        dat <- read.csv("./Data/household_power_consumption.txt", header=T, sep=';', 
                        na.strings="?", stringsAsFactors=F, comment.char="", quote='\"')
        dat$Date <- as.Date(dat$Date, format="%d/%m/%Y")
        
        ## Subsetting the data
        dat <- subset(dat, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
        
        # Create histogram
        hist(dat$Global_active_power, main = "Global Active Power",
             xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
             col="red")
        
        # Create png file
        dev.copy(png, file="plot1.png", height=480, width=480)
        dev.off()
}