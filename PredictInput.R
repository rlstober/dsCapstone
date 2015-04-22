require(stringr)

cleanText<-function(myText){
  resultText <- stri_trans_tolower(myText)
  #remove profanity
  resultText <- stri_replace_last_regex(resultText,'["fuck", "piss", "shit", "cunt", "cocksucker", "motherfucker", "tits"]','')
  ## non-utf-8 characters
  # drop non UTF-8 characters 
  resultText <- iconv(resultText, from = "latin1", to = "UTF-8", sub="") 
  #replace unicode single quote
  resultText <- stri_replace_all_regex(resultText, "\u2019|`","'") 
  #replace unicode quotes
  resultText <- stri_replace_all_regex(resultText, "\u201c|\u201d|u201f|``",'"') 
  return(resultText)
}

predictInput<-function(phrase){
  # clean it like initial dtaa load
  cleanPhrase<-cleanText(phrase)
  # got from stack overflow
  #http://stackoverflow.com/questions/14737266/removing-multiple-spaces-and-trailing-spaces-using-gsub
  trim <- function(x) return(gsub("^ *|(?<= ) | *$", "", x, perl=T))
  cleanPhrase<-trim(cleanPhrase)
  nwIn<-length(cleanPhrase)
  vIn<-unlist(str_split(cleanPhrase," "))
  return(vIn)
}

test<-" My name is     not Sam"
result<-predictInput(test)
t<-result[length(result)-2]
u<-result[length(result)-1]
v<-result[length(result)]
