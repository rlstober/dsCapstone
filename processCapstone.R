#process

# user defined functions
source("./cleanTextFunction.R")

#download if 
source("./downloadCapstoneData.R")

# read files in
source("./readFilescapstone.R")

# clean it up and save
source("./saveCleanData.R")

# sample and save
source("./saveSampleData.R")

# create sparse document term matrix and save frequency tables
source("./buildNgrams.R")

# build and save data tables used in prediction
source("./buildDataTables.R")
