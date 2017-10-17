This is the peer graded Course Project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

    Download the dataset if it does not already exist in the working directory
    Reads in the Test and Train files
    Reads in the Features file and sets the column names accordingly
	Merges the two data sets
	Extracts only the mean and standard deviation for each measurement
	Replaces the activity codes with the activity types from activity_lables.txt
	Appropriately labels the data set with descriptive variable names
	Creates a second, tidy data set which averages each variable for each activity and subject grouped together
	
The end result is shown in the file tidy_data.txt.