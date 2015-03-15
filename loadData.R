#Load Data

#File names
blogFile<-"./data/en_US.blogs.txt"
twitterFile<-"./data/en_US.twitter.txt"
newsFile<-"./data/en_US.news.txt"


#Read 
# Use function to avoid copying code and ensure all data is treated the same.
#Read in binary mode for news feel
#skipNul needed for twitter
# set to all read UTF-8 encoding

readFiles<- function(x){readLines(file(x, open="rb"), encoding="UTF-8", skipNul=TRUE)}

blogData<-readFiles(blogFile)
twitterData<-readFiles(twitterFile)
newsData<-readFiles(newsFile)

#Question 1
#The en_US.blogs.txt file is how many megabytes?
file.info(blogFile)$size / 1024^2
#200.4242

#review
head(blogData)
head(twitterData)
head(newsData)

#for Q2
length(twitterData)
#2,360,148

length(blogData)
length(newsData)

#Question 3
#What is the length of the longest line seen in any of the three en_US data sets?
max(nchar(blogData))
max(nchar(twitterData))
max(nchar(newsData))

#max(nchar(blogData))
#[1] 40,833

#Question 4
#In the en_US twitter data set, if you divide the number of lines where the word "love" (all lowercase) occurs 
#by the number of lines the word "hate" (all lowercase) occurs, about what do you get?

love<- sum(grepl("love", twitterData))
hate<- sum(grepl("hate", twitterData))
love/hate

#> love/hate
#[1] 4.108592

#Question 5
#The one tweet in the en_US twitter data set that matches the word "biostats" says what?

biostats<- grep("biostats", twitterData)
twitterData[biostats]
#[1] "i know how you feel.. i have biostats on tuesday and i have yet to study =/"

#Question 6
#How many tweets have the exact characters 
# "A computer once beat me at chess, but it was no match for me at kickboxing". 

sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", twitterData))
#3

# save in Rdata format for later use
saveFiles <- function(x,y){save(x, file = y)}

#File names
blogSave<-"./data/blogs.RData"
twitterSave<-"./data/twitter.RData"
newsSave<-"./data/news.RData"

saveFiles(blogData,blogSave)
saveFiles(twitterData,twitterSave)
saveFiles(newsData,newsSave)


#Save sample
saveFileSample <- function(x,y,n){z<-sample(x,n);save(z, file = y)}
# Sample File names
blogSave<-"./data/blogsSamp.RData"
twitterSave<-"./data/twitterSamp.RData"
newsSave<-"./data/newsSamp.RData"

#
set.seed<-12345
sampSize<-10000
saveFileSample(blogData,blogSave,sampSize)
saveFileSample(twitterData,twitterSave,sampSize)
saveFileSample(newsData,newsSave,sampSize)
