library(data.table)
library(stringr)

FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data")){dir.create("./data")}

#Download Files

#download.file(FileUrl, destfile="./data/UCI_HAR_Dataset.zip")

#read in data files

subject_train <- fread("data/UCI HAR Dataset/train/subject_train.txt")

subject_test <- fread("data/UCI HAR Dataset/test/subject_test.txt")

y_train <- fread("data/UCI HAR Dataset/train/y_train.txt")

y_test <- fread("data/UCI HAR Dataset/test/y_test.txt")

x_train <- fread("data/UCI HAR Dataset/train/X_train.txt", sep = " ")

x_test <- fread("data/UCI HAR Dataset/test/X_test.txt", sep = " ")

#merge the data sets

subject <- rbind(subject_train, subject_test)
names(subject) <- c("Subject")
y <- rbind(y_train, y_test)
names(y) <- c("Label")
x <- rbind(x_train, x_test)


subjectxy <- cbind(subject, x, y)

#Set the key for Subject and Label

setkey(subjectxy, Subject, Label)

#Extracts only the measurements on the mean and standard deviation for each measurement.

features <- fread("data/UCI HAR Dataset/features.txt")

names(features) <- c("featureIndex", "feature")

#extract mean and standard deviation

features <- features[grepl("mean\\(\\)|std\\(\\)", feature)]

#create indices to filter subjectxy

raw_feature_name <- paste0("V", features$featureIndex)

subjectxy <- subjectxy[, c(key(subjectxy), raw_feature_name), with = FALSE]

#Uses descriptive activity names to name the activities in the data set

descriptive_activity_names <- fread("data/UCI HAR Dataset/activity_labels.txt")

names(descriptive_activity_names) <- c("Label", "activity")

#Appropriately labels the data set with descriptive variable names.

subjectxy <- merge(subjectxy, descriptive_activity_names, by = "Label", all.x = TRUE)

for(i in 1:length(raw_feature_name))
{

    new_name <- features$feature[i]

    search_string = "(^[ft])(Body|Gravity)*(Gyro|Acc)*(Jerk)*(Mag)*-(mean|std)\\(\\)[-]*([XYZ])*"

    new_name <- paste(str_match(new_name, search_string)[,2:8], collapse = '_')

colnames(subjectxy)[colnames(subjectxy)==raw_feature_name[i]] <- new_name 
}

#Tidy Data
library(dplyr)
library(tidyr)
library(reshape2)

#Label, Subject, activity

subjectxy <- melt(subjectxy, id.vars = c("Label", "Subject", "activity"), value.name = "activity_values", variable.name = "space_frame_device_jerk_magnitude_statistic_axis")

subjectxy <- tbl_df(subjectxy)

subjectxy <- subjectxy %>% separate(space_frame_device_jerk_magnitude_statistic_axis, c("space","frame","device","jerk","magnitude","statistic","axis"))

subjectxy <- subjectxy[, 2:length(names(subjectxy))]

#create independent data set with average value grouped by activity and subject

subjectxy_tidy <- subjectxy %>% group_by(Subject, space,frame,device,jerk,magnitude,statistic,axis) %>% summarize(avg_value = mean(activity_values))

write.table(subjectxy_tidy, file = "tidy_smartphone_data.txt", row.names = FALSE)
