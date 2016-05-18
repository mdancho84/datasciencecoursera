plot3 <- function() {
        
        # Read in data
        dat <- read.csv("./Data/household_power_consumption.txt", header=T, sep=';', 
                        na.strings="?", stringsAsFactors=F, comment.char="", quote='\"')
        dat$Date <- as.Date(dat$Date, format="%d/%m/%Y")
        
        # Subsetting the data
        dat <- subset(dat, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
        
        # Create datetime combined variable. Coerce to POSIXct class
        dat$datetime <- as.POSIXct(paste(dat$Date, dat$Time))
        
        # Create plot
        with(dat, {
                plot(datetime, Sub_metering_1, type="n", 
                     ylab = "Energy sub metering", xlab="")
                lines(datetime, Sub_metering_1, col="black")
                lines(datetime, Sub_metering_2, col="red")
                lines(datetime, Sub_metering_3, col="blue")
        })
        legend("topright", lty = 1, lwd=2, 
               legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               col=c("black","red","blue"))
        
        # Create png file
        dev.copy(png, file="plot3.png", height=480, width=480)
        dev.off()
        
}