rm(list=ls()); gc()
library(stringi)
library(tm)
library(RWeka)

# load
load("./data/uniTDMfreq.RData")
load("./data/biTDMfreq.RData")
load("./data/triTDMfreq.RData")
load("./data/quadTDMfreq.RData")

phrase<-'live and'
#get logical vector of trigrams with phrase
#get logical vector of trigrams with case of
select <- names(triTDMfreq)[grepl(phrase,names(triTDMfreq))]
# get rows that match phrase
mTDM = as.matrix(triTDMfreq[select])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["live and die"]
sumTDM["live and sleep"]
sumTDM["live and give"]
sumTDM["live and eat"]

class(triTDMfreq)


#3



uniTDMfreq["weekend"] #275
uniTDMfreq["morning"] #418 wrong
uniTDMfreq["month"] # 230
uniTDMfreq["decade"]# 55

triTDMfreq["monkees this weekend"] #1
triTDMfreq["monkees this month"] #7
triTDMfreq["monkees this decade"] # 1
triTDMfreq["take a look"]# 9

phrase<-'arctic'
#get logical vector of trigrams with phrase
#get logical vector of trigrams with case of
select <- names(triTDMfreq)[grepl(phrase,names(triTDMfreq))]
# get rows that match phrase
mTDM = as.matrix(triTDMfreq[select])
sumTDM = sort(rowSums(mTDM), decreasing = TRUE)
sumTDM["live and die"]
sumTDM["live and sleep"]
sumTDM["live and give"]
sumTDM["live and eat"]

inspect(englishCorpus["arctic monkeys"])

#5
triTDMfreq["take a walk"] #1
triTDMfreq["take a picture"] #7
triTDMfreq["take a minute"] # 1
triTDMfreq["take a look"]# 9


#6
triTDMfreq["settle the case"] #1
triTDMfreq["settle the matter"] #7
triTDMfreq["settle the account"]# 9
triTDMfreq["settle the incident"] # 1

biTDMfreq["jury case"] #1
biTDMfreq["jury matter"] #7
biTDMfreq["jury account"]# 9
biTDMfreq["jury incident"] # 1




#Q10

uniTDMfreq["pictures"] #119
uniTDMfreq["movies"] #83


