# Getting-and-Cleaning-Data-Project
RunAnalysis contains the code used to process the UCI HAR DataSet
Starts cleaning the workspace

1
Procced reading files from the training set, assigning the variables:
features
activitylabel
subjecttrain
xtrain
ytrain
Procced reading files from the test set, assigning the variables:
subjecttest
xTest
yTest
Then it creates a data frame for the test set and the training set, for merge them later in "Total"

2
For extracting the means and standard deviations we use grepl() for matching the columns with these statistics

3
Add the ActivityId from "activitylabel" to Total

4
Uses a for loop and gsub() to match expressions and replace them with more descriptive column names in Total

5
We use aggregate to summarize the Total Dataframe
