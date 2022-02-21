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

# new column "Day"
RESULT$Day<-weekdays(RESULT$Date)

# making dependency
RESULT<-dplyr::group_by(RESULT,Day)

# lots of plotting
png(file = "Plot3.png", width=480, height = 480)

plot(RESULT$Sub_metering_1,xlab="",ylab="Energy sub metering",
     xaxt="n",type="l")

lines(RESULT$Sub_metering_2,col="red",xlab="",ylab="",
     xaxt="n",type="l")

lines(RESULT$Sub_metering_3,col="blue",xlab="",ylab="",
       xaxt="n",type="l")
axis(1,c(1,1440,2880),labels=c("Thu","Fri","Sat"))

legend("topright",lwd=1,col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()
