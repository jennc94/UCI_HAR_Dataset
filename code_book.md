The dataset was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The dataset was downloaded into my working directory and then unzipped. 
To read in the various data files, I had to change my working directory correspondingly.
- features was the features.txt file (which measurements were taken) and column names were assigned "n" and "feature" 
(561 rows by 2 columns)
- activity was the activity_labels.txt file (which activities were tested) and column names were assigned "activityID" 
and "activity" (6 rows by 2 columns)
- test_subjects was the subject_text.txt file (subjects part of the test group) and column name was assigned "subject" 
(2947 rows by 1 column)
- test_data was the X_test.txt file (the variable measurement values for each subject in the test group during each activity) 
and column name was assigned by the "feature" column of the features dataframe (2947 rows by 561 columns)
- test_activty was the y_test.txt file (the activity ID corresponding to the data collected for each subject in the test group) 
and column name was assigned "activityID" (2947 rows by 1 column)
- train_subjects was the subject_train.txt file (subjects part of the train group) and column name was assigned "subject" 
(7352 rows by 1 column)
- train_data was the X_train.txt file (the variable measurement values for each subject in the train group during each activity) 
and column name was assigned by the "feature" column of the features dataframe (7352 rows by 561 columns)
- train_activity was the y_train.txt file (the activity ID corresponding to the data collected for each subject in the train 
group) and column name was assigned "activityID" (7352 rows by 1 column)

First, I combined the testing and training datasets individually.
- test_dataset is created by column binding the test_subjects, test_activity and test_data dataframes (in this order) 
(2947 rows by 563 columns)
- train_dataset is created by column binding the train_subjects, train_activity and train_data dataframes (in this order)
(7352 rows by 563 columns)

Then, I combined all the testing and training data together.
- complete_dataset is created by row binding the test_dataset and train_dataset (10299 rows by 563 columns)
- complete_dataset_ordered is the complete_dataset ordered by subject and then activityID
- complete_dataset_ordered was also then transformed to have all duplicated columns removed (in order to use the dplyr package)
(10299 rows by 479 columns)

Next, I selected for only the columns pertaining to mean and standard deviation values.
- mean_and_std is created by selecting the complete_dataset_ordered for the subject, activity, and any columns that contain the
string "mean" or "std" (10299 rows by 88 columns)

To make descriptive labels for the activityID, I combined the activity dataframe with my new mean_and_std dataframe.
- UCI_HAR_complete is the merging of the activity and mean_and_std dataframes (by activityID)
Using names(UCI_HAR_complete), I was able to see that the variable names were not straightforward. 
- UCI_HAR_complete was then altered to have all the variable names be descriptive and clear using gsub() to substitute any
abbreviations with the full word (10299 rows by 89 columns)

Finally, I made a new summary dataset with the average of each variable for each activity of each subject
- UCI_HAR_tosummarize is UCI_HAR_complete but grouped by activity and then subject (10299 rows by 89 columns)
- UCI_HAR_summary is the new dataset with the averages we're looking for (using the summarize_all() with mean()) (180 rows by
89 columns)
- UCI_HAR_summary.txt is the exported data of UCI_HAR_summary using write.table()

