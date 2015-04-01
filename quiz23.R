#Quizzes 2 and 3
library(stringi)
library(tm)
library(RWeka)

# read in the whole complete combined dataset
# rm(englishData) rm(list=ls())
englishSave<-"./data/englishText.RData"
load(englishSave)


#from original data create a corpus based on most important word in question

wordCorpus<-function (word){
  wordSubset <- englishData[grepl(word,englishData)]
  wordVS <- VectorSource(wordSubset)
  resultCorpus <- Corpus(wordVS)
  return(resultCorpus)
}

#token function
triToken <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3)) 

#tri-gram tokenizer
triTDM<-function(myCorpus){
  resultTDM<-TermDocumentMatrix(myCorpus, control = list(removePunctuation = TRUE,removeNumbers = TRUE, removeWhitespace = TRUE, stopwords=TRUE, tokenizer = triToken))
} 

#Q1
#make a corpus based on phrase 
phrase<-'case of'
qCorpus<-wordCorpus(phrase)
qTDM <- triTDM(qCorpus)
#get logical vector of trigrams with case of
select <- qTDM$dimnames$Terms[grepl(phrase,qTDM$dimnames$Terms)]
# get rows that match phrase
mTDM = as.matrix(qTDM[select,])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["case of cheese"]
sumTDM["case of pretzels"]
sumTDM["case of soda"]
sumTDM["case of beer"]
#beer 28

#Q2
#make a corpus based on phrase 
phrase1<-'mean the'
phrase2<-'mean the'
qCorpus<-wordCorpus(phrase1)
qTDM <- triTDM(qCorpus)
#get logical vector of trigrams with case of
select <- qTDM$dimnames$Terms[grepl(phrase2,qTDM$dimnames$Terms)]
# get rows that match phrase
mTDM = as.matrix(qTDM[select,])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["mean the world"]
sumTDM["mean the best"]
sumTDM["mean the universe"]
sumTDM["mean the most"]


#Q3
#make  corpus based on phrase 
phrase1<-'sunshine'
phrase2<-'make me'
qCorpus<-wordCorpus(phrase1)
qTDM <- triTDM(qCorpus)
#get logical vector of trigrams with case of
select <- qTDM$dimnames$Terms[grepl(phrase2,qTDM$dimnames$Terms)]
# get rows that match phrase
mTDM = as.matrix(qTDM[select,])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["make me happiest"]
sumTDM["make me bluest"]
sumTDM["make me saddest"]
sumTDM["make me smelliest"]

#Q4
#make  corpus based on phrase 
phrase1<-'bills'
phrase2<-'struggling'
qCorpus<-wordCorpus(phrase1)
qTDM <- triTDM(qCorpus)

#No match try unigrams

qTDM<-TermDocumentMatrix(qCorpus, control = list(removePunctuation = TRUE,removeNumbers = TRUE, removeWhitespace = TRUE, stopwords=TRUE))
mTDM = as.matrix(qTDM)


#get logical vector of trigrams with case of
select <- qTDM$dimnames$Terms[grepl(phrase2,qTDM$dimnames$Terms)]
# get rows that match phrase
mTDM = as.matrix(qTDM[select,])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["defense"]
sumTDM["crowd"]
sumTDM["referees"]
sumTDM["players"]


#39,11,NA,20


#Q5
#make  corpus based on phrase 
phrase1<-'romantic'
phrase2<-'romantic'
qCorpus<-wordCorpus(phrase1)
qTDM <- triTDM(qCorpus)

#No match try unigrams
rm(qTDM)
qTDM<-TermDocumentMatrix(qCorpus, control = list(removePunctuation = TRUE,removeNumbers = TRUE, removeWhitespace = TRUE, stopwords=TRUE))
mTDM = as.matrix(qTDM)


#get logical vector of trigrams with case of
select <- qTDM$dimnames$Terms[grepl(phrase2,qTDM$dimnames$Terms)]
# get rows that match phrase
mTDM = as.matrix(qTDM[select,])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["grocery"]
sumTDM["mall"]
sumTDM["beach"]
sumTDM["movies"]

#Q10
#make  corpus based on phrase 
phrase1<-'cutest thing'
phrase2<-'cutest thing'
qCorpus<-wordCorpus(phrase1)
qTDM <- triTDM(qCorpus)

#No match try unigrams

qTDM<-TermDocumentMatrix(qCorpus, control = list(removePunctuation = TRUE,removeNumbers = TRUE, removeWhitespace = TRUE, stopwords=TRUE))
mTDM = as.matrix(qTDM)


#get logical vector of trigrams with case of
select <- qTDM$dimnames$Terms[grepl(phrase2,qTDM$dimnames$Terms)]
# get rows that match phrase
mTDM = as.matrix(qTDM[select,])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["insane"]
sumTDM["insensitive"]
sumTDM["asleep"]
sumTDM["callous"]
