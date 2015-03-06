#Download and unzip the file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip")

#Read the file in as a table - assigning the first row as column names
hpc <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

#Change the Date column to Date class using strptime to tell R how to interpret the format
hpc$Date <- as.Date(strptime(hpc$Date, "%d/%m/%Y"))

#subset by only the 2 days in question
hpcsubset <- hpc[hpc$Date == "2007-02-01" | hpc$Date == "2007-02-02", ]

#Change Global_active_power from a factor vector to numeric (first taking it through a character)
hpcsubset$Global_active_power <- as.numeric(as.character(hpcsubset$Global_active_power))

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
#Bringing the two together
datetime <- as.numeric(datetime)
final <- cbind(datetime, hpcsubset$Global_active_power)
final <- as.data.frame(final)

#Make the form POSIXlt
final$datetime <- as.POSIXlt(final$datetime, origin = "1970-01-01")

#Plot to a png file
png(filename = "plot2.png", width = 480, height = 480)
with(final, plot(datetime, V2,  xlab = "", ylab = "Global Active Power (kilowatts)", main = "", type = "n"))
lines(final$datetime, final$V2)
dev.off()

