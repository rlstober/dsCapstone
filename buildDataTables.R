#buildDataTables
# rm(list=ls()); gc()
library(data.table)
library(tidyr)
library(sqldf)
library(caTools)


buildDt<-function(tdm){
  k<-.5
  dt<-as.data.table(tdm,keep.rownames = TRUE)
  # clean up names
  setnames(dt,colnames(dt),make.names(colnames(dt)))
  #set colnames
  newnames<-c("Phrase","Count")
  oldnames<-colnames(dt)
  setnames(dt,oldnames,newnames)
  return(dt)
}

## 1-grams: don't load, use KN smoothing of bigrams instead

## 2-grams

#load data
load("../data/biTDMsparseFreq.RData")
# data table
biTDMdt<-buildDt(biTDMsparseFreq)
# redundant used for joins
biTDMdt$Bigram<-biTDMdt$Phrase
#split
biTDMdt<-separate(biTDMdt, Phrase, into=c("v","w"), sep = " ", remove = FALSE, convert = FALSE)
str(biTDMdt)
# remove rows with single letter in v or w
biTDMdf<- (sqldf("select * from biTDMdt where length(w) >1"))
biTDMdt<-as.data.table(biTDMdf)
biTDMdf<- sqldf("select * from biTDMdt where length(v) >1")
biTDMdt<-as.data.table(biTDMdf)

# get probability
countV<-sqldf("select v, sum(Count) as Count from biTDMdt group by v")
#and add to table
biTDMdt$UnigramCount<-sqldf("select countV.Count from biTDMdt join countV using (v)")
# calculate bigram probability 
biTDMdt$BigramProbability<-biTDMdt$Count/biTDMdt$UnigramCount

# Unigram Kneser-ney probabailities
countW<-sqldf("select w, count as ContinuationCount from biTDMdt group by v")
countW$ContinuationProb<-countW$ContinuationCount/nrow(countW)
biTDMdt$ContinuationProb<-sqldf("select countW.ContinuationProb from biTDMdt join countW using (w)")
str(biTDMdt)
head(biTDMdt)
rm(biTDMsparseFreq)

# 3-grams
#load
load("../data/triTDMsparseFreq.RData")
# build data table
triTDMdt<-buildDt(triTDMsparseFreq)
# redundant used for joins
triTDMdt$TRigram<-triTDMdt$Phrase
#separate words in phrase
triTDMdt<-separate(triTDMdt, Phrase, into=c("u","v","w"), sep = " ", remove = FALSE, convert = FALSE)

# remove rows with single letter in  t, v or w
triTDMdf<- sqldf("select * from triTDMdt where length(w) >1")
triTDMdt<-as.data.table(triTDMdf)
triTDMdf<- sqldf("select * from triTDMdt where length(v) >1")
triTDMdt<-as.data.table(triTDMdf)
triTDMdf<- sqldf("select * from triTDMdt where length(u) >1")
triTDMdt<-as.data.table(triTDMdf)


# leading Bigram
triTDMdt$Bigram<-paste(triTDMdt$u,triTDMdt$v)

# calculate probability
# get counts of leading bigrams
countUV<-sqldf("select u,v, sum(Count) as Count from triTDMdt group by u,v")
countUV$Bigram<-paste(countUV$u,countUV$v)
# and add to table
triTDMdt$BigramCount<-sqldf("select countUV.Count from triTDMdt join countUV using (Bigram)")
# calculate trigram probability 
triTDMdt$TrigramProbability<-triTDMdt$Count/triTDMdt$BigramCount
str(triTDMdt)
head(triTDMdt)
rm(triTDMsparseFreq)

## 4-grams

#load data
load("../data/quadTDMsparseFreq.RData")
quadTDMdt<-buildDt(quadTDMsparseFreq)

#separate words in phrase
quadTDMdt<-separate(quadTDMdt, Phrase, into=c("t","u","v","w"), sep = " ", remove = FALSE, convert = FALSE)

# remove rows with single letter in  v or w
quadTDMdf<- sqldf("select * from quadTDMdt where length(w) >1")
quadTDMdt<-as.data.table(quadTDMdf)
quadTDMdf<- sqldf("select * from quadTDMdt where length(v) >1")
quadTDMdt<-as.data.table(quadTDMdf)
quadTDMdf<- sqldf("select * from quadTDMdt where length(u) >1")
quadTDMdt<-as.data.table(quadTDMdf)
quadTDMdf<- sqldf("select * from quadTDMdt where length(t) >1")
quadTDMdt<-as.data.table(quadTDMdf)

# leading Trigram
quadTDMdt$Trigram<-paste(quadTDMdt$t, quadTDMdt$u, quadTDMdt$v)
# leading Bigram
quadTDMdt$Bigram<-paste(quadTDMdt$u,quadTDMdt$v)


# calculate probability

# get counts of leading trigrams
countTUV<-sqldf("select t,u,v, sum(Count) as Count from quadTDMdt group by t,u,v")
#add trigram column
countTUV$Trigram<-paste(countTUV$t, countTUV$u, countTUV$v)

# and add to table
quadTDMdt$TrigramCount<-sqldf("select countTUV.Count from quadTDMdt join countTUV using (trigram)")

# calculate trigram probability 
quadTDMdt$QuadgramProbability<-quadTDMdt$Count/quadTDMdt$TrigramCount

str(quadTDMdt)
head(quadTDMdt)
rm(quadTDMsparseFreq)

##Join to one dataset

#start with 4-grams
predictTDMdt<-quadTDMdt
# add trigram probabilities
predictTDMdt$TrigramProbability<-sqldf("select TrigramProbability from predictTDMdt join triTDMdt  using (Trigram)")
predictTDMdt$BigramProbability<-sqldf("select BigramProbability from predictTDMdt join biTDMdt  using (Bigram)")
predictTDMdt$ContinuationProbability<-sqldf("select countW.ContinuationProb from predictTDMdt join countW using (w)")
str(predictTDMdt)


## divide and save

#save complete data table
save(predictTDMdt, file="../data/predictTDMdt.RData")
save(predictTDMdt, file="./predictTDMdt.RData")

#split into train test and validation
# set.seed<-12345
# 
# # get training and save
# split<-sample.split(predictTDMdt, SplitRatio = 2/3)
# predictTDMdtTrain<-subset(predictTDMdt, split==TRUE)
# save(predictTDMdtTrain, file="./data/predictTDMdtTrain.RData")
# 
# #get the rest
# predictTDMdtRest<-subset(predictTDMdt, split==FALSE)
# #split into train and test and validation
# split<-sample.split(predictTDMdtRest, SplitRatio = 1/2)
# #get and save test
# predictTDMdtTest<-subset(predictTDMdtRest, split==TRUE)
# save(predictTDMdtTest, file="./data/predictTDMdtTest.RData")
# #get and save val
# predictTDMdtVal<-subset(predictTDMdtRest, split==FALSE)
# save(predictTDMdtVal, file="./data/predictTDMdtVal.RData")

