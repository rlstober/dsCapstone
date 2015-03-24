#Explore Data
#Has the data scientist done basic summaries of the three files? Word counts, line counts and basic data tables?
#Has the data scientist made basic plots, such as histograms to illustrate features of the data?
library(stringi)
library(ggplot2)


## Download process

# File names
destFile <- "./data/Coursera-SwiftKey.zip"
sourceFile <- "http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

# download
download.file(sourceFile, destFile)

# extract 
unzip(destFile)

##Read  process

# Use function to avoid copying code and ensure all data is treated the same.
#Read in binary mode for news feel
#skipNul needed for twitter
# set UTF-8 encoding

readFiles<- function(x,openMode){
  con <- file(x,  open=openMode)
  df<-readLines(con, encoding="UTF-8", skipNul=TRUE)
  close(con)
  return(df)
}

#File names
blogFile<-"./final/en_us/en_US.blogs.txt"
twitterFile<-"./final/en_us/en_US.twitter.txt"
newsFile<-"./final/en_us/en_US.news.txt"

openMode<- "rt"
blogData<-readFiles(blogFile,openMode)
twitterData<-readFiles(twitterFile,openMode)
openMode<- "rb"
newsData<-readFiles(newsFile,openMode)

## Get descriptive data

# file sizes
fileMB<-function(x){round(file.info(x)$size/1024^2,0)}
blogFileSize<-fileMB(blogFile)
twitterFileSize<-fileMB(twitterFile)
newsFileSize<-fileMB(newsFile)

# number of lines
blogDataLength<-length(blogData)
twitterDataLength<-length(twitterData)
newsDataLength<-length(newsData)

# average number of character per line
blogDataMean<-round(mean(nchar(blogData)))
twitterDataMean<-round(mean(nchar(twitterData)))
newsDataMean<-round(mean(nchar(newsData)))

#Create table with this info
fileSources<-c("blog", "twitter", "news")
fileSizeMb<-c(blogFileSize, twitterFileSize, newsFileSize)
fileLines<-c(blogDataLength, twitterDataLength, newsDataLength)
fileMCL<-c(blogDataMean, twitterDataMean, newsDataMean)
fileDFnames<-c("Data Source","File Size (Mb)", "Number of Lines", "Characters per Line")

fileDF<-data.frame(fileSources,fileSizeMb,fileLines,fileMCL)
names(fileDF)<-fileDFnames


## word stats

blogDataStats<-as.matrix(stri_stats_latex(blogData))
twitterDataStats<-as.matrix(stri_stats_latex(twitterData))
newsDataStats<-as.matrix(stri_stats_latex(newsData))

statsDF<-as.data.frame(cbind(blogDataStats, twitterDataStats,newsDataStats))
names(statsDF)<-fileSources
#(statsDF)


##Count words
blogWords <- stri_count_words(blogData)
blogWordsM <- as.matrix(summary(blogWords))

twitterWords <- stri_count_words(twitterData)
twitterWordsM <- as.matrix(summary(twitterWords))
                        
newsWords <- stri_count_words(newsData)
newsWordsM <- as.matrix(summary(newsWords))

#Build table
wordsDF<-as.data.frame(cbind(blogWordsM, twitterWordsM,newsWordsM))
names(wordsDF)<-fileSources
#(wordsDF)


## Save all this work

saveFiles <- function(x,y){save(x, file = y)}

#File names
blogSave<-"./data/blogs.RData"
twitterSave<-"./data/twitter.RData"
newsSave<-"./data/news.RData"
savefileDF<-"./data/fileDF.RData"
savestatsDF<-"./data/statsDF.RData"
savewordsDF<-"./data/wordsDF.RData"


saveFiles(blogData,blogSave)
saveFiles(twitterData,twitterSave)
saveFiles(newsData,newsSave)
saveFiles(fileDF,savefileDF)
saveFiles(statsDF,savestatsDF)
saveFiles(wordsDF,savewordsDF)



#plot

qplot(blogWords, xlab="Words per Line", ylab="Frequency of Count", main="Blog Word Frequency",xlim=c(0,200), binwidth=1)
ggsave(filename="./data/blogWords.png", width = 4, height=4, dpi=100)

qplot(twitterWords, xlab="Words per Line", ylab="Frequency of Count", main="Twitter Word Frequency",xlim=c(0,200), binwidth=1)
ggsave(filename="./data/twitterWords.png", width = 4, height=4, dpi=100)

qplot(newsWords, xlab="Words per Line", ylab="Frequency of Count", title="News Word frequency",xlim=c(0,200), binwidth=1)
ggsave(filename="./data/newsWords.png", width = 4, height=4, dpi=100)


##Sampling

saveFileSample <- function(x,y,n){z<-sample(x,n);save(z, file = y)}
# Sample File names
blogSave<-"./data/blogsSamp.RData"
twitterSave<-"./data/twitterSamp.RData"
newsSave<-"./data/newsSamp.RData"

#
set.seed<-12345
sampSize<-10000
saveFileSample(blogData,blogSave,sampSize)
saveFileSample(twitterData,twitterSave,sampSize)
saveFileSample(newsData,newsSave,sampSize)

