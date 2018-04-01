# Data Cleaning
For Coursera data cleaning course

In this repo you'll find a 'run_analysis.R' file that pull the data from this site 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip' to clean it up.
The shape of this data can be found in the zip file but it is important to know that the data is split between train and test data and that each row constitute a different entry from one subject with all the features data from that entry.
Given the amount of data and repeating characteristics of the features, I've created two dataframes to manipulate the data:

1. __keys__ that contains the main key for all entries 
2. __tidy__ that contains all the data or all features for all entries.
3. __tidy2__ that contains the data final data with the mean of each statistic by subject and activity

##Keys' structure
- __Entry__: *factor* - an unique id for each entry - 1:10299
- __Subject__: *factor* - the id for the subject associated with that entry - 1:30
- __Activity__: *factor * -the activity associated with that entry -(LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS)

##tidy's structure
- __Entry__: *factor* - the id of the entry (refers to _keys_)
- __Entry_Type__: *factor* - the type of entry either - (Time, Frequency)
- __Statistic__: *factor* - the type of statistic - Mean, Std
- __Feature__: *factor* - the feature for which the statistic is entered - (BodyAcc, BodyAccJerk, BodyAccJerkMag, BodyAccMag, BodyBodyAccJerkMag, BodyBodyGyroJerkMag, BodyBodyGyroMag, BodyGyroBodyGyroJerk, BodyGyroJerk, BodyGyroJerkMag, BodyGyroMag, GravityAcc, GravityAccMag)
- __Vector__: *factor* - either the vector X, Y or Z or None when the statistic is global rather than by vector
- __Value__: *numerical* - the value of the statistic

##tidy2`s structure

tidy2`s structure is the same as _tidy_ except the __Entry__ is replaced by __Subject__ 

##Dataset construction

###tidy
Mainly, I download the data if needed then I perform those steps:

1. Merge the data with all the features for both test and train sets.
2. Find and retreive only the columns containing either the mean or standard deviation for each features.
3. Merge the Activity associated with each row
4. Merge the Subject associated with each row
5. Merge the dataframes from steps 2 to 4.
6. For each feature column, based on their name:
  - Find the Entry_Type
  - Find the Statistic
  - Find the Feature`s name
  - Find the vector
  - Create a dataset with the above information and the value for each Entry
7. Merge all dataset created in step 6 to form the _tidy_ dataset
 
###tidy2

1. Merge _tidy_ with their _keys_ to associate the key to each entry
2. Summarize the data by __Subject__, __Activity__, __Entry_Type__, __Statistic__, __Feature__ and __Vector__ to calculate the mean of __Value__
3. Remove incomplete cases 