
# Coursera Getting and Cleaning Data Project
# Jacob Mitchell
# 2022.02.19

# You should create one R script called run_analysis.R that does the following. 

# - Merges the training and the test sets to create one data set.

# - Extracts only the measurements on the mean and standard deviation for each measurement. 

# - Uses descriptive activity names to name the activities in the data set

# - Appropriately labels the data set with descriptive variable names. 

# - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###############################################################################

# Load required libraries
library(dplyr)
library(reshape2)

## Reading and merging the training and test sets

## Read in the data features
features <- read.table("UCI HAR Dataset/features.txt")[,2]

# Remove parentheses, replace hyphens with periods
features <- gsub("\\(", "", features)
features <- gsub("\\)", "", features)
features <- gsub("-", ".", features)

# Read the activity labels definitions
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              col.names = c("label", "activity"))

## Load training and test sets

## training set
training <- read.table("UCI HAR Dataset/train/X_train.txt",
                       col.names = features)

# append subject and activity columns
training_activity <- read.table("UCI HAR Dataset/train/y_train.txt",
                                col.names = c("activity"))
training_subject <- read.table("UCI HAR Dataset/train/subject_train.txt",
                                col.names = c("subject"))
training_y <- cbind(training_subject, training_activity)
training <- cbind(training_y, training)

## 4 - Add column denoting samples as training set
training$dataset <- "training"
training <- relocate(training, dataset, .before = subject)

## test set
test <- read.table("UCI HAR Dataset/test/X_test.txt",
                   col.names = features)

# append subject and activity columns
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt",
                                col.names = c("activity"))
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt",
                               col.names = c("subject"))
test_y <- cbind(test_subject, test_activity)
test <- cbind(test_y, test)

## 4 - Add column denoting samples as training set
test$dataset <- "testing"
test <- relocate(test, dataset, .before = subject)

# merge the training and testing data sets into one data frame
merge_dataset <- rbind(training, test)

## 2 - Extracts only the measurements on the mean and standard deviation for each measurement

# Create a subset dataframe including only
# The dataset, subject, activity,
# mean and standard deviation of each measurement

merge_dataset <- merge_dataset[,grep("dataset|subject|activity|*mean*|*std*",
                               colnames(merge_dataset))]

## 3 - Uses descriptive activity names to name the activities in the data set

# Rename activities from code to activity name
for (i in unique(activity_labels$label)){
  merge_dataset$activity <- gsub(i, activity_labels[activity_labels$label == i,][[2]], merge_dataset$activity)
}

## 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Distinguish ID variables and measurement variables
data_id <- c("dataset", "subject", "activity")
data_vars <- colnames(merge_dataset)[4:length(colnames(merge_dataset))]

# melt to a tall dataframe
dfmelt <- melt(merge_dataset, id = data_id,
               measure.vars = data_vars)

# dcast to calculate average of mean and std statistics for each activity for each subject
data_summary <- dcast(dfmelt, subject+dataset+activity~data_vars, mean)

# save tidy dataset
write.table(data_summary, file = "tidy_Dataset.txt")

# save variable names
write.table(colnames(data_summary), file = "variables.txt")


