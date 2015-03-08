# In the instruction, we're only interested in the data
# which start from "1/2/2007" to "28/2/2007". So, Instead of
# reading whole dataset, we can do some test to know when
# the interested data are shown using some functions like
# min(which(DF$Data=="1/2/2007")) if you read the dataset as 'DF'
# it will show the number '66637'.

# Using the truth, we skip the data before the number.
dataset <- read.table(file="./data/household_power_consumption.txt",
                       header=TRUE,
                       sep=";",
                       skip=66637,
                       nrow=2880, # because we only have interest in two day
                       col.names=c("Date",
                                  "Time",
                                  "Global_active_power",
                                  "Global_reactive_power",
                                  "Voltage",
                                  "Global_intensity",
                                  "Sub_metering_1",
                                  "Sub_metering_2",
                                  "Sub_metering_3"),
                       na.strings="?")

# set the locale to English for label
Sys.setlocale("LC_TIME", "English")

# make png file
png(file="plot1.png")

# draw the histogram
hist(dataset$Global_active_power,
     col="Red",
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")

# close device
dev.off()

