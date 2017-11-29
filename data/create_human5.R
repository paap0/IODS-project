#Paula paap0 Bergman Nov 2017 Week 4
#Exercise 4 Data wrangling for Week 5 Exercise
#Source data: United Nations Human Development Report 2015:
#Human Development Index (HDI; http://hdr.undp.org/en/composite/HDI)
#and Gender Inequality Index (GII; http://hdr.undp.org/en/composite/GII)

#1.Data-folder and new script created. Name, date and short description written

library(dplyr)
library(ggplot2)
library(GGally)
library(tidyr)
library(stringr)
library(stargazer)

#Set working directory

setwd("~/GitHub/IODS-project/data")


#2.Read the data

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


#2.Datasets explored and summaries created

str(hd)
str(gii)
sapply(list(hd,gii), dim)
#Human Development: 195 observations with 8 variables 
#Gender Inequality:195 observations with 10 variables
#Both datasets have mostly numeric or integer variables and the variable country

summary(hd)
summary(gii)

#3.New variable names created

names(hd) <- c("HDI.rank","country","HDI","life.exp","edu.exp","edu.mean","GNI","GNI_HDIrank")
names(gii) <- c("GII.rank", "country", "GII","mat.mort","birth.rate","parl.prop","edu2.f","edu2.m","lab.f","lab.m")

#4. Gender inequality data edited to yield sec.edu female/male-ratio
#and labour participation female/male 

gii <- mutate(gii, edu2.f_m = (edu2.f / edu2.m))
gii <- mutate(gii, lab.f_m = (lab.f / lab.m))

#5.Datasets joined by country 

human<-inner_join(hd,gii,by="country")

#6.The joined dataset checked and saved

glimpse(human) #195 observations and 19 variables. Correct!
write.csv(human, file = "human.csv", row.names = FALSE)

#4.Checking that it indeed is saved and the structure is as it should

humantest<-read.csv(file="human.csv", header=TRUE)
dim(humantest)#should be 195 obs and 9 variables correct!
head(humantest)


#Paula paap0 Bergman Nov 2017 Week 5
#Exercise 5 Data wrangling 
#Source data: United Nations Human Development Report 2015:
#Human Development Index (HDI; http://hdr.undp.org/en/composite/HDI)
#and Gender Inequality Index (GII; http://hdr.undp.org/en/composite/GII)

#Require libraries and load the partly already wrangled data and check again, that it is ok
library(stringr)
library(dplyr)
human<-read.csv(file="human.csv", header=TRUE)
str(human)
dim(human)#OK!

#1.Mutate the data transforming GNI to numeric by extracting commas
human<-mutate (human, GNI=str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric())
summary(human$GNI)
str(human)

#2.Exclude unneeded variables as adviced

keepers <- c( "country", "edu2.f_m", "lab.f_m", "edu.exp"  ,  "life.exp" ,  "GNI"  ,"mat.mort" , "birth.rate", 
             "parl.prop" )
human <- dplyr::select(human, one_of(keepers))
str(human)
#looks good

#3. Exclude cases with missing values
comp <- complete.cases(human)
human <- filter(human, comp == TRUE)
str(human) #OK 162*9

#4. Remove the observations which relate to regions instead of countries
human$country

#from looking at the different values, I assume these are observations from 156 forward

human <- human[1:155, ]
str(human) #now just 155 observations and 9 variables

#5. Extract (and drop) the country column and make the cells rownames
rownames(human) <- human$country
rownames(human) 
human<-human[,-1]
str(human) # 155 obs and 8 variables okay!

#Save with rownames included
write.csv(human, file = "human5.csv", row.names = TRUE)

#Checking how I did:
humantest<-read.csv(file="human5.csv", header=TRUE, row.names = 1)
str(humantest)
rownames(humantest)# 155 observations, 8 variables, and countries as rownames. OKAY!"



