# UCI_HAR_Dataset
The dataset for this project was found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The run_analysis.R script takes the dataset that was provided and executes the following:
- It downloads the files.
- It reads in all the files in the dataset pertaining to what the project was looking for with appropriate names.
- It combines all of the testing and training dataset files.
- It extracts only the data relating to mean and standard deviation values.
- It uses descriptive activity labels for each row.
- It uses descriptive variable names.
- It creates a new summary dataset with the average of all the variables for each activity and subject and writes this into a new text file.
The UCI_HAR_Summary.txt file is the new summary dataset described above after running the run_analysis.R script.
The code_book.md contains a description of all the variable names and summaries calculated during the running of the script. It also explains any alterations done to various variables throughout the script.
