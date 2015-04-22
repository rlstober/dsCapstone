##Clean it up for further processing
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
