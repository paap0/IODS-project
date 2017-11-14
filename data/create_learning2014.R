#Paula paap0 Bergman Nov 2017 Week 2
#Exercise 2 Data wrangling part
#The original dataset can be found in http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt
#The data includes information about learning strategies and attitudes of one statistical course

#1.Data-folder and new script created. Name, date and short description written

#2.Read the data
lrn14<- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",sep="\t",header=TRUE)

#2.Explore the structure and dimensions
dim(lrn14) #there are 183 observatios and 60 variables in the dataset
str(lrn14) #apart from "gender" which is a factor the variables are integer-values

#3.Create an analysis dataset with gender,age,attitude,deep,stra,surf and points
#3.Access the dplyr library
library(dplyr)

#3.Questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#3.Select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

#3.Select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

#3.Select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra<-rowMeans(strategic_columns)

# Scaling the Attitude back to the original scale and save it as a new column named "attitude"
lrn14$attitude <- lrn2014$Attitude / 10

#3.Choose the wanted collumns
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

#3.Select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14,one_of(keep_columns))

#3.Exclude obs. where exam points variable is zero
learning2014 <- filter(learning2014, Points>0)

#3.Then change the name of the second,third and seventh column such that there are no capitals
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

#3.See the stucture of the new dataset

dim(learning2014)#should be 166 obs and 7 variables
str(learning2014)#one factor, three integer variables and three numerical ones

#4.Working directory set and analysis dataset saved as a csv-file
# Session -> set working directory
write.csv(learning2014, file = "learning2014.csv", row.names = FALSE)

#4.Checking that it indeed is saved and the structure is as it should
learning2014test<-read.csv(file="learning2014.csv", header=TRUE)
str(learning2014test)#should be 166 obs and 7 variables correct!
head(learning2014test)#one factor, three integer variables and three numerical ones


