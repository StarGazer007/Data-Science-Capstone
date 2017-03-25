# Start the clock!
ptm <- proc.time()

# Preload required R librabires

status <- "Loading Libraries"

library(tm)
library(RWeka)
library(R.utils)
library(dplyr)
library(parallel)



status <- "Libraries Loaded"

#Set options
options(stringsAsFactors = FALSE)
options(mc.cores=4)

setwd("L:/Cousera/git/Data-Science-Capstone")

status <- "Options set"

# parameters

pathname <- paste0(getwd(), "/data/final/en_US/")
fnames <- c("blogs","news","twitter")
fileNames <-list.files(pathname, recursive=TRUE)
portion <- as.numeric(0.05)

loadFiles <-function (path, file){
  
  con <- file(paste0(path, file) )
  n <- readLines(con,encoding = "UTF-8", skipNul = TRUE, warn=FALSE)
  
  return(n)
  
  
}

sampleFile <- function (file, portion) {
  sample <- sample(file, length(file) * portion)
  return(sample)
}


writeSample <- function (file, dir, n) {
  writeLines(file, paste0(dir,"/",n))
  
}

blog <-loadFiles (pathname,fileNames[1])
news<-loadFiles (pathname,fileNames[2])
twitter <-loadFiles (pathname,fileNames[3])

set.seed(1218)
blog.sample <- sample(blog, length(blog) * portion)
news.sample <- sample(news, length(news) * portion)
twitter.sample <- sample(twitter, length(twitter) * portion)

# Sample the data

data.sample <- c(blog.sample , news.sample, twitter.sample )
rm(blog, news, twitter)
gc()

writeSample(data.sample, "sample", "all.txt")

rm(blog.sample,news.sample,twitter.sample)


corpus <- VCorpus(DirSource("sample", encoding = "UTF-8"),
                  readerControl = list(language = "en"))

#Clean the text
cleanCorpus <- function (corpus){
  
  # Remove unconvention/funny characters from sampled Blogs/News/Twitter
  removeEmoticons <- content_transformer(function (x) {
    x <- iconv(x, "UTF-8", "ASCII", sub="")
  })
  
  #Remove 550 known bad words for in profanity file
  badWords = readLines('profanity.txt')
  corpus.tmp <- tm_map(corpus, removeWords, badWords) 
  
  
  funcs <- list( content_transformer(tolower),
                 removeEmoticons, 
                 removePunctuation, 
                 removeNumbers, 
                 stripWhitespace,
                 PlainTextDocument)
  corpus.tmp <- tm_map(corpus.tmp, FUN = tm_reduce, tmFuns = funcs, lazy = TRUE)
  return (corpus.tmp)
}

corpus.cl <- cleanCorpus(corpus)
rm(corpus)
gc()



# Tokenizer functions

QuintgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))

quint.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = QuintgramTokenizer))
quad.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = QuadgramTokenizer))
tri.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = TrigramTokenizer))
bi.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = BigramTokenizer))
uni.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = UnigramTokenizer))

rm(corpus.cl,data.sample)
gc()


#Build Prediction Tables
library(dtplyr)
library(slam)

convertNgram <- function (tdm) {
  colnames(tdm) <- "freq"
  dt <- row_sums(tdm)
  dt <- data.table(grams=names(dt), freq=dt)
  setkey(dt,grams) 
  
  return(dt)
  
}

rm(uni.tdm,bi.tdm,tri.tdm,quad.tdm, quint.tdm)
gc()


uniFreq <- convertNgram(uni.tdm)


biFreq <-convertNgram(bi.tdm)
triFreq <-convertNgram(tri.tdm)
quadFreq <-convertNgram(quad.tdm)
quintFreq <-convertNgram(quint.tdm)

runtm <- proc.time() - ptm 
