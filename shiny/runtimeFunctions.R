#runtimeFunctions
# rm(list=ls()); gc()

library(stringi)
library(stringr)
library(data.table)
library(sqldf)
library(wordcloud)
require(tcltk)

cleanText<-function(myText){
  resultText <- stri_trans_tolower(myText)
  ## non-utf-8 characters
  # drop non UTF-8 characters 
  resultText <- iconv(resultText, from = "latin1", to = "UTF-8", sub="") 
  #replace unicode single quote
  resultText <- stri_replace_all_regex(resultText, "\u2019|`","'") 
  #replace unicode quotes
  resultText <- stri_replace_all_regex(resultText, "\u201c|\u201d|u201f|``",'"') 
  #add start tag
  resultText <- stri_replace_all_regex(resultText, "^",'<start> ')
  # remove profanity
  resultText <- stri_replace_all_regex(resultText, "fuck ",'')
  resultText <- stri_replace_all_regex(resultText, "cunt ",'')
  resultText <- stri_replace_all_regex(resultText, "shit ",'')
  # trim function got from stack overflow
  #http://stackoverflow.com/questions/14737266/removing-multiple-spaces-and-trailing-spaces-using-gsub
  trim <- function(x) return(gsub("^ *|(?<= ) | *$", "", x, perl=T))
  resultText<-trim(resultText)
  return(resultText)
}

dtInput<-function(cleanPhrase){
  # clean it like initial data load
  dtIn<-as.data.table(unlist(cleanPhrase))
  #dtIn<-as.data.table(unlist(str_split(cleanPhrase," ")))
  setnames(dtIn, "V1", "Phrase")
  #if nothing input then start 
  if (is.null(dtIn$Phrase)) dtIn$Phrase<-"<start>"
  if (dtIn$Phrase =="") dtIn$Phrase<-"<start>"
  #split input
  splitPhrase<-unlist(str_split(dtIn$Phrase," "))
  #how many words were input
  phraseCount<-length(splitPhrase)
  # populate columns with words 
  dtIn$t<-splitPhrase[phraseCount -2]
  dtIn$u<-splitPhrase[phraseCount -1]
  dtIn$v<-splitPhrase[phraseCount]
  dtIn$Bigram<-paste(dtIn$u,dtIn$v)
  dtIn$Trigram<-paste(dtIn$t, dtIn$u,dtIn$v)
  return(dtIn)
}

#
predictOutput<-function(dtIn){
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
  
  return(predictResult)
}

