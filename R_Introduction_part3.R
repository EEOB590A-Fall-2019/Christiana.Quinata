########## R introduction Part 3 (Thursday, September 12) ############

#Today we will focus on reading in datasets, with some added complexity, and 
#changing the class of variables

#1) Reading in CSV files

#Read in the "transplant_raw.csv" file
transplant_raw <- read.csv("data/transplant_raw.csv")
#Read it in again, but assign better column names using principles
#we discussed in class
colnames = c("islands", "site", "web", "native", "netting", "start.date", "end.date", "total.days", "spid.pres", "web.pres", "websize.cm")
labels(transplant_raw)
colnames(transplant_raw)
names(transplant_raw)[1] <- "islands"
names(transplant_raw)[2] <- "site"
names(transplant_raw)[3] <- "web"
names(transplant_raw)[4] <- "native"
names(transplant_raw) [5] <- "netting"
names(transplant_raw)[6] <- "start.date"
names(transplant_raw)[7] <- "end.date"
names(transplant_raw)[8] <- "total.days"
names(transplant_raw)[9] <- "spid.pres"
names(transplant_raw)[10] <- "web.pres"
names(transplant_raw)[11] <- "websize.cm."

colnames(transplant_raw)





#2) Reading in Excel files
library(readr)
#Read in the "leaf damage ag expt.xls" file. This is the exact file I found from 
#an undergraduate project in 2007. It's not perfect. Let's see how we can fix it. 
leaf_damage_ag_expt <- read_excel("data/leaf damage ag expt.xls")
View(leaf_damage_ag_expt)
#read in the "beans" and "herbivory" worksheets and give each the same name 
#as the worksheet tab they came from
beans <- read_excel("data/leaf damage ag expt.xls", sheet = "beans")
view(beans)

herbivory <- read_excel("leaf damage ag expt.xls", sheet = "herbivory")

# Look at the structure of 'beans'. What class are each of the columns in? 
labels(beans)
str(beans)

#Read in the beans worksheet again, and tell R the appropriate class/column type 
#for each column. Note that read_excel doesn't let you choose factor, so use text instead
beans <- read_excel("leaf damage ag expt.xls", col_types = c("text", "text", "text","numeric", "numeric", "text", "text","text", "numeric", "text"))
View(leaf_damage_ag_expt)
#After you read it in, you realize that the "Number" column indicates the ID 
#of each exclosure, and therefore should be a factor. Change that column to a
#factor. 
beans$Number <- as.factor(beans$Number)

#check the number of levels for this factor to make sure it converted correctly
beans[,4]

#Notice that there are some X's in the leaflet columns of the herbivory worksheet?
#Read it in again, but this time tell R that the X means NA
view(herbivory)
herbivory <- read_excel("leaf damage ag expt.xls", sheet = "herbivory", na = "X")
view(herbivory)

#ADVANCED: Read the herbivory datasheet in again, but omit columns J-L because
#they do not belong with rows 2-6. If you aren't sure how to do this, look
#at the help file for the function that reads in excel files
herbivory <- read_excel("leaf damage ag expt.xls", sheet = "herbivory", range = cell_cols("A:I"), na = "X" )
view(herbivory)

#3) Dealing with dates

#Read in the "Exploring_dates.xlsx" file. 

Exploring_dates <- read_excel("Exploring_dates.xlsx")
View(Exploring_dates)
#Is this object a vector, matrix, dataframe, tibble, array or list? 
class(Exploring_dates)
#answer: object is a dataframe
#The name of this object is kinda unwieldy. Rename the object "dates"
dates <- Exploring_dates
class(dates)
View(dates)
#What format does R recognize each of the dates as? Which ones did not read in 
#as dates? 
#answer: yyyymmdd, yyyy-mm-dd, date 6 did not read in.

#Create a new column based on the difference in time between date 1 and date 2 
#and name it "duration
duration <- (dates$date1-dates$date2)
dates <- cbind(dates, duration)
View(dates)
#ADVANCED: Change the columns that didn't read in correctly into proper dates
install.packages(lubridate)

  
  