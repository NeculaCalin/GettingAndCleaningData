
setwd("/home/Calin/Desktop/coursera/gettingAndCleaningProject/")
library(dplyr)
# 1.Merge the training and the test sets to create one data set.
#read the training data
        xTrain <- read.table("train/X_train.txt")
        yTrain <- read.table("train/y_train.txt")
        sTrain <- read.table("train/subject_train.txt")

#read the testing data
        xTest <- read.table("test/X_test.txt")
        yTest <- read.table("test/y_test.txt")
        sTest <- read.table("test/subject_test.txt")

# merge the data
        X <- bind_rows(xTrain, xTest)
        Y <- bind_rows(yTrain, yTest)
        S <- bind_rows(sTrain, sTest)

#2. Extract only the measurements on the mean and standard deviation for each measurement
# 'features.txt': List of all features.
# read the feature headers
        feat <- read.table("features.txt")

# extract index for mean and std using filter and grepl
        filt<-filter(feat, grepl('mean|std',V2))

# apply index
        X<-X[,filt$V1]

# 3. Use descriptive activity names to name the activities in the data set
#read the activities labels       
        activities <- read.table("activity_labels.txt")
#apply the labels to the activities
        Y$V1<-activities[Y$V1,2]
        
# 4. Appropriately labels the data set with descriptive variable names. 
#rename the features
        names(X) <- filt$V2
#rename the activity
        names(Y)<-"activity"
#rename the subject
        names(S) <- "subject"

#5. Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
        data<-cbind(S,Y,X)
        data<-tbl_df(data)
        
tidyData<-data %>%
        group_by(subject,activity) %>%
        summarise_each(funs(mean))
write.table(tidyData, "tidyData.txt",row.name=FALSE)