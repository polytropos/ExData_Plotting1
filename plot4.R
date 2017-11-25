library(tidyverse)
library(sqldf)
library(lubridate)

# download and unzip data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp, mode="wb")
unzip(temp, exdir = "Data")
unlink(temp)

# conditionally read file with sqldf
power_data <- as.tibble(
  read.csv.sql("Data/household_power_consumption.txt", 
    sql = "select * from file where Date in ('1/2/2007','2/2/2007')",
    sep = ";",
    eol = "\n"))
distinct(power_data, Date)

# convert ? to NA and convert datetime
power_data_clean <- power_data %>%
  mutate_all(funs(replace(., . == "?", NA))) %>%
  mutate(date_time = dmy_hms(paste(Date, Time)))

# plot 4
# I need to plot directly to the PNG device as the legend gets cut off
# when using dev.copy.
png("plot4.png", width=480, height=480, type="windows")
par(mfcol = c(2, 2))
with(power_data_clean, plot(
  date_time, 
  Global_active_power,
  type = "l",
  xlab = "",
  ylab = "Global Active Power (kilowatts)"))

with(power_data_clean, plot(
  date_time, 
  Sub_metering_1,
  type = "l",
  xlab = "",
  ylab = "Energy sub metering"))
with(power_data_clean, lines(
  date_time,
  Sub_metering_2,
  col = "red"))
with(power_data_clean, lines(
  date_time,
  Sub_metering_3,
  col = "blue"))
legend(
  "topright",
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lty=c(1, 1, 1),
  col=c("black","blue","red"))

with(power_data_clean, plot(
  date_time, 
  Voltage,
  type = "l",
  xlab = "datetime",
  ylab = "Voltage"))

with(power_data_clean, plot(
  date_time, 
  Global_reactive_power,
  type = "l",
  xlab = "datetime",
  ylab = "Global_reactive_power"))

dev.off()