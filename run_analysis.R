open_and_merge <- function(file_ls,test,train){
    dataset <- read.table(unz('Dataset.zip',file_ls[test]))
    dataset <- rbind(dataset,read.table(unz('Dataset.zip',file_ls[train])))
    dataset
}

library(dplyr)
library(plyr)
library(reshape2)

if(!file.exists('Dataset.zip')){
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','Dataset.zip')
}
file_ls <- as.character(unzip('Dataset.zip', list=TRUE)$Name)
if(!exists('x')){x <- open_and_merge(file_ls,17,31)}
colnames(x) <- read.table(unz('Dataset.zip',file_ls[2]))$V2
x <- x[grep('mean[^Freq]|std',names(x))]

y <- open_and_merge(file_ls,18,32)
colnames(y) <- c('Activity')

subjects <- open_and_merge(file_ls,16,30)
colnames(subjects) <- c('Subject')

dataset <- cbind(subjects,y,x)
dataset$Activity <- mapply(function(x){c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                                          "SITTING", "STANDING","LAYING")[x]},dataset$Activity)
dataset$Entry <- 1:dim(dataset)[1]
keys = dataset[,c('Entry','Subject','Activity')]
col_names <- names(dataset)
entry_type <- ifelse(substr(col_names,1,1)=='t','Time','Frequency')
statistic <- ifelse(grepl('mean()',col_names),'Mean','Std')
Feature = mapply(function(x){substring(unlist(strsplit(x,'-'))[1],2)},col_names)
Vector = character(dim(dataset)[2])
Vector[grep("-X",col_names)]="X"
Vector[grep("-Y",col_names)]="Y"
Vector[grep("-Z",col_names)]="Z"
Vector[Vector=='']='None'
i=3
new_rows <- cbind(dataset$Entry,entry_type[i],statistic[i],Feature[i],Vector[i],dataset[,i])
tidy<-new_rows
for(i in 4:dim(dataset)[2]){
    new_rows <- cbind(dataset$Entry,entry_type[i],statistic[i],Feature[i],Vector[i],dataset[,i])
    tidy<- rbind(tidy,new_rows)    
}
colnames(tidy) <- c("Entry",'Entry_Type','Statistic','Feature','Vector','Value')
tidy <- as.data.frame(tidy)
tidy$Value <-as.numeric(as.character(tidy$Value))

tidy2 <- ddply(merge(keys,tidy), .(Subject, Activity, Entry_Type, Statistic, Feature, Vector), summarize, mean = mean(Value))
tidy2 <- tidy2[complete.cases(tidy2),]

rm(x,y,i,subjects,file_ls,col_names,entry_type,Feature,dataset,new_rows,statistic)
rm(Vector)
write.table(tidy2, file = 'Tidy.txt', row.names = F)
sessionInfo()
