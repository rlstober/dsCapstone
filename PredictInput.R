# rm(list=ls()); gc()
source("./runtimeFunctions.R")
library(stringr)
library(data.table)
library(sqldf)

#library(tidyr)


load("./data/predictTDMdt.RData")
#object.size(predictTDMdt)/1024
testD<-"This application is"
test1<-" My name is     not Sam"
test2<-"fuck didn't i say i didnt wany any"
test3<-" go to "
test4<-sample(predictTDMdt$Phrase,1)
testBlank<-""

test<-testD
cleanPhrase<-cleanText(test)

dtIn<-dtInput(cleanPhrase)
(dtIn)
head(predictTDMdt)


(dtIn)
sz<-3

predictOut<-predictOutput(dtIn)

g1<-as.matrix(predictOut[1:sz,1],dimnames = list(NULL,"Words"))


#predict

triResult<-sqldf("select w, TrigramProbability as Probability from predictTDMdt join dtIn using (Trigram) order by TrigramProbability DESC limit 10")
biResult<-sqldf("select w, BigramProbability  as Probability from predictTDMdt join dtIn using (Bigram) order by BigramProbability DESC limit 10")

#maxContinuationProbability <-sqldf("select max(ContinuationProbability) from predictTDMdt")
uniResult<-sqldf("select w, ContinuationProbability  as Probability from predictTDMdt  order by ContinuationProbability desc limit 20")


predictResultTable<-sqldf("select w,  Probability from triResult
        UNION select w,  .4*Probability from biResult
        UNION select w,  .4*.4*Probability from uniResult")


predictResultTable<-sqldf("select w, TrigramProbability as Probability from predictTDMdt join dtIn using (Trigram) 
        UNION select w, .4*BigramProbability  as Probability from predictTDMdt join dtIn using (Bigram) 
        UNION select w, .4*.4*ContinuationProbability  as Probability from predictTDMdt  
                          order by Probability desc limit 50")

#words may not be distinct
predictResultTableSum<-sqldf("select w, sum(Probability) as Probability from predictResultTable group by w")

predictResult<-sqldf("select w, Probability from predictResultTableSum order by Probability DESC limit 5")

str(predictResultTableSum)

