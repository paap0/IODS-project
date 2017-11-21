#Paula paap0 Bergman Nov 2017 Week 3
#Exercise 3 Data wrangling part
#The orginal dataset F. Pagnotta & H. M. Amran (2008). Using Data Mining To Predict Secondary
#School Student Alcohol Consumption. Department of Computer Science,
#University of Camerino. Referred 05/02/17.
#https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

data<-read.delim("clipboard")

###########################
## Initialise the script ##
###########################


# Required packages
library(dplyr)

# Reset graphical parameters and save the defaults.
plot.new()
.pardefault <- par(no.readonly = TRUE)
dev.off()

#1..zip-file downloaded, files unzipped, the two files ectracted and moved in my folder

#2.New script created. Name, date and short description written

#3.Set working directory
setwd("~/GitHub/IODS-project/data")

#3.Read in data
math <- as.data.frame(read.table('student-mat.csv', sep=';', header = TRUE))
portugese <- as.data.frame(read.table('student-por.csv', sep=';', header = TRUE))

#3.Explore the structure and dimensions with glimpse().
glimpse(math)#395 observations and 33 variables
glimpse(portugese)#649 observations and 33 variables

#4.Define the identifiers used in joining the tables as described in point 4
join_by<-c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

#4.Join the datasets based on the identifier columns
mathpor <- inner_join(math, portugese, by = join_by, suffix = c("_m", "_p"))

#4.Explore the structure and dimensions
glimpse(mathpor)#382 observations and 53 variables

#5.Merging results in numerous duplicated variables as can be seen
colnames<-colnames(mathpor)
colnames
#5.Create a data frame with only the joined columns
alc<-select(mathpor,one_of(join_by))
glimpse(alc)#382 observations and 13 variables

#5.To combine the "duplicated" answers firstly define the ones not used for joining
nonid_col<-colnames(math)[!colnames(math) %in% join_by]
nonid_col

#5. By for looping select two collumns from mathpor with the same name and
    #if the first is numeric it calculates a rounded average of the two
    #if it in not numeric, then the first of the two is included

for(colnames in nonid_col) {
    two_columns<-select(mathpor,starts_with(colnames))
    first_column<-select(two_columns,1)[[1]]
    
    if(is.numeric(first_column)){
       alc[colnames]<-round(rowMeans(two_columns))      
    }  
       else {
       alc[colnames]<-first_column
      }
}

#5.Checking the structure of the generated dataset
glimpse(alc)

#6.Create alc_use by averaging weekdays and weekends consuption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#6. Define a logical column referring to high_use based on the alc_use
alc <- mutate(alc, high_use = alc_use > 2)

#7. Save and check the created, joined and modified dataset 
write.csv(alc, file = "alc.csv", row.names = FALSE)

alctest<-read.csv(file="alc.csv", header=TRUE)
dim(alctest)#should be 382 obs and 35 variables: Correct!
head(alctest)

