This repository contains the R code required to create a normalised feature set for mean, standard deviation and mean frequency features from the "UCI HAR dataset" for the Coursera "Getting and Cleaning Data" course Assignment.

Developed by hicksy_5

The required data can be found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and should be unzipped into your assigned working directory.


The file run_analysis.R reads in the datasets:

X _test.txt
X_train.txt
y_text.txt
t_train.txt
subject_test.txt
subject_train.txt

features.txt
activity_labels.txt


After the successful running of the code, two data sets are produced as text files.

1. 
meanAndStandardDeviationFeatures.txt which contains only the features containing mean, mean frequency and standard deviation measurements along with the subject ID and activity

2. 
featureAveragebySubjectAndActivity.txt which contains the average for each selected feature by subject ID and activity

To execute the script, please make sure the following libraries are installed
1. "reshape2"
2. "plyr"

This can be done via the following line of code
> install.packages("reshape2","plyr")

To run the code, assign the working directory to where the unzipped files are located and run the following line of code
> source("run_analysis.R")



Details of the variable names and data sources can be found in Codebook.md
