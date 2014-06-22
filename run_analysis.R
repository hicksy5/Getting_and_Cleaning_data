# Creates two tidy datasets containing both test and training data 
# for Samsung Galaxy S accelerometer data 

# Set 1 (meanAndStandardDeviationFeatures.txt) contains only the
# mean and standard deviation features

# Set 2 (featureAveragebySubjectAndActivity.txt) contains the average
# for each selected feature by subject and activity


# Load required libraries
library(plyr)
library(reshape2)

# Read in the data

# Training data
XTrain <- read.table("UCI HAR Dataset//train//X_train.txt", nrows = 7355, comment.char = "", colClasses = c("numeric"))
yTrain <- read.table("UCI HAR Dataset//train//y_train.txt", colClasses = c("factor"))

# Testing data
XTest <- read.table("UCI HAR Dataset//test//X_test.txt", nrows = 2950, comment.char = "", colClasses = c("numeric"))
yTest <- read.table("UCI HAR Dataset//test//y_test.txt", colClasses = c("factor"))

# Subject data
subjectTest <- read.table("UCI HAR Dataset//test//subject_test.txt")
subjectTrain <- read.table("UCI HAR Dataset//train//subject_train.txt")

#head(XTest,10)


# Read in the feature and activity names
features <- read.table("UCI HAR Dataset//features.txt")
activities <- read.table("UCI HAR Dataset//activity_labels.txt",stringsAsFactor=FALSE)

# Change column names of the features and activities tables.
names(features) <- c("colNumber","featureName")
names(activities) <- c("activityID","activityName")

#features
#head (subjectTrain,5)
#head(XTrain,5)

# 1. Combine the training and test data set 

X <- rbind(XTrain,XTest)
y <- rbind(yTrain,yTest) 
# head(y,5)


# 2. Select only the features which are either a mean or a standard deviation
# This includes mean(), std() and meanFreq()

# grep command looks for patterns and returns matches in table 
featuresToKeep <- grep("mean|std()",features$featureName)

#featuresToKeep


# 3. Translate the y values from codes to activity names 


y <- revalue(y$V1, c("1"=activities$activityName[1], 
                     "2"=activities$activityName[2],
                     "3"=activities$activityName[3],
                     "4"=activities$activityName[4],
                     "5"=activities$activityName[5],
                     "6"=activities$activityName[6]))


subject <- rbind(subjectTrain,subjectTest)

# Remove intermediate variables as these have been combined into
rm(subjectTest, subjectTrain, yTest, yTrain, XTest, XTrain)

# 4. Create a tidy names vector  - commands need to be run  in order

#Creates a vector containing a list of the feature names to keep.
namesVector1 <- c("subject.id","activity", as.character(features$featureName[featuresToKeep])) 
#namesVector1

# wherever there is a change from lower case to upper case (which seems to indicate a new word), place a fullstop inbetween
namesVector1 <- gsub("([a-z])([A-Z])", "\\1.\\2", namesVector1, perl = TRUE)
#namesVector1

#Replace - with .
namesVector1 <- gsub("-",".", namesVector1, perl=TRUE)
#namesVector1
#Replace () with .
namesVector1 <- gsub("()","", namesVector1, fixed=TRUE)
#namesVector1

#Make all letters lower case
namesVector1 <- tolower(namesVector1)
#namesVector1


# 5. Create a dataset with the subject ID, the activity and the mean and standard deviation features 
# and write it out to the file meanAndStandardDeviationFeatures.txt

#Remember that the features to keep are in the list of numbers relating to the columns to keep
meanAndStandardDeviationFeatures <-  cbind(subject,y,X[,featuresToKeep])
#head(meanAndStandardDeviationFeatures,10)

names(meanAndStandardDeviationFeatures) <- namesVector1
#head(meanAndStandardDeviationFeatures,10)


#sorts data based on subject.Id
meanAndStandardDeviationFeatures <- arrange(meanAndStandardDeviationFeatures, 
                                            meanAndStandardDeviationFeatures$subject.id)
#head(meanAndStandardDeviationFeatures$subject.id,1000)

#write developed table to text
write.table(meanAndStandardDeviationFeatures,"meanAndStandardDeviationFeatures.txt",row.names=FALSE)

# Create a tidy names vector for averages
namesVector2 <- paste("average(",namesVector1,")",sep="")
#namesVector2

#reset names of first 2 columns
namesVector2[1:2] <- c("subject.id","activity")

# Create a dataset of the average for each feature by activity and by subject
# and write it out to the file featureAveragebySubjectAndActivity.txt

#melt command is like a transpose function on the columns of subject.id and activity.
TransposedData <- melt(meanAndStandardDeviationFeatures, id = c("subject.id","activity"))
head(TransposedData,10)

#dcast is like a group by statement in SQL. Subject.Id and activity are ID and variable is the measured variable 
averagesTable <-dcast(TransposedData, subject.id + activity ~ variable, mean)
#head(averagesTable,10)

#replace names of columns in average table with previously developed column names
names(averagesTable) <- namesVector2

#write out table to a text file
write.table(averagesTable,"featureAveragebySubjectAndActivity.txt",row.names=FALSE)