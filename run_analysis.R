# Loading the Activity & Features in form of Tables
features <- read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))


# Preparing Test Dataset
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = c("subject"))
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")


# Preparing Train Dataset
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# Merging the Datasets of X, Y & Subjects for Test & Train Datasets
X <-rbind(x_test,x_train)
Y <-rbind(y_test,y_train)
Subject <-rbind(subject_test,subject_train)


# Merging the above there Datasets 
Merge_Data <-cbind(Subject,Y,X)


# Extracting the Mean & Std. data fields (drop the fields where "mean" & "std" are no tfound)
TidyData <- Merge_Data %>% select(subject, code, contains("mean"), contains("std"))
TidyData$code <- activity[TidyData$code, 2]


# Renaming columns
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


# Agregating the data by mean 
FinalData <- TidyData %>%group_by(subject, activity) %>%summarise_all(funs(mean))


# Writing the data to a text file 
write.table(FinalData, "FinalData.txt", row.name=FALSE)













