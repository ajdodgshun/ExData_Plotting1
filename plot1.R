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

#Plot to a png file
png(filename = "plot1.png", width = 480, height = 480)
hist(hpcsubset$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()
