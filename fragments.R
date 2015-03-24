####fragments

## laod data
# save original in Rdata format for later use
saveFiles <- function(x,y){save(x, file = y)}

#File names
blogSave<-"./data/blogs.RData"
twitterSave<-"./data/twitter.RData"
newsSave<-"./data/news.RData"

saveFiles(blogData,blogSave)
saveFiles(twitterData,twitterSave)
saveFiles(newsData,newsSave)


#Save samples
writeFileSample <- function(x,y,n){z<-sample(x,n);write(z, file = y)}
writeFileSample <- function(x,y,n,openMode){
  z<-sample(x,n)
  con <- file(y,  open=openMode)
  write(z, con)
  close(con)}



# Sample File names
blogSamp<-"./sampleData/blogsSamp.txt"
twitterSamp<-"./sampleData/twitterSamp.txt"
newsSamp<-"./sampleData/newsSamp.txt"

#
set.seed<-12345
sampSize<-10000
openMode<- "rt"
writeFileSample(blogData,blogSamp,sampSize)
writeFileSample(twitterData,twitterSamp,sampSize)
openMode<- "rb"
writeFileSample(newsData,newsSamp,sampSize)

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



##explore
# Sample File names
blogSamp<-"./sampleData/blogsSamp.txt"
twitterSamp<-"./sampleData/twitterSamp.txt"
newsSamp<-"./sampleData/newsSamp.txt"

blogSampSize<-fileMB(blogSamp)
twitterSampSize<-fileMB(twitterSamp)
newsSampSize<-fileMB(newsSamp)

#create table of file sizes

fileSources<-c("blog", "twitter", "news")
fileSizeMb<-c(blogFileSize, twitterFileSize, newsFileSize)
sampSizeMb<-c(blogSampSize, twitterSampSize, newsSampSize)

(sizeDF<-data.frame(fileSources,fileSizeMb,sampSizeMb))


#R.utils::countLines(twitterSamp)

#samples
openMode<- "rt"
blogDataSamp<-readFiles(blogSamp)
twitterDataSamp<-readFiles(twitterSamp)
openMode<- "rb"
newsDataSamp<-readFiles(newsSamp)

blogSampLength<-length(blogDataSamp)
twitterSampLength<-length(twitterDataSamp)
newsSampLength<-length(newsDataSamp)

#create table of lengths

fileLines<-c(blogDataLength, twitterDataLength, newsDataLength)
sampleLines<-c(blogSampLength, twitterSampLength, newsSampLength)

(lengthDF<-data.frame(fileSources,fileLines,sampleLines))

names(lengthDF[2])

blogSampStats<-stri_stats_latex(blogDataSamp)
twitterSampStats<-stri_stats_latex(twitterDataSamp)
newsSampStats<-stri_stats_latex(newsDataSamp)
