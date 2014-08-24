+Getting and Cleaning Data - Course Project 1 (CP1)
+===========
+
+### Summary
+
+The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
+
+The data that is cleaned for later processing in this course project is related to wearable computing. Here are the data for the project:
+
+https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
+
+A full description is available at the site where the data was obtained:
+
+http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
+
+The R script called run_analysis.R does the following:
+
+ 1. Merges the training and the test sets to create one data set.
+ 2. Extracts only the measurements on the mean and standard deviation for each measurement.
+ 3. Uses descriptive activity names to name the activities in the data set
+ 4. Appropriately labels the data set with descriptive activity names.
+ 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
+
+Summary of processing performed by the run_analysis.R script
+===========
+
+First, the global environment is cleaned up (all variables are removed).
+
+Second, the working directory is set up. If you are going to use this script to clean the latest version of the data available on the server, take into accont the following highlights about the working directory to be used:
+ - it has to be changed to your local folder which contains the following
+ - it contains run_analysis.R
+ - it contains the uncompressed rawdata folder called "UCI HAR Dataset"
+You will need to set up the working directory accordingly (modify the "setwd(...)" taking into account the local folder where the data was downloaded in your computer).
+
+
+### Part 1: Creation of data set 1 (CP1 requirements 1-4)
+
+Step 1. Reading data from rawfiles and conversion to proper data types
+subject_id (1 line/record)
+ files:
+ ./UCI HAR Dataset/train/subject_train.txt
+ ./UCI HAR Dataset/test/subject_test.txt
+activity performed during acquisition record (1 line/record)
+ files:
+ ./UCI HAR Dataset/activity_labels.txt , correspondance: int_id vs activity
+ ./UCI HAR Dataset/train/y_train.txt
+ ./UCI HAR Dataset/test/y_test.txt
+features, results of processing the rawdata (1 line/record)
+ files:
+ ./UCI HAR Dataset/features.txt , column/variable names
+ ./UCI HAR Dataset/train/X_train.txt
+ ./UCI HAR Dataset/test/X_test.txt
+
+Step 2. Merge the train and test data sets
+
+Step 3. Select correct columns from raw_feature_df
+
+Step 4. Create the data frame for DataSet1
+
+Step 5. Save the DataSet1 data frame to a csv file with txt extension
+
+Step 6. Example code to read DataSet1 properly (with proper data types)
+
+
+### Part 2: Creation of data set 2 (CP1 requirement 5)
+
+Step 1. Properly read DataSet1 from file
+
+Step 2. Process DataSet1 to fill the DataSet2 data frame
+ (perform averages for each subject and activity)
+
+Step 3. Save the DataSet2 data frame to a csv file with txt extension
+
+Step 4. Example code to read DataSet2 properly (with proper data types)
