# rm(list=ls()); gc()
source("./runtimeFunctions.R")
library(stringr)
library(data.table)
library(sqldf)
require(tcltk)

#library(tidyr)


#load("./predictTDMdt.RData")

#object.size(predictTDMdt)/1024
testD<-"This application is"
test1<-" My name is     not Sam"
test2<-"fuck didn't i say i didnt wany any"
test3<-" go to "

test4<-sample(predictTDMdt$Phrase,1)
testBlank<-""

test<-test4
cleanPhrase<-cleanText(test)

dtIn<-dtInput(cleanPhrase)
(dtIn)
#head(predictTDMdt)

sz<-3

predictOut<-predictOutput(dtIn)

g1<-as.matrix(predictOut[1:sz,1],dimnames = list(NULL,"Words"))


#predict
# 
# triResult<-sqldf("select w, TrigramProbability as Probability from predictTDMdt join dtIn using (Trigram) order by TrigramProbability DESC limit 10")
# biResult<-sqldf("select w, BigramProbability  as Probability from predictTDMdt join dtIn using (Bigram) order by BigramProbability DESC limit 10")
# 
# #maxContinuationProbability <-sqldf("select max(ContinuationProbability) from predictTDMdt")
# uniResult<-sqldf("select w, ContinuationProbability  as Probability from predictTDMdt  order by ContinuationProbability desc limit 20")

# 
# predictResultTable<-sqldf("select w,  Probability from triResult
#         UNION select w,  .4*Probability from biResult
#         UNION select w,  .4*.4*Probability from uniResult")


#unigrams has many with same probability, randomize so will be different
uniResult<-fn$sqldf("select distinct w, ContinuationProbability from predictTDMdt order by ContinuationProbability Desc limit 100")
uniResult$r100<-sample(1:100, 100, replace=FALSE)
uniResultTable<-sqldf("select w, ContinuationProbability from uniResult  order by r100 limit 20")
  
predictResultTable<-sqldf("select w, 3+ TrigramProbability as Probability from predictTDMdt join dtIn using (Trigram) 
        UNION select w, 2+ BigramProbability  as Probability from predictTDMdt join dtIn using (Bigram) 
        UNION select w, 1+ContinuationProbability  as Probability from uniResultTable  
                          order by Probability desc")
#words may not be distinct
predictResultTableSum<-sqldf("select w, max(Probability) as Probability from predictResultTable group by w")
#get top 5
predictResult<-sqldf("select w, Probability from predictResultTableSum order by Probability DESC limit 5")



