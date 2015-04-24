#buildDataTables
# rm(list=ls()); gc()
library(data.table)
library(tidyr)
library(stringi)
library(caTools)
library(sqldf)

buildDt<-function(tdm){
  k<-.5
  dt<-as.data.table(tdm,keep.rownames = TRUE)
  # straighten up names
  setnames(dt,colnames(dt),make.names(colnames(dt)))
  # add index and set it as key
  dt$ID<-seq.int(nrow(dt))
  setkey(dt,ID)
  #set colnames
  newnames<-c("Phrase","Count", "ID")
  oldnames<-colnames(dt)
  setnames(dt,oldnames,newnames)
  return(dt)
}
# probabilities
#dttotal<-sum(dt$tdm)
#dt$freq<-dt$tdm
#dt$freq<-dt$tdm/dttotal
#dt$prob<--log(1-dt$freq)


colnames(uniTDMdt)
## 1-grams

#load data
load("./data/uniTDMsparseFreq.RData")
# convert to table
uniTDMdt<-buildDt(uniTDMsparseFreq)
str(uniTDMdt)
head(uniTDMdt)

library(wordcloud)
wordcloud(uniTDMdt$rn, uniTDMdt$tdm,random.order=FALSE,colors=brewer.pal(8, "Dark2"))

## 2-grams

#load data
load("./data/biTDMsparseFreq.RData")
# data table
biTDMdt<-buildDt(biTDMsparseFreq)
#split
biTDMdt<-separate(biTDMdt, Phrase, into=c("v","w"), sep = " ", remove = FALSE, convert = FALSE)
# discounting
discount<-.5
biTDMdt$adjCount<-biTDMdt$Count - discount
# 
biBack<-1-(sum(biTDMdt$adjCount)/sum(biTDMdt$Count))
# calculate probability
countV<-sqldf("select v, sum(Count) as Count from biTDMdt group by v")
#and add to table
biTDMdt$UnigramCount<-sqldf("select countV.Count from biTDMdt join countV using (v)")

# calculate bigram probability 
biTDMdt$BigramProbability<-biTDMdt$adjCount/biTDMdt$UnigramCount
biTDMdt$BigramProbabilityLOg<--log(biTDMdt$BigramProbability)

# Unigram Kneser-ney probabailities

countW<-sqldf("select w, count as ContinuationCount from biTDMdt group by v")
countW$ContinuationProb<-countW$ContinuationCount/nrow(countW)
head(countW)

biTDMdt$ContinuationProb<-sqldf("select countW.ContinuationProb from biTDMdt join countW using (w)")

str(biTDMdt)
head(biTDMdt,100)

# 3-grams
#load
load("./data/triTDMsparseFreq.RData")
# build data table
triTDMdt<-buildDt(triTDMsparseFreq)
#separate words in phrase
triTDMdt<-separate(triTDMdt, Phrase, into=c("u","v","w"), sep = " ", remove = FALSE, convert = FALSE)
#discounting
triTDMdt$adjCount<-triTDMdt$Count - discount
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
triTDMdt$TrigramProbabilityLOg<--log(triTDMdt$TrigramProbability)
triBack<-1-(sum(triTDMdt$adjCount)/sum(triTDMdt$Count))

str(triTDMdt)
head(triTDMdt)

sqldf("select w , TrigramProbability from triTDMdt  where Bigram = 'one of'")
sqldf("select w , TrigramProbability from triTDMdt  where Bigram = 'one of'")

str(triTDMdt)
head(triTDMdt)

## 4-grams

#load data
#load("./data/quadTDMsparseFreq.RData")
# quadTDMdt<-buildDt(quadTDMsparseFreq)
# str(triTDMdt)
# head(triTDMdt)



##
#split
set.seed<-12345
split<-sample.split(uniTDMdt$ID, SplitRatio = 2/3)
trainUni<-subset(uniTDMdt, split==TRUE)
testUni<-subset(uniTDMdt, split==FALSE)
