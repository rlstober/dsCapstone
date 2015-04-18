# build datasets 
rm(list=ls()); gc()
library(tm)
library(RWeka)
library(SnowballC)
library(ggplot2)
library(slam)
library(data.table)

#load datasets
load("./data/uniTDMfreq.RData")
load("./data/biTDMfreq.RData")
load("./data/triTDMfreq.RData")

#
load("./data/uniTDMnonstopfreq.RData")
load("./data/biTDMnonstopfreq.RData")
load("./data/triTDMnonstopfreq.RData")
#
load("./data/englishStop.RData")

stopwords("SMART")
stopwords("en")
stopwords("english")


triTDMdt<-as.data.table(triTDMfreq,keep.rownames = TRUE)

x<-as.data.table(strsplit(triTDMdt$rn, split=" "))
# shouldbe trigrams but get warningmessgaes some ows don;lt have thre emembers remove them


# set up data table
#uniTDMnonstopDT<-as.data.table(names(uniTDMnonstopfreq))
str(uniTDMnonstopDT)
uniTDMnonstopDT<-as.data.table(uniTDMnonstopfreq,keep.rownames = TRUE)
#better names
oldNames<-names(uniTDMnonstopDT)
newNames<-(c("Word", "Frequency"))
setnames(uniTDMnonstopDT,oldNames,newNames)
# add counts
uniTDMnonstopDT$Count<-uniTDMnonstopfreq
# how many distinct words
uniTDMnonstopfreqLength<-length(uniTDMnonstopfreq)
# total words
uniTDMnonstopfreqTotal<-sum(uniTDMnonstopfreq)
# relative frequency
uniTDMnonstopDT$RelativeFrequency<-(uniTDMnonstopDT$Count/uniTDMnonstopfreqTotal)
#cumulative frequency
uniTDMnonstopDT$CumulativeFrequency<-cumsum(uniTDMnonstopDT$RelativeFrequency)
#DISCOUNT
uniTDMnonstopDT$AdjustedCount<-uniTDMnonstopDT$Count - 0.5

object.size(uniTDMnonstopDT)

xDTMf<-uniTDMnonstopfreq

getDTMFreqDT<-function(xDTMf, adj){
  # set up data table
  xDT<-as.data.table(xDTMf,keep.rownames = TRUE)
  #better names
  oldNames<-names(xDTMf)
  newNames<-(c("Word", "Frequency"))
  setnames(xDT,oldNames,newNames)
  # add counts
  xDT$Count<-xDTMf
  # how many distinct words
  xDTlength<-length(xDTMf)
  # total words
  xDTtotal<-sum(xDTMf)
  # relative frequency
  xDT$RelativeFrequency<-(xDT$Count/xDTtotal)
  #cumulative frequency
  xDT$CumulativeFrequency<-cumsum(xDT$RelativeFrequency)
  #DISCOUNT
  xDT$AdjustedCount<-xDT$Count - adj
  (object.size(uniTDMnonstopDT))
  return(xDT)
}

uniTDMDT<-getDTMFreqDT(xDTMf=uniTDMfreq, adj=0.5)