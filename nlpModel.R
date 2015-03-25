#NLP Model

library(tm)
library(RWeka)
library(SnowballC)
library(ggplot2)

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

findAssocs(myCorpusTDM, "a case of", .67)

sum(grepl("of", myCorpusTDM))

findAssocs(myCorpusTDM, "weather", .99)


myCorpusTDMsparse<-removeSparseTerms(myCorpusTDM, 0.4)
inspect(myCorpusTDMsparse)


## tokenizers

#set up tokenizer functions from Rweka
uniToken <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1)) 
biToken <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2)) 
triToken <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3)) 
quadToken <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4)) 

# tokenize 
uniTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = uniToken))
biTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = biToken))
triTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = triToken))
quadTDM<- TermDocumentMatrix(myCorpus, control = list(removeWhitespace = TRUE, removePunctuation = TRUE,removeNumbers = TRUE, stopwords = mystopwords, tokenizer = quadToken))

findFreqTerms(uniTDM, 1000)
findFreqTerms(biTDM, 500)
findFreqTerms(triTDM, 100)
findFreqTerms(quadTDM, 50)

# aggregate columns 
uniAggregate<-colSums(as.matrix(uniTDM))
biAggregate<-colSums(as.matrix(biTDM))
triAggregate<-colSums(as.matrix(triTDM))
quadAggregate<-colSums(as.matrix(quadTDM))
totes<-(uniAggregate+ biAggregate +triAggregate+quadAggregate)

#Build table
ngramMat<-cbind(uniAggregate, biAggregate,triAggregate,quadAggregate)
# totals row
ngramMat<-rbind(ngramMat,colSums(ngramMat),deparse.level = 2)
# add names
mynames = list(c("Blogs", "News", "Twitter", "Totals"), c("Words","2-Gram","3-Gram","4-Gram"))
dimnames(ngramMat)<-mynames
(ngramMat)

# inspect

inspect(quadTDM[1:100, 1:3])
inspect(triTDM[130:200, 1:3])
inspect(biTDM[130:200, 1:3])
inspect(uniTDM[1:20, 1:3])
df <- as.data.frame(inspect(quadTDM))

# aggregate rows 
uniRowAggregate<-rowSums(as.matrix(uniTDM))
biAggregate<-rowSums(as.matrix(biTDM))
triAggregate<-rowSums(as.matrix(triTDM))
quadAggregate<-rowSums(as.matrix(quadTDM))

names(triAggregate)

uniLevels <- unique(uniTDM$dimnames$Terms)
length(uniLevels)


#compute  dissimilarity 
install.packages('proxy')
library('proxy')
uniDis=dissimilarity(uniTDM, method="cosine")
uniDis<-pr_dist2simil(uniTDM)
#the dissimilarity is between documents
#visualize the dissimilarity results to matrix, here we are just printing part of the big matrix
as.matrix(dis)[1:10, 1:10]
#visualize the dissimilarity results as a heatmap
heatmap(as.matrix(dis)[1:50, 1:50])



# calculate term frequencies 
uniTDMfreq <- apply(uniTDM, 1, sum) 
uniTDMfreq20 <- sort(uniTDMfreq, decreasing=TRUE)[1:20]
qplot(names(uniTDMfreq20),uniTDMfreq20, geom='bar', main=" Term Frequencies", xlab="Terms",ylab= "counts" ,stat="identity") + coord_flip()

# get the matching tweets for the most frequent word 
inspect(tweetsCorpus[apply(tweetsTDM[names(tweetsFrequentWords[1])], 1, function(x) x > 0)]) 

install.packages('slam')
library('slam')

uniTDMfreq <- rowapply_simple_triplet_matrix(uniTDM,sum)
