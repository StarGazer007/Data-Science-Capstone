# Start the clock!
ptm <- proc.time()

# Preload required R librabires

library(tm)
library(RWeka)
library(R.utils)
library(dplyr)
library(parallel)


#Set options
options(stringsAsFactors = FALSE)
options(mc.cores=4)

setwd("L:/git/Data-Science-Capstone")

status <- "Options set"

# parameters

pathname <- paste0(getwd(), "/data/final/en_US/")
fnames <- c("blogs","news","twitter")
fileNames <-list.files(pathname, recursive=TRUE)
portion <- as.numeric(1)

loadFiles <-function (path, file){
  
  con <- file(paste0(path, file) )
  n <- readLines(con,encoding = "UTF-8", skipNul = TRUE, warn=FALSE)
  return(n)
}

sampleFile <- function(file, portion) {
  sample <- sample(file, length(file) * portion)
  return(sample)
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

saveRDS(data.frame(data.sample),"sample/dictionary.rds")



rm(blog.sample,news.sample,twitter.sample,data.sample)
gc()

corpus <-VCorpus(DirSource("sample", encoding = "UTF-8"),
         readerControl = list(language = "lat"))


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
#UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
#QuintgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))

#uni.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = UnigramTokenizer))
bi.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = BigramTokenizer))
tri.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = TrigramTokenizer))
quad.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = QuadgramTokenizer))
#quint.tdm<- TermDocumentMatrix(corpus.cl, control = list(tokenize = QuintgramTokenizer))

rm(corpus.cl,data.sample)
gc()


#Build Prediction Tables
library(dtplyr)
library(slam)
library(data.table)

convertNgram <- function (tdm) {
  #dt <- removeSparseTerms(tdm, 0.01)
  colnames(tdm) <- "freq"
  tdm <- row_sums(tdm)
  dt <- data.table(grams=names(tdm), freq=tdm)
  setkey(dt,grams) 
  
  return(dt)
  
}

#uniFreq <- convertNgram(uni.tdm)
biFreq <-convertNgram(bi.tdm)
triFreq <-convertNgram(tri.tdm)
quadFreq <-convertNgram(quad.tdm)

saveRDS(biFreq,"ShinyApp/data/bigram.rds")
saveRDS(triFreq,"ShinyApp/data/trigram.rds")
saveRDS(quadFreq,"ShinyApp/data/quadgram.rds")

#quadFreq <-convertNgram(quad.tdm)
#quintFreq <-convertNgram(quint.tdm)

#rm(uni.tdm,bi.tdm,tri.tdm,quad.tdm, quint.tdm)
#gc()

runtm <- proc.time() - ptm 

