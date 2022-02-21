#loading data
file<-paste(getwd(),"/household_power_consumption.txt",sep="")
dataSet<-data.table::fread(file)
wantedDatesSet<-dataSet[dataSet$Date=="1/2/2007" | dataSet$Date=="2/2/2007", ]

# checks for "?" char in set
for (i in names(wantedDatesSet)) {
    checkColumn<-grepl("\\?", wantedDatesSet[,wantedDatesSet$i])
    # print(sum(checkColumn)) # no "?" detected
}

# changing class of date and time columns
wantedDatesSet$Date<-lubridate::dmy(wantedDatesSet$Date)
wantedDatesSet$Time<-lubridate::hms(wantedDatesSet$Time)

wantedDatesSet<-as.data.frame(wantedDatesSet)

# changing rest of char values to numeric 
numericData<-lapply(wantedDatesSet[,3:9], as.numeric)
RESULT<-cbind(wantedDatesSet[,1:2], numericData)

#print(head(RESULT))

# building and saving plot
png(file = "Plot1.png", width=480, height = 480)
hist(RESULT$Global_active_power, xlab= "Global Active Power (kilowatts)",
     ylab = "Frequency",main="Global Active Power", col="red")
dev.off()
