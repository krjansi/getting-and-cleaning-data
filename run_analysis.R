+# Getting and Cleaning Data - Course Project 1 (CP1)
+
+# clean the global environment
+rm( list=ls() )
+
+# note about working directory:
+# - it has to be changed to your local folder which contains the following
+# - it contains run_analysis.R
+# - it contains the uncompressed rawdata folder called "UCI HAR Dataset"
+setwd('/home/jespestana/Documents/E-Courses/Data_Science_Specialization/03_Getting_Cleaning_Data/exercises/week_3/CP1')
+
+# ---------------------------------------------------------
+# Part 1: Creation of data set 1 (CP1 requirements 1-4)
+# ---------------------------------------------------------
+
+# Step 1. Reading data from rawfiles and conversion to proper data types
+# subject_id (1 line/record)
+# files:
+# ./UCI HAR Dataset/train/subject_train.txt
+# ./UCI HAR Dataset/test/subject_test.txt
+raw_subject_id_train <- readLines("./UCI HAR Dataset/train/subject_train.txt")
+raw_subject_id_train <- as.integer(raw_subject_id_train) # integer vector
+raw_subject_id_test <- readLines("./UCI HAR Dataset/test/subject_test.txt")
+raw_subject_id_test <- as.integer(raw_subject_id_test) # integer vector
+# activity performed during acquisition record (1 line/record)
+# files:
+# ./UCI HAR Dataset/activity_labels.txt , correspondance: int_id vs activity
+# ./UCI HAR Dataset/train/y_train.txt
+# ./UCI HAR Dataset/test/y_test.txt
+raw_activity_factornames <- readLines("./UCI HAR Dataset/activity_labels.txt")
+raw_activity_factornames <- sapply(
+ raw_activity_factornames,
+ function(x) {
+ idx <- grepRaw( " ", x)
+ substr(x, (idx+1), nchar(x)) },
+ USE.NAMES=FALSE )
+raw_activity_factornames <- factor(
+ raw_activity_factornames,
+ levels=raw_activity_factornames )
+raw_activity_type_train <- readLines("./UCI HAR Dataset/train/y_train.txt")
+raw_activity_type_train <- as.integer(raw_activity_type_train)
+raw_activity_type_test <- readLines("./UCI HAR Dataset/test/y_test.txt")
+raw_activity_type_test <- as.integer(raw_activity_type_test)
+# features, results of processing the rawdata (1 line/record)
+# files:
+# ./UCI HAR Dataset/features.txt , column/variable names
+# ./UCI HAR Dataset/train/X_train.txt
+# ./UCI HAR Dataset/test/X_test.txt
+raw_feature_names <- readLines("./UCI HAR Dataset/features.txt")
+raw_feature_names <- sapply(
+ raw_feature_names,
+ function(x) {
+ idx <- grepRaw( " ", x)
+ substr(x, (idx+1), nchar(x)) },
+ USE.NAMES=FALSE )
+raw_feature_df_train <- read.csv(
+ file="./UCI HAR Dataset/train/X_train.txt",
+ sep="",
+ header=FALSE )
+colnames(raw_feature_df_train) <- raw_feature_names
+#sum(as.character(sapply( raw_feature_vector_train, class)) == "numeric")
+raw_feature_df_test <- read.csv(
+ file="./UCI HAR Dataset/test/X_test.txt",
+ sep="",
+ header=FALSE )
+colnames(raw_feature_df_test) <- raw_feature_names
+rm( list = c("raw_feature_names") )
+#sum(as.character(sapply( raw_feature_vector_test, class)) == "numeric")
+# Step 2. Merge the train and test data sets
+raw_feature_df <- rbind( raw_feature_df_train, raw_feature_df_test)
+raw_activity_type <- c( raw_activity_type_train, raw_activity_type_test)
+raw_subject_id <- c( raw_subject_id_train, raw_subject_id_test)
+raw_activity_type_str <- character(length(raw_activity_type))
+for (i in 1:length(raw_activity_factornames)) {
+ raw_activity_type_str[raw_activity_type==i] <- levels(raw_activity_factornames)[i]
+}
+raw_activity_type <- factor(
+ raw_activity_type_str,
+ levels=levels(raw_activity_factornames) )
+#raw_activity_type_fc <- factor(
+# raw_activity_type_str,
+# levels=levels(raw_activity_factornames) )
+#for (i in 1:length(raw_activity_factornames)) {
+# print( sum( raw_activity_type == i ) )
+# print( sum( raw_activity_type_fc == levels(raw_activity_factornames)[i] ) )
+#}
+rm( list = c("raw_feature_df_train","raw_feature_df_test",
+ "raw_activity_type_train","raw_activity_type_test",
+ "raw_subject_id_train","raw_subject_id_test"),
+ "i", "raw_activity_type_str")
+# Step 3. Select correct columns from raw_feature_df
+feature_names <- colnames(raw_feature_df)
+idx <- sapply(feature_names,
+ function(x) {
+ grepl("mean",x) | grepl("std",x)
+ },
+ USE.NAMES=FALSE )
+raw_feature_df <- raw_feature_df[,idx]
+rm( list = c("feature_names","idx"))
+# Step 4. Create the data frame for DataSet1
+dataset1_df <- data.frame(
+ subject=raw_subject_id,
+ activity=raw_activity_type,
+ raw_feature_df)
+colnames(dataset1_df) <- c( "subject", "activity", colnames(raw_feature_df))
+rm( list = c("raw_subject_id","raw_activity_type","raw_feature_df"))
+# Step 5. Save the DataSet1 data frame to a csv file with txt extension
+write.csv(
+ dataset1_df,
+ file="dataset1.txt",
+ row.names = FALSE )
+# Step 6. Example code to read DataSet1 properly (with proper data types)
+dataset1_df_read <- read.csv(
+ file="dataset1.txt",
+ header=TRUE,
+ check.names=FALSE,
+ stringsAsFactors=FALSE)
+dataset1_df_read[["activity"]] <- factor(
+ dataset1_df_read[["activity"]],
+ levels=c("WALKING",
+ "WALKING_UPSTAIRS",
+ "WALKING_DOWNSTAIRS",
+ "SITTING",
+ "STANDING",
+ "LAYING") )
+rm( list = c("dataset1_df","dataset1_df_read","raw_activity_factornames"))
+
+# ------------------------------------------------------
+# Part 2: Creation of data set 2 (CP1 requirement 5)
+# ------------------------------------------------------
+
+# Step 1. Properly read DataSet1 from file
+dataset1_df <- read.csv(
+ file="dataset1.txt",
+ header=TRUE,
+ check.names=FALSE,
+ stringsAsFactors=FALSE)
+dataset1_df[["activity"]] <- factor(
+ dataset1_df[["activity"]],
+ levels=c("WALKING",
+ "WALKING_UPSTAIRS",
+ "WALKING_DOWNSTAIRS",
+ "SITTING",
+ "STANDING",
+ "LAYING") )
+# Step 2. Process DataSet1 to fill the DataSet2 data frame
+# (perform averages for each subject and activity)
+idx_mean_features <- grepl("mean", colnames(dataset1_df))
+unique_subjects <- as.numeric( rownames( table(dataset1_df[["subject"]]) ) )
+unique_activities <- levels(dataset1_df[["activity"]])
+
+dataset2_df <- data.frame(
+ subject =integer (length(unique_subjects)*length(unique_activities)),
+ activity=character(length(unique_subjects)*length(unique_activities)),
+ matrix(
+ data=numeric(sum(idx_mean_features) *
+ length(unique_subjects)*
+ length(unique_activities)),
+ ncol=sum(idx_mean_features),
+ nrow=length(unique_subjects)*length(unique_activities) ),
+ stringsAsFactors=FALSE
+ )
+colnames(dataset2_df) <- c("subject",
+ "activity",
+ colnames(dataset1_df)[idx_mean_features])
+
+count <- 1
+for (subject in unique_subjects) {
+ for (activity in unique_activities) {
+ idx_subject <- ( dataset1_df[["subject"]] == subject )
+ idx_activity <- ( dataset1_df[["activity"]] == activity )
+ subset_df <- dataset1_df[ idx_subject & idx_activity,
+ idx_mean_features ]
+ dataset2_df[count,"subject"] <- subject
+ dataset2_df[count,"activity"] <- activity
+ dataset2_df[count,3:ncol(dataset2_df)] <- sapply( subset_df, mean)
+ count <- count + 1
+ }
+}
+dataset2_df[["activity"]] <- factor(
+ dataset2_df[["activity"]],
+ levels=c("WALKING",
+ "WALKING_UPSTAIRS",
+ "WALKING_DOWNSTAIRS",
+ "SITTING",
+ "STANDING",
+ "LAYING") )
+rm( list = c("activity", "count","idx_activity","idx_mean_features",
+ "idx_subject","subject","subset_df","unique_activities",
+ "unique_subjects") )
+# Step 3. Save the DataSet2 data frame to a csv file with txt extension
+write.csv(
+ dataset2_df,
+ file="dataset2.txt",
+ row.names = FALSE )
+# Step 4. Example code to read DataSet2 properly (with proper data types)
+dataset2_df_read <- read.csv(
+ file="dataset2.txt",
+ header=TRUE,
+ check.names=FALSE,
+ stringsAsFactors=FALSE)
+dataset2_df_read[["activity"]] <- factor(
+ dataset2_df_read[["activity"]],
+ levels=c("WALKING",
+ "WALKING_UPSTAIRS",
+ "WALKING_DOWNSTAIRS",
+ "SITTING",
+ "STANDING",
+ "LAYING") )
+rm( list = c("dataset1_df","dataset2_df","dataset2_df_read") )
