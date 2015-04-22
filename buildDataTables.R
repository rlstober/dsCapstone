#buildDataTables
# rm(list=ls()); gc()
library(data.table)

load("./data/uniTDMsparseFreq.RData")
load("./data/biTDMsparseFreq.RData")
load("./data/triTDMsparseFreq.RData")
load("./data/quadTDMsparseFreq.RData")

str(triTDMsparseFreq)

triTDMdt<-as.data.table(triTDMsparseFreq,keep.rownames = TRUE)
str(triTDMdt)


triTDMdt$adjCount<-triTDMdt$triTDMsparseFreq-.5
adjtotal<-sum(triTDMdt$adjCount)
triTDMdt$adjProb<--log(triTDMdt$adjCount/sum(triTDMdt$adjCount))


head(triTDMdt)
