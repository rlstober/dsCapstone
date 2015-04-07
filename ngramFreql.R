#NLP Model
# rm(list=ls()); gc()
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

sparsity<-.8

# tokenize 
uniTDM<- TermDocumentMatrix(englishCorpus, control = list(removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = uniToken))
biTDM<- TermDocumentMatrix(englishCorpus, control = list(removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = biToken))
triTDM<- TermDocumentMatrix(englishCorpus, control = list(removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = triToken))
#quadTDM<- TermDocumentMatrix(englishCorpus, control = list(removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = quadToken))

# get non stop words 
uniTDMnonstop<- TermDocumentMatrix(englishCorpus, list(weighting = function(x)weightTfIdf(x, normalize =FALSE),stopwords = TRUE,removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = uniToken))
biTDMnonstop<- TermDocumentMatrix(englishCorpus, list(weighting = function(x)weightTfIdf(x, normalize =FALSE),stopwords = TRUE,removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = biToken))
triTDMnonstop<- TermDocumentMatrix(englishCorpus, list(weighting = function(x)weightTfIdf(x, normalize =FALSE),stopwords = TRUE,removeSparseTerms=sparsity, removeWhitespace = TRUE, tokenizer = triToken))
#identify stop words for later use
englishStop<-stopwords("english")

#save
save(uniTDM, file="./data/uniTDM.RData")
save(biTDM, file="./data/biTDM.RData")
save(triTDM, file="./data/triTDM.RData")
#save(quadTDM, file="./data/quadTDM.RData")
#
save(uniTDMnonstop, file="./data/uniTDMnonstop.RData")
save(biTDMnonstop, file="./data/biTDMnonstop.RData")
save(triTDMnonstop, file="./data/triTDMnonstop.RData")
save(englishStop, file="./data/englishStop.RData")

#clear up some mem
rm(englishCorpus)
gc()

#below was done forr exploratory analysis , not needed for building frequency tables

findFreqTerms(uniTDM, 500)
findFreqTerms(biTDM, 500)
findFreqTerms(triTDM, 100)
findFreqTerms(quadTDM, 50)
findFreqTerms(uniTDMnonstop, 5000)

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

# save
save(ngramMat,file="./data/nGramMat.RData")

# inspect

inspect(quadTDM[1:100, 1:3])
inspect(triTDM[130:200, 1:3])
inspect(biTDM[130:200, 1:3])
inspect(uniTDM[1, 1])
df <- as.data.frame(inspect(quadTDM))



## Buld frequency tables
# aggregate rows 
uniTDMfreq <- sort(rowapply_simple_triplet_matrix(uniTDM,sum), decreasing = TRUE)
biTDMfreq <- rowapply_simple_triplet_matrix(biTDM,sum)
triTDMfreq <- rowapply_simple_triplet_matrix(triTDM,sum)
#quadTDMfreq <- rowapply_simple_triplet_matrix(quadTDM,sum)
#
uniTDMnonstopfreq <- sort(rowapply_simple_triplet_matrix(uniTDMnonstop,sum), decreasing = TRUE)
biTDMnonstopfreq <- sort(rowapply_simple_triplet_matrix(biTDMnonstop,sum), decreasing = TRUE)
triTDMnonstopfreq <- sort(rowapply_simple_triplet_matrix(triTDMnonstop,sum), decreasing = TRUE)

#save these

#save
save(uniTDMfreq, file="./data/uniTDMfreq.RData")
save(biTDMfreq, file="./data/biTDMfreq.RData")
save(triTDMfreq, file="./data/triTDMfreq.RData")
#save(quadTDMfreq, file="./data/quadTDMfreq.RData")
#
save(uniTDMnonstopfreq, file="./data/uniTDMnonstopfreq.RData")
save(biTDMnonstopfreq, file="./data/biTDMnonstopfreq.RData")
save(triTDMnonstopfreq, file="./data/triTDMnonstopfreq.RData")


##Top 20 graphs

#uni
uniTDMfreq20 <- sort(uniTDMfreq, decreasing=TRUE)[1:20]
# y-axis
uniLevels<-names(uniTDMfreq20)
qplot(uniLevels,uniTDMfreq20, geom='bar', main="1-Gram Term Frequencies", xlab="Terms",ylab= "counts" ,stat="identity") + coord_flip()
ggsave(filename="./data/uniTDMfreq20.png", width = 4, height=4, dpi=100)


#bi
biTDMfreq20 <- sort(biTDMfreq, decreasing=TRUE)[1:20]
# y-axis
biLevels<-names(biTDMfreq20)
qplot(biLevels,biTDMfreq20, geom='bar', main="2-Gram Term Frequencies", xlab="Terms",ylab= "counts" ,stat="identity") + coord_flip()
ggsave(filename="./data/biTDMfreq20.png", width = 4, height=4, dpi=100)

#tri
triTDMfreq20 <- sort(triTDMfreq, decreasing=TRUE)[1:20]
# y-axis
triLevels<-names(triTDMfreq20)
qplot(triLevels,triTDMfreq20, geom='bar', main="3-Gram Term Frequencies", xlab="Terms",ylab= "counts" ,stat="identity") + coord_flip()
ggsave(filename="./data/triTDMfreq20.png", width = 4, height=4, dpi=100)

#quad
quadTDMfreq20 <- sort(quadTDMfreq, decreasing=TRUE)[1:20]
# y-axis
quadLevels<-names(quadTDMfreq20)
qplot(quadLevels,quadTDMfreq20, geom='bar', main="4-Gram Term Frequencies", xlab="Terms",ylab= "counts" ,stat="identity") + coord_flip()
ggsave(filename="./data/quadTDMfreq20.png", width = 4, height=4, dpi=100)


