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

# create corpus from directory folder sampleData
txt<-"./sampleData"
(myCorpus <- Corpus(DirSource(txt),readerControl = list(reader=readPlain, language = "en",load = TRUE)))


#summary(myCorpus)
#inspect(myCorpus)
#myCorpus[[3]]


#Remove standard english stop words from a text document.
#tm_map(myCorpus, removeWords, stopwords("english"))

#Remove profanity
mystopwords <- c("fuck", "piss", "shit", "cunt", "cocksucker", "motherfucker", "tits")
tm_map(myCorpus, removeWords, mystopwords)

##Remove punctuation from a text document.
#tm_map(myCorpus, FUN = "removePunctuation")

#Remove numbers from a text document.
tm_map(myCorpus, FUN = "removeNumbers")

#Strip extra whitespace from a text document. Multiple whitespace characters are collapsed to a single blank
tm_map(myCorpus, FUN = "stripWhitespace")

#Stem words in a text document using Porter's stemming algorithm.
#tm_map(myCorpus, stemDocument)

# term document matrix
myCorpusTDM <- TermDocumentMatrix(myCorpus, control = list(removeNumbers = TRUE, stopwords = mystopwords))
inspect(myCorpusTDM)
str(myCorpusTDM)

findFreqTerms(myCorpusTDM, 100)

findAssocs(myCorpusTDM, "a case of", .67)

sum(grepl("of", myCorpusTDM))

findAssocs(myCorpusTDM, "weather", .99)


myCorpusTDMsparse<-removeSparseTerms(myCorpusTDM, 0.4)
inspect(myCorpusTDMsparse)