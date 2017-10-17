## Download and unzip the dataset:
filename <- "getdata_assignment.zip"

if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, mode ='wb')
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

# Read in Test files and name SubjectTest columns to 'subject' and y_test columns to 'activity'
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "activity")

# Read in Train files and name SubjectTrain columns to 'subject' and y_train columns to 'activity'
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "activity")

# Read in features.txt to get column names for xTrain and xTest
featuresNames <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
colnames(xTrain) <- featuresNames$V2
colnames(xTest) <- featuresNames$V2

# Column Bind all Test files & Train Files
mergedTrain <- cbind(xTrain, subjectTrain, yTrain)
mergedTest <- cbind(xTest, subjectTest, yTest)

# Row Bind both Train and Test
mergedData <- rbind(mergedTrain, mergedTest)

# Extract only the measurements on the mean and standard deviation for each measurement
meanStdData <- mergedData[grep("subject|activity|\\mean\\b|std", names(mergedData), value=TRUE)]

# Descriptive activity names to name the Activities
activityLabel <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
activityLabel$V2 = as.character(as.factor(activityLabel$V2))

for (i in 1:nrow(activityLabel)){
        meanStdData$activity[meanStdData$activity==i] <- activityLabel$V2[i]
}

# Appropriately labels the data set with descriptive variable names
names(meanStdData) <- gsub("^t", "time", names(meanStdData))
names(meanStdData) <- gsub("^f", "frequency", names(meanStdData))
names(meanStdData) <- gsub("Acc", "Accelerometer", names(meanStdData))
names(meanStdData) <- gsub("Gyro", "Gyroscope", names(meanStdData))
names(meanStdData) <- gsub("Mag", "Magnitude", names(meanStdData))
names(meanStdData) <- gsub("BodyBody", "Body", names(meanStdData))

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
library(dplyr)
data2 <- meanStdData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))

# Save to File tiday_data.txt
write.table(data2, "tidy_data.txt", row.names = FALSE, quote = FALSE)
