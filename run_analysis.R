#####################################################
# Coursera Getting and Cleaning Data Course Project #
#####################################################

#######################
# Project description #
#######################


# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Data description link
#
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
# Here are the data for the project: 
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 

library(data.table)

###################################
# Downloading and reading in data #
###################################

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./rawData.zip")
# 
# unzip("./rawData.zip")

# read in the featuresures file
features = read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F)
head(features)
features = features[,-1]

# read in activity labels
activityLabels = read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
head(activityLabels)
colnames(activityLabels) = c("classLabel","activityName")

# set up activityLabels as a data.table, so that we can look up the activityName by using the classLabel
activityLabels = data.table(activityLabels)
setkey(activityLabels, classLabel)

##  read in the training set ##

# read in training data
trainingSet = read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = F)
head(trainingSet)

# read in training labels
trainingSetLabels = read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors = F)
head(trainingSetLabels)

# read in training set subject
trainingSetSubject = read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = F)
head(trainingSetSubject)

# add subject to the training set as the first column
trainingSet = cbind(trainingSetSubject,trainingSet)
colnames(trainingSet)[1] = "subject"




## read in the test set ##
# read in test data
testSet = read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = F)
head(testSet)

# read in test labels
testSetLabels = read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors = F)
head(testSetLabels)

# read in test set subject
testSetSubject = read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = F)
head(testSetSubject)

# add subject to the test set as the first column
testSet = cbind(testSetSubject,testSet)
colnames(testSet)[1] = "subject"


## Check if the dimensions of the training and test set match ##
dim(trainingSet)
dim(testSet)

# training and test set have equal number of columns, but differing amount of rows


#######################################
# Step 1. Merge training and test set #
#######################################

# combine the training and test set by row binding them, adds the test set at the end of the training set
combinedData = rbind(trainingSet, testSet)

###########################################################################
# 4. Appropriately labels the data set with descriptive variable names.   #
###########################################################################

# set the column names of the data, column names are the 

# want to create a cleaner column names
colnames(combinedData) = c("subject",make.names(tolower(features), unique = T))


################################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.   #
################################################################################################

# find columns that include mean or std, but not meanFreq
meanstdcol = grepl("(mean|std)[^meanFreq]", colnames(combinedData))

# want to include the subject, the first colum, so turn it to TRUE
meanstdcol[1] = T

meanstdData = combinedData[,meanstdcol]

###########################################################
# Step 3. Use desciptive activity names to label the data #
###########################################################

# add labels to the data set, will use activityName from activity_labels.txt file.
# Will look up activityName by the training and test set labels.
# will be the first column in the data set
meansdtData = cbind(c(activityLabels[.(trainingSetLabels), activityName],
                       activityLabels[.(testSetLabels), activityName]),
                       meanstdData, stringsAsFactors = F)

colnames(meansdtData)[1] = "activity"



######################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with   #
# the average of each variable for each activity and each subject.                   #
######################################################################################

meansdtData = data.table(meansdtData)
setkey(meansdtData,activity, subject)

meanByActivitySubject = meansdtData[,lapply(.SD,mean), by = .(activity,subject)]

write.table(meanByActivitySubject, "meanByActivitySubject.txt", row.name = F)
