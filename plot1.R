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

#Setting png graphic device and dimensions
png("plot1.png", width = 480, height = 480)

#Plotting
with(household_power_consumption, hist(Global_active_power, col = "red", 
                                       xlab = "Global Active Power(kilowatts)", 
                                       main = "Global Active Power"))
dev.off() #Closing graphic device