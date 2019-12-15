#Load necessary libraries
library(bitops)
library(RCurl)
library(dplyr)

#Set a local directory as current working directory
#Download and unzip the dataset into it
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,"Dataset.zip")
unzip("Dataset.zip")

#Read all the tables (dataset, labels,subject identifier)
#from both train and test directory into dataframe in R
train_x <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
test_x <- read.table(file = "UCI HAR Dataset/test/X_test.txt")

train_y <- read.table(file = "UCI HAR Dataset/train/Y_train.txt")
test_y <- read.table(file = "UCI HAR Dataset/test/Y_test.txt")

train_sub <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt")
test_sub <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt")

#combine train and test data (x)
#Do the same for activity label file (y) and subject identifier file (sub)
x <- rbind(train_x, test_x)
y <- rbind(train_y, test_y)
sub <- rbind(train_sub, test_sub)

#Combine dataset, activity labels, and subject identifier files one data frame
df1 <- cbind(y, x)
df2 <- cbind(sub, df1)
rm(train_x, train_y, train_sub, test_x, test_y, test_sub, x, y, sub, df1, fileUrl)

#Use information in features.txt to name columns of new dataframe "df2"
feature <- read.table("UCI HAR Dataset/features.txt")
features <- feature$V2
names(df2) <- c("subjectID", "activityname", as.character(features))

#Use regular expression to extract features regarding mean and standard devation
#Then subset data only with these features
mean_std <- features[grep("-mean\\(\\)|-std\\(\\)", features)]
selCol <- c("subjectID", "activityname", as.character(mean_std))
df3 <- subset(df2, select = selCol)
rm(mean_std, selCol)

#Translate the numbers in activityname column of df3 into
#actual activity name using information from activity_labels.txt
label <- read.table("./UCI HAR Dataset/activity_labels.txt")
label$V2 <- as.character(label$V2)
df3$activityname = label[df3$activityname, 2]
rm(label, features)

#Substitute coloumn names in df3 to descriptive names by the gsub command
names(df3) <- gsub("^t", "Time", names(df3))
names(df3) <- gsub("^f", "Frequency", names(df3))
names(df3) <- gsub("Acc", "Accelerometer", names(df3))
names(df3) <- gsub("Gyro", "Gyroscope", names(df3))
names(df3) <- gsub("Mag", "Magnitude", names(df3))
names(df3) <- gsub("BodyBody", "Magnitude", names(df3))
names(df3) <- gsub("\\(\\)", "", names(df3))

#We then write the data set into "merged_data.txt"
write.table(df3, "merged_data.txt")

#Group df3 by subject ID and Activity Name
#Calculate the mean for each group
#Write the results into "tidy_data.txt"
grp <- group_by(df3, subjectID, activityname)
avg <- summarise_each(grp, funs(mean))

rm(grp)

write.table(avg, "tidy_data.txt", row.names = FALSE)