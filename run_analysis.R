#Getting and Cleaning Data Doursera - project1
#You should create one R script called run_analysis.R that does the following. 

# Read in dataset each data file
# Labels and Features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE,)
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)

#Test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

#Train Data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## Create a data frame with all the test and train labels
#test and train set cloumn bind
labels_test <- cbind(subject_test,y_test)
labels_train <- cbind(subject_train,y_train)
merged_labels <- rbind(labels_test,labels_train)

#test_data <- cbind(subject_test,y_test,X_test)
#train_data <- cbind(subject_train,y_train,X_train)

# Join the test and train data set by Rows
merged_data <- rbind(X_test,X_train)

#Add column names to test and train data
colnames(merged_data) <- features[,2]

#Merge Labels to the train and test set
merged_data2 <- cbind(merged_labels, merged_data)

# Add column name to the Subject and Labels
colnames(merged_data2)[1:2] <- c("Subjects","Activity_Labels")

## find Subdet of columns that are either mean or standard deviation and combine it
#to for a new data set with only those column
merged_data3_mean <- merged_data2[,grep("mean()",colnames(merged_data2), value=TRUE)]
merged_data3_std <- merged_data2[,grep("std()",colnames(merged_data2), value=TRUE)]
merged_data3 <- cbind(merged_data2[,1:2],merged_data3_mean,merged_data3_std)

## Replace and the Activity Labels code with readable names
merged_data3$Activity_Labels[merged_data3$Activity_Labels == 1] <- "WALKING"
merged_data3$Activity_Labels[merged_data3$Activity_Labels == 2] <- "WALKING_UPSTAIRS"
merged_data3$Activity_Labels[merged_data3$Activity_Labels == 3] <- "WALKING_DOWNSTAIRS"
merged_data3$Activity_Labels[merged_data3$Activity_Labels == 4] <- "SITTING"
merged_data3$Activity_Labels[merged_data3$Activity_Labels == 5] <- "STANDING"
merged_data3$Activity_Labels[merged_data3$Activity_Labels == 6] <- "LAYING"

#library(reshape2)
require(reshape2)
merged_data3_average <- melt(merged_data3, id = c("Subjects","Activity_Labels"))
merged_data3_mean <- dcast(merged_data3_average, Subjects + Activity_Labels ~ variable,mean)
merged_data3_mean

#Write tidy data out to a text file to working directory
write.table(merged_data3_mean, file="tidy_data.txt", sep="\t", row.names = FALSE)

