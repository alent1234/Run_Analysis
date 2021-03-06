library(reshape2)
library(data.table)
#Load metadata
activity_labels <- read.table("/data/week4/UCI_HAR_Dataset/activity_labels.txt", header = FALSE, sep = " ")[,2]
features <- read.table("/data/week4/UCI_HAR_Dataset/features.txt", header = FALSE, sep = " ")[,2]

#extract columns for the mean and standard deviation
mean_sd <- grep(".*mean.*|.*std.*", features[,2])
mean_sd_names <- features[mean_sd,2]
mean_sd_names = gsub('-mean', 'Mean', mean_sd_names)
mean_sd_names = gsub('-std', 'Std', mean_sd_names)
mean_sd_names <- gsub('[-()]', '', mean_sd_names)

#load data
test_x <- read.table("/data/week4/UCI_HAR_Dataset/test/X_test.txt")[mean_sd_names]
test_y <- read.table("/data/week4/UCI_HAR_Dataset/test/y_test.txt")

train_x <- read.table("/data/week4/UCI_HAR_Dataset/train/X_train.txt")[mean_sd_names]
train_y <- read.table("/data/week4/UCI_HAR_Dataset/train/y_train.txt")

test_subject <- read.table("/data/week4/UCI_HAR_Dataset/test/subject_test.txt")
train_subject <- read.table("/data/week4/UCI_HAR_Dataset/train/subject_train.txt")

#test_x <- test_x[,mean_sd_names]
#train_x <- train_x[,mean_sd_names]

#correlate data to column names
#names(train_x) = mean_sd_names
#names(test_x) = mean_sd_names

#test data activity labels
test_y[,2] = activity_labels[test_y[,1]]
names(test_y) = c("Activity_ID", "Activity_Label")
names(test_subject) = "subject"

#training data activity labels
train_y[,2] = activity_labels[train_y[,1]]
names(train_y) = c("Activity_ID", "Activity_Label")
names(train_subject) = "subject"

#bind the data
test_data <- cbind(as.data.table(test_subject), test_y, test_x)
train_data <- cbind(as.data.table(train_subject), train_y, train_x)

#test_data <- merge(test_y, test_x, all=true)
#train_data <- merge(train_y, train_x,all=true)

#datalist <- list(train_x, train_y, test_x, test_y) 
#all_data2 <- join_all(datalist)

#merge the data
all_data = rbind(test_data, train_data)
colnames(allData) <- c("subject", "activity", mean_sd_names)
#all_data = merge(test_data, train_data, all=TRUE)

#labels   = c("subject", "Activity_ID", "Activity_Label")
#data_labels = setdiff(colnames(all_data), labels)

#run melt function
datamelt <- melt(all_data, id=c("subject", "Activity_ID", "Activity_Label"))#, measure.vars = data_labels )

#run cast function 
datacast <- dcast(datamelt, subject + Activity_Label ~ variable, mean)


write.table(datacast, file = "/data/tidy_data.txt", row.names = FALSE, quote = FALSE)

