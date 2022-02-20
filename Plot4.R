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

# even more plotting
png(file = "Plot4.png", width=480, height = 480)

par(mfrow=c(2,2))

# 1
plot(RESULT$Global_active_power,xlab="",ylab="Global Active Power",
     xaxt="n",type="l")
axis(1,c(1,1440,2880),labels=c("Thu","Fri","Sat"))

#2
plot(RESULT$Voltage,xlab="datetime", ylab="Voltage",xaxt="n",type="l")
axis(1,c(1,1440,2880),labels=c("Thu","Fri","Sat"))

# 3
plot(RESULT$Sub_metering_1,xlab="",ylab="Energy sub metering",
     xaxt="n",type="l")
lines(RESULT$Sub_metering_2,col="red",xlab="",ylab="",
      xaxt="n",type="l")
lines(RESULT$Sub_metering_3,col="blue",xlab="",ylab="",
      xaxt="n",type="l")
axis(1,c(1,1440,2880),labels=c("Thu","Fri","Sat"))
legend("topright",bty="n", lwd=1,col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

# 4
plot(RESULT$Global_reactive_power,xlab="datetime", ylab="Global_active_power",xaxt="n"
     ,yaxt="n",type="l")
axis(1,c(1,1440,2880),labels=c("Thu","Fri","Sat"))
axis(2,at=c(0.0,0.1,0.2,0.3,0.4,0.5),labels=c('0.0','0.1','0.2','0.3','0.4','0.5'))

dev.off()