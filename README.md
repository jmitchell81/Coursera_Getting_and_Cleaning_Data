# Submission for Getting and Cleaning Data Assignment

## Description

This script takes the smartphone wearable techonology measurements, combines the
training and testing data sets into one dataframe with tidy identifiers for the
subject being measure, the activity taking place, and the subject's assignment
to the training or testing datasets. This combined dataframe is then used to calculate
the average values of each mean and standard deviation measurement for each activity
for each subject.

## Before running the script

Be sure you have the unzipped "UCI HAR Dataset" file stored in your working directory

# To read the resulting summariszed script tidy_Dataset.txt

```
data <- read.table("tidy_Dataset.txt", header = TRUE) 
View(data)
```

## Script Walkthrough

run_analysis.R

### Read in the data features

Features are imported from "UCI HAR Dataset/features.txt". Parentheses were removed
and hyphens replaced with periods because assigning the features as column names for
the dataframes replaced them all with periods and made the column names difficult
to read.

### Read the activity labels definitions

Activity labels were read in to serve as a dictionary for later convering the label
code names to the full activity names.

### Load training and test sets

Each dataset's X, y, and subject files are read in with corresponding column names
from the features.txt file. The file with the primary measurements (X) is combined
with y and subject files along with a new column "dataset" to denote if the data
comes from the training or testing datasets (as per part 4 of the assignment).

### merge the training and testing data sets into one data frame

The two dataframes are merged with rbind as there are no subjects in common
between the training and testing sets.

### Extracts only the measurements on the mean and standard deviation for each measurement

The dataframe is subset to the three id variables ("dataset", "subject",
"activity") and variables pertaining to measurement means and standard deviations
using the patterns "*mean*|*std*"

### Use descriptive activity names to name the activities in the data set

The dataframe of activities saved earlier is used to replace each of the
coded activity names with their corresponding full names.

### creates a second, independent tidy data set with the average of 
### each variable for each activity and each subject.

The data is first melted into a tall dataframe with the three id variables 
("dataset", "subject", "activity") and all other variables treated as measurement
variables. The data is then recast with the model "subject+dataset+activity\~data_vars"
so that the mean for each activity for each subject is calculcated. Because there
are no subjects belonging to both datasets, the output is the same as using the
model "subject+activity~data_vars"

