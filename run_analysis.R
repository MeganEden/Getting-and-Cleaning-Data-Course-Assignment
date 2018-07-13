## packages required for this project. Assumes these have already been installed.
library(data.table)
library(dplyr)
library(stringr)
library(tidyr)

## read the files in
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt', stringsAsFactors = FALSE)

features <- read.table('UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)

## from the test subfolder
subject_test<- read.table('UCI HAR Dataset/test/subject_test.txt')
X_test<- read.table('UCI HAR Dataset/test/X_test.txt')
y_test<- read.table('UCI HAR Dataset/test/y_test.txt')


## from the train subfolder
subject_train<- read.table('UCI HAR Dataset/train/subject_train.txt')
X_train<- read.table('UCI HAR Dataset/train/X_train.txt')
y_train<- read.table('UCI HAR Dataset/train/y_train.txt')


## THE SOLUTION FOR POINT 3 OF THE ASSIGNMENT
## Add the Activity Labels to y_test and y_train
activity_labels_char <- activity_labels$V2
y_test$activity <- activity_labels_char[y_test$V1]
y_train$activity <-activity_labels_char[y_train$V1]


##THE SOLUTION FOR POINT 1 OF THE ASSIGNMENT

## Rename V1 to Activity Index using a substitution
names(y_test)[names(y_test)== "V1"] <- "act ID"
names(y_train)[names(y_train)== "V1"] <- "act ID"


## Add a column identifying the file as test or train. This will be used later
## when the files are merged.
y_test$source <- rep("test", nrow(y_test))
y_train$source <- rep("train", nrow(y_train))

## Rename the columns of X_test and X_train with the corresponding Features names
## uses the data.table package
old_column_names_test <- names(X_test)
old_column_names_train <- names(X_train)
new_column_names <- features$V2
setnames(X_test, old = old_column_names_test, new = new_column_names)
setnames(X_train, old = old_column_names_train, new = new_column_names)

## create an ID column for the X and y files in order to merge them on this column
X_test$ID <- c(1:nrow(X_test))
y_test$ID <- c(1:nrow(y_test))
X_train$ID <- c(1:nrow(X_train))
y_train$ID <- c(1:nrow(y_train))

## merge X and y files for test and train
merge_x_y_test <- merge(y_test, X_test, by = "ID")
merge_x_y_train <- merge(y_train, X_train, by = "ID")

## rename the subject files column V1 to subject
names(subject_test)[names(subject_test)== "V1"] <- "subject"
names(subject_train)[names(subject_train)== "V1"] <- "subject"


## add and ID column to the subject files in order to be able to merge on this
## with the merge_x_y files
subject_test$ID <- c(1:nrow(subject_test))
subject_train$ID <- c(1:nrow(subject_train))

## merge subject files with the merge_x_y files
merge_x_y_subject_test <- merge(subject_test, merge_x_y_test, by = "ID")
merge_x_y_subject_train <- merge(subject_train, merge_x_y_train, by = "ID")

## combine the merge_x_y_subject files
merge_test_train <- rbindlist(list(merge_x_y_subject_test,merge_x_y_subject_train))


## THE SOLUTION FOR POINT 2 OF THE ASSIGNMENT

## creates a list of the variables in the merged file that have 
##"mean" or "std" in the variable label
merge_test_train_mean_std <- subset(merge_test_train, 
                          select = grep(names(merge_test_train),
                                        pattern = "^.*mean.*$|^.*std.*$|^activity$|^subject$", 
                                        value = TRUE))

## removing those columns with "meanFreq" as they are not required
merge_test_train_mean_std <- select(merge_test_train_mean_std, -contains("meanFreq"))


## THE SOLUTION FOR POINT 4 OF THE ASSIGNMENT

## renaming the columns with more descriptive names
rename_merge <- names(merge_test_train_mean_std)
## perform the updates to the variable names
rename_merge %<>%
  str_replace_all("-X", "-X axis") %>%
  str_replace_all("-Y", "-Y axis") %>%
  str_replace_all("-Z", "-Z axis") %>%
  str_replace_all("mean\\(\\)", " mean") %>%
  str_replace_all("std\\(\\)", " std dev") %>%
  str_replace_all("Mag", ".Magnitude") %>%
  str_replace_all("AccJerk", ".Acceleration.Jerk.Signal") %>%
  str_replace_all("GyroJerk", ".Gyration.Jerk.Signal") %>%
  str_replace_all("Gyro", ".Gyration") %>%
  str_replace_all("BodyAcc", "Body.Acceleration") %>%
  str_replace_all("tGravityAcc", "Time.Domain.Gravity.Acceleration") %>%
  str_replace_all("BodyBody", "Body") %>%
  str_replace_all("Acceleration-", "Acceleration.Signal-") %>%
  str_replace_all("Gyration-", "Gyration.Signal-") %>%
  str_replace_all("Acceleration.Magnitude", "Acceleration.Signal.Magnitude") %>%
  str_replace_all("tBody", "Time.Domain.Body") %>%
  str_replace_all("fBody", "Frequency.Domain.Body")

## apply the updates to the variable names in the data frame
names(merge_test_train_mean_std) <- rename_merge

## launch a view of the resulting data frame to confirm changes
View(merge_test_train_mean_std)


## THE SOLUTION FOR POINT 5 OF THE ASSIGNMENT
## using the summarise_all function from dplyr as the same function is 
## being applied to every variable
av_activity_subject <- merge_test_train_mean_std %>% 
                            group_by(activity, subject) %>%
                            summarise_all(funs(mean))

## updating the variable names to reflect the values being averages
## the first 2 columns do not need to be updated
update_varnames <- names(av_activity_subject)[3:length(av_activity_subject)]
update_varnames <- paste("The Average of ", update_varnames, sep = "") 
update_varnames <- append(update_varnames,c("activity","subject"), after = 0)
names(av_activity_subject) <- update_varnames

## launch a view of the resulting data frame to confirm changes
View(av_activity_subject)
