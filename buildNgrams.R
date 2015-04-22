#buildNgrams
rm(list=ls()); gc()
library(tm)
library(RWeka)
library(SnowballC)
library(ggplot2)
library(slam)

##load sample data
englishSaveSample<-"./data/englishTextSample.RData"
load(englishSaveSample)

blogCorpus<-VCorpus(DataframeSource(data.frame(blogDataSample)))
twitterCorpus<-VCorpus(DataframeSource(data.frame(twitterDataSample)))
newsCorpus<-VCorpus(DataframeSource(data.frame(newsDataSample)))

englishCorpus<-c(blogCorpus,twitterCorpus,newsCorpus)

#clear up some mem
rm(blogCorpus)
rm(newsCorpus)
rm(twitterCorpus)

rm(blogDataSample)
rm(newsDataSample)
rm(twitterDataSample)

gc()


#set up tokenizer functions from Rweka
uniToken <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1)) 
biToken <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2)) 
triToken <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3)) 
quadToken <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4)) 



## tokenize

sparsity<-.8
## 1-grams

uniTDM<- TermDocumentMatrix(englishCorpus, control = list(removeWhitespace = TRUE, tokenizer = uniToken))
#uniTDMfreq <- sort(rowapply_simple_triplet_matrix(uniTDM,sum), decreasing = TRUE)
uniTDMsparse<-removeSparseTerms(uniTDM,.99999)
uniTDMsparseFreq <- sort(rowapply_simple_triplet_matrix(uniTDMsparse,sum), decreasing = TRUE)
tail(uniTDMsparseFreq)
save(uniTDMsparseFreq, file="./data/uniTDMsparseFreq.RData")

# 2 -grams

biTDM<- TermDocumentMatrix(englishCorpus, control = list( removeWhitespace = TRUE, tokenizer = biToken))
biTDMsparse<-removeSparseTerms(biTDM,.99995)
biTDMsparseFreq <- sort(rowapply_simple_triplet_matrix(biTDMsparse,sum), decreasing = TRUE)
#tail(biTDMsparseFreq)
save(biTDMsparseFreq, file="./data/biTDMsparseFreq.RData")

# 3-grams
triTDM<- TermDocumentMatrix(englishCorpus, control = list(removeWhitespace = TRUE, tokenizer = triToken))
triTDMsparse<-removeSparseTerms(triTDM,.99997)
triTDMsparseFreq <- sort(rowapply_simple_triplet_matrix(triTDMsparse,sum), decreasing = TRUE)
tail(triTDMsparseFreq)
save(triTDMsparseFreq, file="./data/triTDMsparseFreq.RData")

#4-grams
quadTDM<- TermDocumentMatrix(englishCorpus, control = list(removeWhitespace = TRUE, tokenizer = quadToken))
quadTDMsparse<-removeSparseTerms(quadTDM,.99999)
quadTDMsparseFreq <- sort(rowapply_simple_triplet_matrix(quadTDMsparse,sum), decreasing = TRUE)
tail(quadTDMsparseFreq)
save(quadTDMsparseFreq, file="./data/quadTDMsparseFreq.RData")

