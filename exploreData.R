#Explore Data
#Has the data scientist done basic summaries of the three files? Word counts, line counts and basic data tables?
#Has the data scientist made basic plots, such as histograms to illustrate features of the data?
# rm(list=ls())
gc()

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

##Clean it up for further processing
cleanText<-function(myText){
  resultText <- stri_trans_tolower(myText)
  #replace new lines with space
  #resultText <- stri_replace_all_regex(resultText,'\032','')
  #remove unicode
  #resultText <- stri_enc_toascii(resultText)
  #remove end of sentence characters
  #resultText <- stri_replace_last_regex(resultText,'[/.,/?/!]','')
  # multipl,e spaces
  #resultText<-stri_trim_both(resultText, pattern = "\\P{Wspace}")
  #remove am and pm characters
  #resultText <- stri_replace_last_regex(resultText,'a m','a.m.')
  #resultText <- stri_replace_last_regex(resultText,'p m','p.m.')
  #remove numbers
  #resultText <- stri_replace_last_regex(resultText,'[0-9]+','')
  #remove profanity
  resultText <- stri_replace_last_regex(resultText,'["fuck", "piss", "shit", "cunt", "cocksucker", "motherfucker", "tits"]','')
  ## non-utf-8 characters
  # drop non UTF-8 characters 
  resultText <- iconv(resultText, from = "latin1", to = "UTF-8", sub="") 
  resultText <- stri_replace_all_regex(resultText, "\u2019|`","'") 
  resultText <- stri_replace_all_regex(resultText, "\u201c|\u201d|u201f|``",'"') 
  return(resultText)
}


#resultText<-c("can't", "a m ", "friday13", "TTT","fuck you", "goodbye.", "hello?", "b   x")

blogData<-cleanText(blogData)
twitterData<-cleanText(twitterData)
newsData<-cleanText(newsData)

#sum(grepl("a.m.", twitterData))


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
(fileDF)


## word stats

blogDataStats<-as.matrix(stri_stats_latex(blogData))
twitterDataStats<-as.matrix(stri_stats_latex(twitterData))
newsDataStats<-as.matrix(stri_stats_latex(newsData))

statsDF<-as.data.frame(cbind(blogDataStats, twitterDataStats,newsDataStats))
names(statsDF)<-fileSources
(statsDF)


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
  (wordsDF)


## Save data tables
#File names
savefileDF<-"./data/fileDF.RData"
savestatsDF<-"./data/statsDF.RData"
savewordsDF<-"./data/wordsDF.RData"
#save
save(fileDF,file=savefileDF)
save(statsDF,file=savestatsDF)
save(wordsDF,file=savewordsDF)

#plot

bPlot<-qplot(blogWords, xlab="Words per Line", ylab="Frequency of Count", main="Blog Word Frequency",xlim=c(0,200), binwidth=1)
ggsave(filename="./data/blogWords.png", width = 4, height=4, dpi=100)

tPlot<-qplot(twitterWords, xlab="Words per Line", ylab="Frequency of Count", main="Twitter Word Frequency",xlim=c(0,200), binwidth=1)
ggsave(filename="./data/twitterWords.png", width = 4, height=4, dpi=100)

nPlot<-qplot(newsWords, xlab="Words per Line", ylab="Frequency of Count", main="News Word Frequency",xlim=c(0,200), binwidth=1)
ggsave(filename="./data/newsWords.png", width = 4, height=4, dpi=100)

grid.arrange(bPlot,tPlot,nPlot, ncol = 3)
ggsave(filename="./data/allWords.png", width = 4, height=4, dpi=100)


##Sampling

set.seed<-12345
sampSize<-1000
blogDataSample<-sample(blogData,length(blogData)*.01)
twitterDataSample<-sample(twitterData,length(twitterData)*.01)
newsDataSample<-sample(newsData,length(newsData)*.01)

## Save data tables

#File names
blogSave<-"./data/blogs.RData"
twitterSave<-"./data/twitter.RData"
newsSave<-"./data/news.RData"

# Sample File names
blogSaveSamp<-"./sampleData/blogsSamp.RData"
twitterSaveSamp<-"./sampleData/twitterSamp.RData"
newsSaveSamp<-"./sampleData/newsSamp.RData"

save(blogData,file=blogSave)
save(twitterData,file=twitterSave)
save(newsData,file=newsSave)

save(blogDataSample,file=blogSaveSamp)
save(twitterDataSample,file=twitterSaveSamp)
save(newsDataSample,file=newsSaveSamp)

# save all in one file
englishSave<-"./data/englishText.RData"
englishData<-c(blogData,twitterData, newsData)
save(englishData,file=englishSave)

englishSaveSample<-"./data/englishTextSample.RData"
save(blogDataSample,twitterDataSample, newsDataSample,file=englishSaveSample)


# Sample connections
blogCon<-file("./sampleData/blogsSamp.txt")
twitterCon<-file("./sampleData/twitterSamp.txt")
newsCon<-file("./sampleData/newsSamp.txt")


writeLines(blogDataSample, blogCon);close(blogCon)
writeLines(newsDataSample, newsCon);close(newsCon)
writeLines(twitterDataSample, twitterCon);close(twitterCon)


load(blogSaveSamp)
load(twitterSaveSamp)
load(newsSaveSamp)

load(blogSave)
load(twitterSave)
load(newsSave)