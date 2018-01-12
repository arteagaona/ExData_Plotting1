#Downloading and unzipping the data
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "./data/household_power_consumption.zip")
unzip("./data/household_power_consumption.zip", exdir = "./data")

raw_lines <- readLines("./data/household_power_consumption.txt", n=-1)

#Determines the row number where 1/2/2007 observations start
day1_start <- intersect(grep("1/2/2007", raw_lines), grep("1/2/2007", raw_lines))[1]

#Determines the row number where 3/2/2007 observations start -- 2/2/2007 ends --
day2_end <- intersect(grep("3/2/2007", raw_lines), grep("3/2/2007", raw_lines))[1]

#Number of rows we want to read
number_rows <- day2_end - day1_start

#Reading data
household_power_consumption <- read.table("./data/household_power_consumption.txt", sep = ";", 
                                          skip = day1_start - 1, nrows = number_rows, na.strings = "?")

#Setting variable names to make identification easier
names(household_power_consumption) <- c("Date","Time","Global_active_power",
                                        "Global_reactive_power","Voltage",
                                        "Global_intensity","Sub_metering_1",
                                        "Sub_metering_2","Sub_metering_3")

#Concatenating Date and Time columns
date_and_time <- with(household_power_consumption, paste(Date, Time))

#Converting to POSIXlt
date_and_time <- strptime(date_and_time, "%d/%m/%Y %H:%M:%S")

#Setting png graphic device and dimensions
png("plot4.png", width = 480, height = 480)

#Setting layout 2 rows, 2 columns
par(mfrow = c(2,2))

#plot 1 - 1st row, 1st column
with(household_power_consumption, plot(date_and_time, Global_active_power, 
                                       type = "l", xlab = "", 
                                       ylab = "Global Active Power"))

#plot 2 - 1st row, 2nd column
with(household_power_consumption, plot(date_and_time, Voltage, type = "l", xlab = "datetime"))

#plot 3 - 2nd row, 1st column
with(household_power_consumption, {
    plot(date_and_time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
    lines(date_and_time, Sub_metering_2, type = "l", col = "red")
    lines(date_and_time, Sub_metering_3, type = "l", col = "blue")
})
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#plot 4 - 2nd row, 2nd column
with(household_power_consumption, plot(date_and_time, Global_reactive_power, type = "l", 
                                       xlab = "datetime"))

dev.off() #Closing graphic device