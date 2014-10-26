# Getting and Cleaning Data Course Project
# The goal is to prepare tidy data that can be used for later analysis

# Set working directory to the location where the UCI HAR Dataset was unzipped
# Load the data

setwd("~/Documents/Coursera_DS/Module3/Course Project/UCI HAR Dataset")
ytrain <- read.table("./train/y_train.txt", sep ="", header=FALSE)
ytest <- read.table("./test/y_test.txt", sep="", header=FALSE)
act_label <- read.table("activity_labels.txt", sep="", header=FALSE)
xtrain <- read.table("./train/X_train.txt", sep="", header=FALSE)
xtest <- read.table("./test/X_test.txt", sep="", header=FALSE)
feat_label <- read.table("features.txt", sep="", header=FALSE)
subject_train <- read.table("./train/subject_train.txt", sep="", header=FALSE)
subject_test <- read.table("./test/subject_test.txt", sep="", header=FALSE)

# Append training and testing records for activities.
# Uses descriptive activity names to name the activities in the merged data set

y <- rbind(ytrain,ytest)
colnames(y) <- c("Act_ID")
colnames(act_label) <- c("Act_ID", "Activities")
y_label <- data.frame(act_label[y$Act_ID,"Activities"])
colnames(y_label) <- c("Activities")

# Append training and testing records for measurements.
# Appropriately labels the merged data set with descriptive variable names.

x <- rbind(xtrain, xtest)
colnames(x) <- feat_label[[2]]

# Append training and testing records for volunteers.
# Label the column name as volunteers

subject <- rbind(subject_train, subject_test)
colnames(subject) <- c("Volunteers")

# Merge all 3 data sets (Subject, Activities, Measurements) 
# to create one data set

dataset <- cbind(subject,y_label) 
dataset <- cbind(dataset, x)

# Extracts only the measurements on the mean 
# and standard deviation for each measurement

reduce <- dataset[c(1,2,grep("mean\\(", colnames(dataset)),
                  grep("std\\(", colnames(dataset)))]

# Create an aggregate data set based on average
reduce.mean <- aggregate(reduce[3:68],
                         by = list(Volunteers=reduce$Volunteers,
                                   Activities=reduce$Activities),
                         FUN=mean)

# Export output files
write.table(reduce, "./reduce.txt", row.names = FALSE)
write.table(reduce.mean, "./tidyset.txt", row.names=FALSE)



