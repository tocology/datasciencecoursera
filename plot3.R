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

# convert col 1, 2 to DateTime and Date class
dataset <- data.frame(DateTime = strptime ( paste(
  as.character(dataset$Date),
  as.character(dataset$Time)),
  "%d/%m/%Y %H:%M:%S"),
  Date=as.Date(as.character(dataset$Date), "%d/%m/%Y"),
  dataset[,3:9])

# make png file
png(file="plot3.png")

# draw plot and add lines on the plot using the points functions
plot(dataset$DateTime, 
     dataset$Sub_metering_1, 
     type = "n", 
     xlab = NA,
     ylab = "Energy sub metering")

points(dataset$DateTime,
       dataset$Sub_metering_1,
       type="l",
       col="black")

points(dataset$DateTime,
       dataset$Sub_metering_2,
       type="l",
       col="red")

points(dataset$DateTime,
       dataset$Sub_metering_3,
       type="l",
       col="blue")

# add a legend to the plot
legend("topright",
       legend=c("Sub_metering_1",
                "Sub_metering_2",
                "Sub_metering_3"),
       col=c("black",
             "red",
             "blue"),
       lty=1)

# close device
dev.off()