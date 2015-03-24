#NLP Model

library(tm)
library(RWeka)
library(SnowballC)

##Load Sample Data

# Sample File names
load("./data/blogsSamp.RData")
load("./data/twitterSamp.RData")
load("./data/newsSamp.RData")


load(blogSave)
load(twitterSave)
newsLoad<-load(newsSave)

# create corpus from directory folder sampleData
txt<-"./sampleData"
(myCorpus <- Corpus(DirSource(txt),readerControl = list(reader=readPlain, language = "en",load = TRUE)))


summary(myCorpus)
inspect(myCorpus)
myCorpus[[3]]


#Remove standard english stop words from a text document.
#tm_map(myCorpus, removeWords, stopwords("english"))

#Remove profanity
mystopwords <- c("fuck", "piss", "shit", "cunt", "cocksucker", "motherfucker", "tits")
tm_map(myCorpus, removeWords, mystopwords)

##Remove punctuation from a text document.
tm_map(myCorpus, FUN = "removePunctuation")

#Remove numbers from a text document.
tm_map(myCorpus, FUN = "removeNumbers")

#Strip extra whitespace from a text document. Multiple whitespace characters are collapsed to a single blank
tm_map(myCorpus, FUN = "stripWhitespace")

#Stem words in a text document using Porter's stemming algorithm.
#tm_map(myCorpus, stemDocument)

# term document matrix
myCorpusTDM <- TermDocumentMatrix(myCorpus, control = list(removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords))
inspect(myCorpusTDM)
str(myCorpusTDM)

findFreqTerms(myCorpusTDM, 100)

findAssocs(myCorpusTDM, "weather", .99)

myCorpusTDMsparse<-removeSparseTerms(myCorpusTDM, 0.4)
inspect(myCorpusTDMsparse)


## tokenizers

#set up tokenizer functions from Rweka
uniToken <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1)) 
biToken <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2)) 
triToken <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3)) 

# tokenize 
uniTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = uniToken))
#MYuniTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords))
biTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = biToken))
triTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = triToken))

findFreqTerms(uniTDM, 1000)
findFreqTerms(biTDM, 500)
findFreqTerms(triTDM, 100)

# aggregate columns 
uniAggregate<-colSums(as.matrix(uniTDM))
#MYuniAggregate<-colSums(as.matrix(MYuniTDM))
biAggregate<-colSums(as.matrix(biTDM))
triAggregate<-colSums(as.matrix(triTDM))


#Build table
ngramDF<-as.data.frame(cbind(uniAggregate, biAggregate,triAggregate))
names(ngramDF)<-c("Words","2-Gram","3-Gram")
#(ngramDF)

names(triAggregate)

uniLevels <- unique(uniTDM$dimnames$Terms)
length(uniLevels)
