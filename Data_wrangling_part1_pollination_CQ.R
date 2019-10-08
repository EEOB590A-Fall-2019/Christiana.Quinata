# 26 September 2019 ####

#data wrangling part 1, practice script
#we will be working with a real insect pan traps dataset that I've amended slightly in order to practice the skills from Tuesday. 

#1) load libraries - you will need tidyverse and readxl
library(tidyverse)
library(readxl)
#2) Read in data
arthropods <- read_excel("Data_wrangling_day1_pollination.xlsx")
#rename columns. Leave insect families with capital letters, but make all other columns lowercase. Remove any spaces. Change "location" to "site". Change "tract" to "transect". 
names(arthropods) <- c ("island", "site", "transect", "top color - bowl color", "Diptera", "Hemiptera", "Coleoptera", "Formicidae", "Apoidea", "Crabronidae", "Lepidoptera", "Blattodea", "Araneae", "Isoptera", "partial", "Trichoptera", "other")

labels(arthropods)
#4) Add missing data. Note that the people who entered the data did not drag down the island or location column to fill every row. 
arthropods<- data.frame(island = 1:243, island = c(Guam, rep(NA, 243))
arthroprods <- arthropods %>% fill(island)
arthroprods <- arthropods %>% fill(island, site)                                               
colnames(arthropods)                                               
#5) Separate "Top color - Bowl color" into two different columns, with the first letter for the top color and the second letter for the bowl color. We do not need to save the original column. 
arthropods <- arthropods %>% separate(col='top color - bowl color', into=c("top color", "bowl color"), sep="-",remove = 5) 

colnames(arthropods)

#6) Use the complete function to see if we have data for all 3 transects at each location. Do not overwrite the poll dataframe when you do this. 
arthropods_comp <- arthropods %>%
  complete(island, site)


#which transects appear to be missing, and why? 
#Answer: A portion of all three transects because they have NA's in both site and island, so cannot tell on which island or within which site the transect is in.
#7) Unite island, site, transect into a single column with no spaces or punctuation between each part. Call this column uniqueID. We need to keep the original columns too. 
arthropods <- arthropods %>%
  unite(uniqueID, c(island, site, transect), sep="", remove=F)
arthropods <- arthropods_test
view(arthropods)
#8) Now, make this "wide" dataset into a "long" dataset, with one column for the insect orders, and one column for number of insects. 
arthropodslong <- arthropods %>%
  gather('Diptera', 'Hemiptera', 'Coleoptera', 'Formicidae', 'Apoidea', 'Crabronidae', 'Lepidoptera', 'Blattodea', 'Araneae', 'Isoptera', 'Trichoptera', key = "insectorder", value = "numberofinsects")

#9) And just to test it out, make your "long" dataset into a "wide" one and see if anything is different. 
arthopodswide <- arthropodslong %>% spread(key = insectorder, value = numberofinsects)
#are you getting an error? Can you figure out why? 
#Answer: Yes, 'Error: Each row of output must be identified by a unique combination of keys. Do not haev unique ID for all observations, which is problem with raw dataset.

#10) Now, join the "InsectData" with the "CollectionDates" tab on the excel worksheet. You'll need to read it in, and then play around with the various types of 'mutating joins' (i.e. inner_join, left_join, right_join, full_join), to see what each one does to the final dataframe. 
arthropodcollectiondate <- read_excel("raw/Data_wrangling_day1_pollination.xlsx", sheet = "CollectionDates")

#innerjoin
innerjoin_arthropod <- arthropodslong %>%
  inner_join(arthropodcollectiondate, by = c("island", "site"))  

#leftjoin
leftjoin_arthropod <- arthropodslong %>%
  left_join(arthropodcollectiondate, by = c("island", "site"))  
#rightjoin
rightjoin_arthropod <- arthropodslong %>% right_join(arthropodcollectiondate)

#fulljoin
fulljoin_arthropod <- arthropodslong %>% full_join(arthropodcollectiondate, by = c("island", "site"))

arthropodslong <- arthropods %>% inner_join(arthropodcollectiondate)
write.csv(arthropodslong, file = "arthropods_long_hw.csv")
