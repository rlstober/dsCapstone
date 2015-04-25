##Clean it up for further processing
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
