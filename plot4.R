#Download and unzip the file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip")

#Read the file in as a table - assigning the first row as column names
hpc <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

#Change the Date column to Date class using strptime to tell R how to interpret the format
hpc$Date <- as.Date(strptime(hpc$Date, "%d/%m/%Y"))

#subset by only the 2 days in question
hpcsubset <- hpc[hpc$Date == "2007-02-01" | hpc$Date == "2007-02-02", ]

#Change Time from a factor vector to character
hpcsubset$Time <- as.character(hpcsubset$Time)

rownames(hpcsubset) <- 1:2880

#Combine date and time columns
for(i in 1:2880) {
        hpcsubset$Time[i] <- paste(hpcsubset$Date[i], hpcsubset$Time[i], sep = " ")
}
# Assign a new datetime variable
datetime <- as.character(rep(NA, 2880))
# Fill variable with POSIXct data from combined date and time
for(i in 1:2880) {
        datetime[i] <- as.POSIXct(strptime(hpcsubset$Time[i], "%Y-%m-%d %H:%M:%S"))
}
#Change vectors from a factor vector to numeric (first taking it through a character)
hpcsubset$Global_active_power <- as.numeric(as.character(hpcsubset$Global_active_power))
hpcsubset$Sub_metering_1 <- as.numeric(as.character(hpcsubset$Sub_metering_1))
hpcsubset$Sub_metering_2 <- as.numeric(as.character(hpcsubset$Sub_metering_2))
hpcsubset$Voltage <- as.numeric(as.character(hpcsubset$Voltage))
hpcsubset$Global_reactive_power <- as.numeric(as.character(hpcsubset$Global_reactive_power))


#Bringing the variables together
datetime <- as.numeric(datetime)
final <- cbind(datetime, hpcsubset$Sub_metering_1, hpcsubset$Sub_metering_2, hpcsubset$Sub_metering_3, hpcsubset$Global_reactive_power, hpcsubset$Global_active_power, hpcsubset$Voltage)
final <- as.data.frame(final)

#Make the form POSIXlt
final$datetime <- as.POSIXlt(final$datetime, origin = "1970-01-01")

#Plot to a png file
png(filename = "plot4.png", width = 480, height = 480)
#Set a 2 x 2 grid for plotting
par(mfrow = c(2, 2))
#Top left
with(final, plot(datetime, V6,  xlab = "", ylab = "Global Active Power", main = "", type = "n"))
lines(final$datetime, final$V6)

#Top right
with(final, plot(datetime, V7, xlab = "datetime", ylab = "Voltage", main = "", type = "n"))
lines(final$datetime, final$V7)

#Bottom left
with(final, plot(datetime, V2,  xlab = "", ylab = "Energy sub metering", main = "", type = "n"))
lines(final$datetime, final$V2, col = "black")
lines(final$datetime, final$V3, col = "red")
lines(final$datetime, final$V4, col = "blue")
legend("topright", bty = "n", cex = 0.8, lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Bottom right
with(final, plot(datetime, V5, xlab = "datetime", ylab = "Global_reactive_power", main = "", type = "n"))
lines(final$datetime, final$V5)

dev.off()



