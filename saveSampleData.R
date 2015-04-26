##saveSampleData

##Sampling

set.seed<-12345
#sampSize<-1000
sampSize<-.05
blogDataSample<-sample(blogData,length(blogData)*sampSize)
twitterDataSample<-sample(twitterData,length(twitterData)*sampSize)
newsDataSample<-sample(newsData,length(newsData)*sampSize)


# Sample File names
blogSaveSamp<-"./sampleData/blogsSamp.RData"
twitterSaveSamp<-"./sampleData/twitterSamp.RData"
newsSaveSamp<-"./sampleData/newsSamp.RData"

save(blogDataSample,file=blogSaveSamp)
save(twitterDataSample,file=twitterSaveSamp)
save(newsDataSample,file=newsSaveSamp)

# save all in one file
englishSaveSample<-"./data/englishTextSample.RData"
save(blogDataSample,twitterDataSample, newsDataSample,file=englishSaveSample)


# Sample connections
blogCon<-file("./sampleData/blogsSamp.txt")
twitterCon<-file("./sampleData/twitterSamp.txt")
newsCon<-file("./sampleData/newsSamp.txt")


writeLines(blogDataSample, blogCon);close(blogCon)
writeLines(newsDataSample, newsCon);close(newsCon)
writeLines(twitterDataSample, twitterCon);close(twitterCon)