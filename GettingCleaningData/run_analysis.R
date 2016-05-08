# Script performs the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

library(dplyr)
library(tidyr)
library(readr)
library(stringr)

# Activity Labels
##################################

# Read data / Rename columns
activity_labels <- read_delim("./UCI_HAR_Dataset/activity_labels.txt", 
                              col_names = FALSE,
                              delim=" ")
activity_labels <- rename(activity_labels, activity.id = X1, activity.name = X2)


# Feature Labels
##################################

# Read data / Rename columns
features.all <- read_delim("./UCI_HAR_Dataset/features.txt", 
                           col_names = FALSE, 
                           delim=" ")
features.all <- rename(features.all, feature.id = X1, feature.desc = X2)

# Extract feature names. Used for x_train and x_test column names
features.all.vect <- as.vector(unlist(features.all[,2])) 
# Remove any parenthisis and replace "-" with "."
features.all.vect <- str_replace_all(features.all.vect, "\\(", "")
features.all.vect <- str_replace_all(features.all.vect, "\\)", "")
features.all.vect <- str_replace_all(features.all.vect, "-", ".")

# Find values with only mean() or std(). Used to subset x_train and x_test.
mean_std <- grep(".*(mean|std)\\(\\).*", features.all$feature.desc)
# Get list of features. Used for verification.
features.mean_std <- features.all[mean_std,]


# Training Data 
##################################

# Read data / rename columns
subject_train <- read_delim("./UCI_HAR_Dataset/train/subject_train.txt", 
                              col_names = FALSE,
                              delim=" ")
subject_train <- rename(subject_train, subject.id = X1)

y_train <- read_table("./UCI_HAR_Dataset/train/y_train.txt", 
                      col_names = FALSE)
y_train <- rename(y_train, activity.id = X1)

x_train <- read_table("./UCI_HAR_Dataset/train/X_train.txt", 
                      col_names = FALSE)
colnames(x_train) <- features.all.vect

# Subset the x_train data for only mean() and std() features
x_train_mean_std <- x_train[,mean_std]

# Change Y values from numbers to categories using activity labels
y_train_merge <- merge(y_train, activity_labels)
y_train_desc <- y_train_merge[,2]

# Combine training data / Rename activity column
train_data <- cbind(subject_train, x_train_mean_std, y_train_desc)
train_data <- rename(train_data, activity = y_train_desc)


# Test Data 
##################################

# Read data / rename columns 
subject_test <- read_delim("./UCI_HAR_Dataset/test/subject_test.txt", 
                            col_names = FALSE,
                            delim=" ")
subject_test <- rename(subject_test, subject.id = X1)

y_test <- read_table("./UCI_HAR_Dataset/test/y_test.txt", 
                      col_names = FALSE)
y_test <- rename(y_test, activity.id = X1)

x_test <- read_table("./UCI_HAR_Dataset/test/X_test.txt", 
                      col_names = FALSE)
colnames(x_test) <- features.all.vect

# Subset the x_test data for only mean() and std() features
x_test_mean_std <- x_test[,mean_std]

# Change Y values from numbers to categories using activity labels
y_test_merge <- merge(y_test, activity_labels)
y_test_desc <- y_test_merge[,2]

# Combine test data / Rename Y column activity
test_data <- cbind(subject_test, x_test_mean_std, y_test_desc)
test_data <- rename(test_data, activity = y_test_desc)


# Merge test and training datasets
##################################

all_data <- rbind(train_data, test_data)

# Return tidy data set with the average of each variable summarized by 
# each activity and each subject
##################################

tidy_data <- all_data %>%
        group_by(activity, subject.id) %>%
        summarize_each(funs(mean)) %>%
        arrange(activity, subject.id)

write.table(tidy_data, "average_by_activity_subject.txt", row.names = FALSE)
