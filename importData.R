# importing and sampling the data

# load stringi library
library(stringi)

setwd("L:/git/Data-Science-Capstone/data")

list.files("final")
list.files("final/en_US")

# import the blogs and twitter datasets in text mode
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding="UTF-8")
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding="UTF-8")

#importing news dataset
con <- file("final/en_US/en_US.news.txt", open="rb")
news <- readLines(con, encoding="UTF-8")
close(con)
rm(con)

# dropping non UTF-8 character
twitter <- iconv(twitter, from = "latin1", to = "UTF-8", sub="")
twitter <- stri_replace_all_regex(twitter, "\u2019|`","'")
twitter <- stri_replace_all_regex(twitter, "\u201c|\u201d|u201f|``",'"')

# Sampling the data
blogs <- sample(blogs,10000)
news <- sample(news,10000)
twitter <- sample(twitter,10000)

data <- c(twitter,blogs,news)

rm(blogs)
rm(news)
rm(twitter)
setwd("L:/git/Data-Science-Capstone/sample")
save(data,file="sample_data.rds")
