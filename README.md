# Getting and Cleaning Data Course Assignment
# Objective
The objective of this README file is to explain how my run_analysis.R script meets the requirements of the assignment.

# Background
(copied from the assignment instructions page)

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



# Data Files Used
After having reviewed the README and features_info files supplied in the zip file, I decided that not all files provided were required.

The files included in the Inertial Signals subfolders look to be raw data upon which the files I've used were built. I believe it's outside the scope of this assignment to verify the values provided in the files.

Files uses are as follows
Files used are as follows
1. activity_labels.txt
2. features.txt

from the test subfolder

3. subject_test.txt

4. X_test.txt

5. y_test.txt

from the train subfolder

6. subject_train.txt

7. X_train.txt

8. y_train.txt

# Assumptions Made
Ideally each related file should contain at least 1 common variable. This was not the case with these files. I have therefore assumed that each file is in the exact order to allow a simple 1 to 1 match. i.e. If both files contain the same number of rows, the rows are in the correct order already and it's a simple matter of merging.

# Manipulations
Comments provided in run_anlysis.R script also provide detail of the manipulations undertaken to produce the 2 outputs.

Even though the addition of labels to the files wasn't asked for until step 3, I have a preference for adding meaningful descriptions to the data as early as possible. I find it easier to work and problem solve with. So manipulations undertaken were in the following order.

1. As the values in y_test and y_train were in the 1:6 range and there were 6 activities, I concluded the values in y_test and y_train corresponded to these activities. I used this as the key to add a new "activity" column to y_test and y_train. This contained the activity labels (v2 of activity_labels). This meets the requirement of PART 3 OF THE ASSIGNMENT.

2. "V1" for both data frames were renamed to "act ID"

3. Even though this next manipulation was called for in the assignment, I felt adding a "source" (test or train) column to the final solution would allow grouping by these for analysis purposes. i.e. Instead of having to remember which subjects were part of which group, using this column to group_by would be easier.

4. The number of variables in x_test and x_train were both 561 and the features data frames had 561 rows. I therefore concluded the features column "V2" contained variable names. So the variable names in x_test and x_train were replaced with the features column "V2".

5. In order to merge y_test with x_test and y_train with x_train, I needed a common variable and there wasn't one. Using the assumption outlined above, I created a new column in all 4 files called "ID" and filled it using a sequence from 1 to the length of each data frame. This worked because the length of y_test and x_test were the same and so were y_train and x_train. The resulting data frames were named merge_x_y_test and merge_x_y_train respectively.

6. A check of the values in subject_test and subject_train showed they were in the range 1:30 collectively. There were no instances where the same value was in both files. I therefore concluded these corresponded to the subjects in the test, so columns V1 in those files were renamed to "subject".

7. The lengths of subject_test and merge_x_y_test were the same, so based on the assumption outlined above, these could be merged. However as was the case in point 5 there was no common column to merge on. So again I added and "ID" column to subject_test using the same approach as mentioned in point 5. The same is true for subject_train and merge_x_y_train.

8. subject_test and merge_x_y_test were merged to create merge_x_y_subject_test. subject_train and merge_x_y_train were merged to create merge_x_y_subject_train.

9. As both merge_x_y_subject_test and merge_x_y_subject_train have the same columns in each, it was a matter of row binding them to come up with a data frame that met the requirements of STEP 1 OF THE ASSIGNMENT. The name of that being merge_test_train.

10. In order to meet the requirements of STEP 2 OF THE ASSIGNMENT. I created a subset of merge_test_train based on selecting columns with "mean" or "std" or "activity" or "subject" in their title. The resulting data frame was merge_test_train_mean_std.

11. This approach also meant that columns with "meanFreq" were selected. (I tried numerous approaches to have these excluded at the same time as running the inclusions and wasn't able to do so. I would be interested to see how others approached this.) I excluded the "meanFreq" columns by using a select statement with a -contains argument. I just updated the existing data frame merge_test_train_mean_std.

12. In order to meet the requirements of STEP 4 OF THE ASSIGNMENT. I decided to create a vector of the column names. I then ran a number of str_replace_all statements to modify these names to what I believe are more descriptive. I then replaced the column names in the data frame with the resulting vector values.

13. The first step of meeting the requirements of STEP 5 OF THE ASSIGNMENT was grouping merge_test_train_mean_std by activity and then by subject, then summarising the other variables using the mean function. The resulting data frame was named av_activity_subject.

14. The final step of meeting the requirements of STEP 5 OF THE ASSIGNMENT was updating the column names to reflect the fact they were averages of the variables. I used the same approach as outlined in step 12 with a slight variation to account for the fact that "activity" and "subject" did not need updating.

# Outputs
I have included 3 View() arguments in the script, so you're able to see the data frames I produced for step 1, 4 and 5.

1. merge_test_train - Step 1

2. merge_test_train_mean_std - Step 4

3. av_activity_subject - Step 5


# "Tidy Data" criteria
1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

I believe I have met these criteria with resulting data frames produced for steps 4 and 5. Each row is a series of unique observations made about 1 activity for 1 subject. i.e. there is no duplication with the activity - subject combination. All of the other columns are unique measurements that relate to these 2.

In addition, the manipulation performed to go from step 4 to step 5, this was a simple grouping and averaging of the values. There were no conversions, merging, binding etc required to achieve the outcome. Therefore it was an easy process to undertake that basic analysis step.

Just a final note, only because the assignment didn't call for it, I didn't bring through the "source" column I created earlier in the process. In my opinion some of the earlier analysis you would undertake would be comparing the test group against the train group and that's why you would include something like that.
