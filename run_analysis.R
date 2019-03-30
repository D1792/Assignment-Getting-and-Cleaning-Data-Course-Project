#1 Merges the training and the test sets to create one data set.

## load the train and test datasets
train = read.table("UCI HAR Dataset/train/x_train.txt")
test = read.table("UCI HAR Dataset/test/x_test.txt")

## merge the train and test datasets
data= rbind(train,test)


#2 Extracts only the measurements on the mean and standard deviation for each measurement.

## load the features datasets
features = read.table("UCI HAR Dataset/features.txt")

## extract the masurements on the mean and standard deviation
data = data[ ,grepl( "(mean()|std())" , features$V2)] 



#3 Uses descriptive activity names to name the activities in the data set

## load the activity labels dataset
activitylabel =  read.table("UCI HAR Dataset/activity_labels.txt")
## give names to the activity ID and type variables
names(activitylabel) = c("activityID", "activity_type")

## load the train and test lables datasets 
trainlabel = read.table("UCI HAR Dataset/train/y_train.txt")
testlabel =  read.table("UCI HAR Dataset/test/y_test.txt")

## merge the train and test lables datasets
activityID = rbind(trainlabel,testlabel)

## merge the dataset and the activityID
data = cbind(activityID, data)

## give a name to the activity ID variable
names(data)[1] = "activityID"

## uses descriptive activity names to name the activity lalbes in the dataset by matching on activityID
data = merge(x = activitylabel, y = data, by.x = "activityID", by.y = "activityID")

## delete the activityID variable
data =data[,-1]


#4 Appropriately labels the data set with descriptive variable names.

## give variable names (for the other variables than activity_type)
variable_names = as.character(features[grepl( "(mean()|std())" , features$V2),2])
names(data)[-1] = variable_names

## load the subject datasets for train and test
trainsubject = read.table("UCI HAR Dataset/train/subject_train.txt")
testsubject = read.table("UCI HAR Dataset/test/subject_test.txt")
## merge the subject datasets
subject = rbind(trainsubject,testsubject)
## give a name to the subject variable
names(subject) = "subjectID"

## add the subject variable to the dataset
data = cbind(subject, data)




#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## obtain the average of each variable for each activity and each subject
tidydataset = aggregate(. ~subjectID + activity_type, data, mean)

## create a file for the new dataset 
write.table(tidydataset, "tidydataset.txt")