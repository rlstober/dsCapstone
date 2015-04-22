#download

## Download process

# File names
destFile <- "./data/Coursera-SwiftKey.zip"
sourceFile <- "http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

# download
download.file(sourceFile, destFile)

# extract 
unzip(destFile)

