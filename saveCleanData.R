##saveClean

#clean
blogData<-cleanText(blogData)
twitterData<-cleanText(twitterData)
newsData<-cleanText(newsData)

## Save data tables

#File names
blogSave<-"./data/blogs.RData"
twitterSave<-"./data/twitter.RData"
newsSave<-"./data/news.RData"

save(blogData,file=blogSave)
save(twitterData,file=twitterSave)
save(newsData,file=newsSave)

# save all in one file
englishSave<-"./data/englishText.RData"
englishData<-c(blogData,twitterData, newsData)
save(englishData,file=englishSave)
