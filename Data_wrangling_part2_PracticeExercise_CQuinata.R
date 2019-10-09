# EEOB590A
# Data_wrangling part 2 practice exercise
# practice tidying and wrangling 
library(readr)
#from the tidy folder, read in the partialtidy file for pollination from last week's assignment
library(tidyverse)
###########################################################
#####Part 1: finish tidying & wrangling dataframe #########

#1) Broad changes to the database

#1a) Change the class of each variable as appropriate (i.e. make things into factors or numeric)
arthropods_untidy <- read_csv("arthropods_long.csv")

arthropods_untidy <- arthropods_untidy %>%
  mutate_at(vars(island, uniqueID, site, transect, "top color", "bowl color", insectorder), factor)

arthropods_untidy <- arthropods_untidy %>% 
  mutate_at(vars(numberofinsects), as.numeric)
#1b) Change name of "date traps out" and "date traps coll" to "dateout" and "datecoll"
arthropods_untidy <- arthropods_untidy %>% rename(dateout = 'date traps out', datecoll = 'date traps coll')


#2) Fix the errors below within cells 


##2a) Fix the levels of site so that they have consistent names, all in lowercase
arthropods_untidy <- arthropods_untidy %>% 
  mutate(site = fct_recode(site, "anao" = "Anao", "forbi" = "ForbiA", "forbi" = "ForbiGrid", "lada" = "LADTA", "lada" = "LADTG", "riti" = "Ritidian", "race" = "Racetrack"))
arthropods_untidy <- arthropods_untidy %>% 
  mutate(site = fct_recode(site, "lada" = "ladta", "marpi" = "MTRL"))
levels(arthropods_untidy$site)

##2b) What format are the dates in? Do they look okay? 
library("lubridate")
str(arthropods_untidy$datecoll)
##2c) Do you see any other errors that should be cleaned up? 
no
#3) Create a new column for the duration of time traps were out
arthropods_untidy <- arthropods_untidy %>% 
  mutate(duration = datecoll-dateout)
str(arthropods_untidy$duration)
#4) Arrange data by the number of insects
arthropods_tidy <- arthropods_untidy
arthropods_tidy <- arthropods_tidy %>%
  arrange(numberofinsects)

#5) Print tidied, wrangled database
write.csv(arthropods_tidy, "arthtidy.csv")
#####################################################
####Part 3: start subsetting & summarizing ##########

#6) Make a new dataframe with just the data from Guam at the racetrack site and name accordingly. 
arthropods_tidy_2 <- read_csv("poll_long_tidy.csv")

arthropods_guam <- arthropods_tidy_2 %>%
  filter(island == "guam", site == "race")
#I must have messed up dataframe and did not copy all guam sites but one at anao. So I will be using your poll_long_tidy.csv
#7) Make a new dataframe with just the uniqueID, island, site, transect, insectorder, numinsects, and duration columns. 
arthropods_basic <- arthropods_tidy_2 %>% 
  select(uniqueID, island, site, transect, insectorder, numinsects, duration)

#8) With the full database (not the new ones you created in the two previous steps), summarize data, to get: 
#8a) a table with the total number of insects at each site
allinsects <- arthropods_tidy_2 %>%
  group_by(site) %>%
  summarize (totalinsects = sum(numinsects, na.rm=T))


#8b) a table that shows the mean number of insects per island
insects_mean <- arthropods_tidy_2 %>%
  group_by(island) %>%
  summarize (avgisland = mean(numinsects))
#8c) a table that shows the min and max number of insects per transect
insect_transect <- arthropods_tidy_2 %>%
  group_by(transect) %>%
  summarize(transectmin = min(numinsects), transectmax= max(numinsects))
#9a) Figure out which insect order is found across the greatest number of sites
#myversion
site_insect_orders <- arthropods_tidy_2 %>%
  group_by(site)%>%
  count(insectorder)

insect_site <- arthropods_tidy_2 %>%
  group_by(insectorder) %>%
  filter(numinsects>0) %>%
  summarize(numinsite = n_distinct(site))
view(insect_site)

insect_order <- arthropods_tidy_2 %>%
  group_by(site, insectorder) %>%
  summarize(numinssite = sum(numinsects, na.rm=T)) %>%
  filter(numinssite >0) %>%
  group_by(insectorder) %>%
  count(insectorder)
view(insect_order)
#9b) For that insect order, calculate the mean and sd by site. 
order_lep <- arthropods_tidy_2 %>%
  filter(insectorder == "Lepidoptera")%>%
  group_by(island, site)%>%
  summarize(lepmean = mean(numinsects, na.rm=T),lepsd = sd(numinsects, na.rm=T))
  
