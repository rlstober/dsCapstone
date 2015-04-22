##Read  process

# Use function to avoid copying code and ensure all data is treated the same.
#Read in binary mode for news feel
#skipNul needed for twitter
# set UTF-8 encoding

readFiles<- function(x,openMode){
  con <- file(x,  open=openMode)
  df<-readLines(con, encoding="UTF-8", skipNul=TRUE)
  close(con)
  return(df)
}

#File names
blogFile<-"./final/en_us/en_US.blogs.txt"
twitterFile<-"./final/en_us/en_US.twitter.txt"
newsFile<-"./final/en_us/en_US.news.txt"

openMode<- "rt"
blogData<-readFiles(blogFile,openMode)
twitterData<-readFiles(twitterFile,openMode)
openMode<- "rb"
newsData<-readFiles(newsFile,openMode)