##First, set your working directory
setwd("/Users/jenniferchen/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data")
##Now let's download the file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "~/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/Dataset.zip", method = "curl")
##Note that the file was a .zip file and therefore we will need to unzip it
unzip("~/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/Dataset.zip")
list.files() ##see that the dataset was successfully unzipped and now we have the UCI HAR Dataset in our working directory

##Now we begin to read in the various tables. Here, I have also assigned appropriate names to each column.
##The features and activity files are in this first working directory
setwd("/Users/jenniferchen/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
features <- read.table("features.txt", col.names = c("n", "feature"))
activity <- read.table("activity_labels.txt", col.names = c("activityID", "activity"))
##The test files are in a different working directory
setwd("/Users/jenniferchen/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test")
test_subjects <- read.table("subject_test.txt", col.names = "subject")
test_data <- read.table("X_test.txt")
colnames(test_data) = features[,2] ##Named the columns for test_data based on the names provided in the features file
test_activity <- read.table("y_test.txt", col.names = "activityID")
##The train files are now in another working directory
setwd("/Users/jenniferchen/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/UCI HAR Dataset/")
setwd("/Users/jenniferchen/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train")
train_subjects <- read.table("subject_train.txt", col.names = "subject")
train_data <- read.table("X_train.txt")
colnames(train_data) = features[,2] ##Again, named columns for train_data based on names from the features file
train_activity <- read.table("y_train.txt", col.names = "activityID")

##Now lets create a dataframe for each test and train dataset
test_dataset <- cbind(test_subjects, test_activity, test_data) ##column binding all the data for the test dataset
train_dataset <- cbind(train_subjects, train_activity, train_data) ##column binding all the data for the train dataset
##And now to merge the two datasets
complete_dataset <- rbind(test_dataset, train_dataset)
##Let's order by subject and then activityID to make things clean
##Ordered by subject and then activityID here
complete_dataset_ordered <- complete_dataset[order(complete_dataset$subject, complete_dataset$activityID), ]

##Now to extract only the columns with mean and std values
##I'm going to use the plyr and dplyr packages (needs to be loaded in this way)
library(plyr)
library(dplyr)
##There are duplicated column names in the dataset which doesn't allow me to create tibbles
##These columns are not the columns that I want to extract and therefore, I removed all the duplicated columns
complete_dataset_ordered <- complete_dataset_ordered[, !duplicated(colnames(complete_dataset_ordered))]
##Now I am selecting for only the columns of interest
##Note that the contains() has ignore.case set default to TRUE
mean_and_std <- select(complete_dataset_ordered, subject, activityID, contains("mean"), contains("std"))

##Next we want to change the activityID labels into the actual activity names to make them descriptive
##Since the activityID columns are named the same in both my new dataset and the activity dataframe, I will join them
UCI_HAR_complete <- join(activity, mean_and_std)

##Now we want to make all variable names clear and descriptive
names(UCI_HAR_complete) ##First I'm going to see what all the variable names look like right now
##There are quite a few areas of the names that can be improved and here I've substituted all of these to make them more clear
names(UCI_HAR_complete) <- gsub("^t", "Time", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("tBody", "TimeBody", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("^f", "Frequency", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("BodyBody", "Body", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("-mean()", "Mean", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("-std()", "Std", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("angle", "Angle", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("gravity", "Gravity", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("Acc", "Accelerator", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("Mag", "Magnitude", names(UCI_HAR_complete))
names(UCI_HAR_complete) <- gsub("Gyro", "Gyroscope", names(UCI_HAR_complete))

##Now to create a new tidy dataset with the average of each variable of each activity and each subject
##First I'm going to make groups -> grouped by activity and then subject
UCI_HAR_tosummarize <- group_by(UCI_HAR_complete, activity, subject)
##To create a summary of all the variables, use the summarize_all() and the function here is mean() for averages
UCI_HAR_summary <- summarize_all(UCI_HAR_tosummarize, funs(mean))
##Setting my working directory to where I want my new tidy summary file to be stored
setwd("/Users/jenniferchen/Desktop/PhD Research Project/Coursera/Getting and Cleaning Data/UCI HAR Dataset/")
##Write out my new tidy summary file
write.table(UCI_HAR_summary, "UCI_HAR_summary.txt", row.names = FALSE)