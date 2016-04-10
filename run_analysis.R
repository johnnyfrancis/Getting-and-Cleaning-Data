## Create an R script called run_analysis.R that does the following:
# 1: Merges the training and the test sets to create one data set.
# 2: Extracts only the measurements on the mean and standard deviation for each measurement.
# 3: Uses descriptive activity names to name the activities in the data set.
# 4: Appropriately labels the data set with descriptive variable names.
# 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Step Zero: Load required packages, installing any missing dependent packages if needed

if (!require("dplyr")) {
  install.packages("dplyr")
}

if (!require("tidyr")) {
  install.packages("tidyr")
}

library("dplyr")
library("tidyr")

## Step One: Combine training and test sets into one data set

# Read the data into data frames
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Add a column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# Add the column names for measurement files
names(x_train) <- features$V2
names(x_test) <- features$V2

# Add a column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"



# Combine all files into one data set
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)
data <- rbind(train, test)


## Step Two: Extract the measurements on the mean and standard deviation for each measurement

# Remove any duplicate columns
data <- data[ , !duplicated(colnames(data))]

# Keep only the columns containing the mean and standard deviation, as well as the activity and subject ID
data_ms <- select(data,contains("subjectID"), contains("activity"), contains("mean"), contains("std"))


## Step Three: Use descriptive names to name the activities in the data set

# Apply desciptive labels from the Activity Labels
data_ms$activity <- factor(data_ms$activity, levels=labels$V1, labels=labels$V2)


## Step Four: Appropriately label the data set with descriptive variable names

# Remove extraneous parentheses
names(data_ms) <- gsub('\\(|\\)',"",names(data_ms), perl = TRUE)

# Make syntactically valid names with make.names
names(data_ms) <- make.names(names(data_ms))

# Rename names with descriptive titles from the readme.txt & features_info.txt
names(data_ms) <- gsub('Acc',"Acceleration",names(data_ms))
names(data_ms) <- gsub('GyroJerk',"AngularAcceleration",names(data_ms))
names(data_ms) <- gsub('Gyro',"AngularSpeed",names(data_ms))
names(data_ms) <- gsub('Mag',"Magnitude",names(data_ms))
names(data_ms) <- gsub("^t", "Time", names(data_ms))
names(data_ms) <- gsub("^f", "Frequency", names(data_ms))
names(data_ms) <- gsub('\\.mean',"Mean",names(data_ms))
names(data_ms) <- gsub('\\.std',"StandardDeviation",names(data_ms))
names(data_ms) <- gsub("BodyBody", "Body", names(data_ms))


## Step Five: Create a second, independent tidy data set with the average of each variable for each activity and each subject

# Create a new data frame to house the "tidy" data
tidy <- tbl_df(data_ms) %>%
  
# Add the data_ms data in a long format, with meaurement types and their values broken down by the Subject ID and activity  
  gather(measurement, value, -subjectID, -activity) %>%
  group_by(subjectID, activity, measurement) %>% 
  
# Add a summary column of the mean value of each measurement by Subject ID and activity
  summarise(mean=mean(value))

# Write the tidy data to a file
write.table(tidy, "tidy.txt", row.names=FALSE)
