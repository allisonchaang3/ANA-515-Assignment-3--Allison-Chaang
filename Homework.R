#reading the csv file into R
getwd()
setwd("/Users/allisonchaang/Desktop/")
getwd()
eventsdata <- read.csv("StormEvents_details-ftp_v1.0_d1997_c20190920.csv")

#limiting the data to certain columns
colnames(eventsdata)
selectcolumns <- c("BEGIN_YEARMONTH","BEGIN_DAY", "BEGIN_TIME", "END_YEARMONTH","END_DAY","END_TIME","EPISODE_ID","EVENT_ID", "STATE","STATE_FIPS","CZ_TYPE", "CZ_FIPS","CZ_NAME","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
limiteddata <- eventsdata[selectcolumns]

#packages installation
install.packages("lubridate")
library(lubridate)
install.packages("stringr")
library(stringr)
install.packages("dplyr")
library(dplyr)

#addint begin and end datetime formats to limiteddata df
mutate(eventsdata, BEGIN_DATE_TIME=dmy_hms(BEGIN_DATE_TIME),END_DATE_TIME=dmy_hms(END_DATE_TIME))
limiteddata$BEGIN_DATE_TIME=eventsdata$BEGIN_DATE_TIME
limiteddata$END_DATE_TIME=eventsdata$END_DATE_TIME

#titlecase formatting for one column (STATE)
limiteddata$STATE <- str_to_title(limiteddata$STATE)
limiteddata$STATE
limiteddata$CZ_NAME <- str_to_title(limiteddata$CZ_NAME)

#filtering for cz_type="c" --> filtereddata
filtereddata <- filter(limiteddata, CZ_TYPE=="C")

#drop columns --> droppeddata
minusdata <- subset(filtereddata,select=-c(CZ_TYPE))

#padding state and county FIPS with 0
library(stringr)
minusdata$STATE_FIPS=str_pad(minusdata$STATE_FIPS,width=3,side="left",pad="0")
minusdata$CZ_FIPS=str_pad(minusdata$CZ_FIPS,width=3,side="left",pad="0")
library(dplyr)
minusdata <- rename_all(minusdata, tolower)
colnames(minusdata)

#uniting "cz_fips" and "state_fips"
install.packages("tidyr")
library(tidyr)
minusdata <- unite(minusdata,"fips",c("state_fips","cz_fips"))
minusdata$fips <- gsub("_","",as.character(minusdata$fips))

#creating dataframe for number of events per state
data("state")
table(minusdata$state)
statedataframe <- data.frame(table(minusdata$state))
newdataframe <- rename(statedataframe,c("state"="Var1"))

#creating a dataframe for state and count of states
us_state_info <- data.frame(state=state.name, region=state.region, area=state.area)

#merging the datasets
merged <- merge(x=newdataframe, y=us_state_info,by.x="state",by.y="state")

#plotting the data
install.packages("ggplot2")
library(ggplot2)
storm_plot <- ggplot(merged, aes(x=area, y=Freq)) + geom_point(aes(color=region)) + labs(x="Land area (square miles)", y="# of storm events in 2017")
storm_plot
