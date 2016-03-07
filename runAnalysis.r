
rm(list=ls())

# 1. Merges the training and the test sets to create one data set.

#Setting working directory
setwd('/Users/HP/Documents/UCI HAR Dataset');

# Reading files features, activity labels

features     = read.table('./features.txt',header=FALSE); 
activitylabel = read.table('./activity_labels.txt',header=FALSE);

#Reading files train set

subjecttrain = read.table('./train/subject_train.txt',header=FALSE);
xtrain       = read.table('./train/x_train.txt',header=FALSE); 
ytrain       = read.table('./train/y_train.txt',header=FALSE); 

# Assiging column names to the dataframes

colnames(activitylabel)  = c('activityId','activity');
colnames(subjecttrain)  = "subjectId";
colnames(xtrain)        = features[,2]; 
colnames(ytrain)        = "activityId";

# creating the training set dataframe
trainingSet = cbind(ytrain,subjecttrain,xtrain);

#Reading files test set

subjecttest = read.table('./test/subject_test.txt',header=FALSE); 
xTest       = read.table('./test/x_test.txt',header=FALSE); 
yTest       = read.table('./test/y_test.txt',header=FALSE); 

# Assiging column names to the dataframes

colnames(subjecttest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";


# creating the test set dataframe
testSet = cbind(yTest,subjecttest,xTest);


# Combining the latter two dataframes

Total = rbind(trainingSet,testSet);

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

columns  = colnames(Total);


# Subset Total table where mean and std occur, we keep the activity and subject columns for reference
Total = Total[(grepl("activity..",columns) | grepl("subject..",columns) | grepl("-mean..",columns) & !grepl("-meanFreq..",columns) & !grepl("mean..-",columns) | grepl("-std..",columns) & !grepl("-std()..-",columns))];

# 3. Uses descriptive activity names to name the activities in the data set

# Merge the Total set with the acitivityType table to include descriptive activity names
Total = merge(Total,activitylabel,by='activityId',all.x=TRUE);

# Updating the columns vector
columns  = colnames(Total); 

# 4. Appropriately labels the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(columns)) 
{
  columns[i] = gsub("\\()","",columns[i])
  columns[i] = gsub("-std$","StdDev",columns[i])
  columns[i] = gsub("-mean","Mean",columns[i])
  columns[i] = gsub("^(t)","time",columns[i])
  columns[i] = gsub("^(f)","freq",columns[i])
  columns[i] = gsub("([Gg]ravity)","Gravity",columns[i])
  columns[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columns[i])
  columns[i] = gsub("[Gg]yro","Gyro",columns[i])
  columns[i] = gsub("AccMag","AccMagnitude",columns[i])
  columns[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columns[i])
  columns[i] = gsub("JerkMag","JerkMagnitude",columns[i])
  columns[i] = gsub("GyroMag","GyroMagnitude",columns[i])
};

# Updating the column names for Total
colnames(Total) = columns;

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Create a new table, finalDataNoActivityType without the activitylabel column
finalDataNoActivityType  = Total[,names(Total) != 'activitylabel'];

# Summarizing the finalDataNoActivityType dataframe with aggregate
tidy    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

# Adding the descriptive activity names
tidy    = merge(tidy,activitylabel,by='activityId',all.x=TRUE);

# Exporting 
write.table(tidy, './tidy.txt',row.names=FALSE,sep='\t');
