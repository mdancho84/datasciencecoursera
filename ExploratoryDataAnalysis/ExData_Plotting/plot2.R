plot2 <- function() {
        # Read in data
        dat <- read.csv("./Data/household_power_consumption.txt", header=T, sep=';', 
                        na.strings="?", stringsAsFactors=F, comment.char="", quote='\"')
        dat$Date <- as.Date(dat$Date, format="%d/%m/%Y")
        
        # Subsetting the data
        dat <- subset(dat, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
        
        # Create datetime combined variable. Coerce to POSIXct class
        dat$datetime <- as.POSIXct(paste(dat$Date, dat$Time))
        
        # Create line plot
        with(dat, {
                plot(datetime, Global_active_power, type="n", 
                     ylab = "Global Active Power (kilowatts)", xlab="")
                lines(datetime, Global_active_power)
        })
        
        # Create png file
        dev.copy(png, file="plot2.png", height=480, width=480)
        dev.off()
        
}