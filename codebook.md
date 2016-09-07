Codebook
========

Variable Descriptions
---------------------

> 1. subjectxy_tidy - table of mean values of measurements grouped by subject and activity
> 2. subjectxy - table of merged training and test (features, label) pairs
> 3. features - table of (measurement name, measurement label) pairs
> 4. descriptive_activity_names - table of (activity name, activity label) pairs


Data
----

> 1. subject_train - subject during training
> 2. subject_test - subject assigned based on measurements
> 3. y_train - training labels
> 4. y_test - label assigned based on measurements
> 5. x_train - measurements obtained during training
> 6. x_test - measurements used in the test set

Cleaning the Data
-----------------

> 1. Merged the subject, feature, and activity data using rbind and cbind
> 2. Filtered features to include only mean and standard deviation measurements using grepl to subset the indices of features
> 3. Used information contained in features and descriptive_activity_names to assign descriptive name information to subjectxy
> 4. Applied the melt operation from reshape2, the separate operation tidyr, and group_by and summarize from dplyr to create tidy data subjectxy_tidy
