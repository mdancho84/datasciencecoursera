plot4 <- function() {
        
        # Read in data
        dat <- read.csv("./Data/household_power_consumption.txt", header=T, sep=';', 
                        na.strings="?", stringsAsFactors=F, comment.char="", quote='\"')
        dat$Date <- as.Date(dat$Date, format="%d/%m/%Y")
        
        # Subsetting the data
        dat <- subset(dat, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
        
        # Create datetime combined variable. Coerce to POSIXct class
        dat$datetime <- as.POSIXct(paste(dat$Date, dat$Time))
        
        # Create plot
        par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
        with(dat, {
                plot(Global_active_power~datetime, type="l", 
                     ylab="Global Active Power", xlab="")
                plot(Voltage~datetime, type="l", 
                     ylab="Voltage", xlab="")
                plot(Sub_metering_1~datetime, type="l", 
                     ylab="Energy sub metering", xlab="")
                lines(Sub_metering_2~datetime,col='Red')
                lines(Sub_metering_3~datetime,col='Blue')
                legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
                       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
                plot(Global_reactive_power~datetime, type="l", 
                     ylab="Global Rective Power",xlab="")
        })
        
        # Create png file
        dev.copy(png, file="plot4.png", height=480, width=480)
        dev.off()
        
}