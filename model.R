library(tm)
library(qdapDictionaries)
library(qdapRegex)
library(qdapTools)
library(qdap)
library(NLP)
library(SnowballC)
library(slam)
library(RWeka)
library(RWekajars)
library(rJava)


## Building a clean corpus

theSampleCon <- file("./textSample.txt")
theSample <- readLines(theSampleCon)
close(theSampleCon)


cleanSample <- Corpus(VectorSource(theSample))

## Convert to lower case
cleanSample <- tm_map(cleanSample, content_transformer(tolower), lazy = TRUE)
## remove punction, numbers, URLs, stop, profanity and stem wordson
cleanSample <- tm_map(cleanSample, content_transformer(removePunctuation))
cleanSample <- tm_map(cleanSample, content_transformer(removeNumbers))
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x) 
cleanSample <- tm_map(cleanSample, content_transformer(removeURL))
cleanSample <- tm_map(cleanSample, stripWhitespace)
cleanSample <- tm_map(cleanSample, removeWords, stopwords("english"))
cleanSample <- tm_map(cleanSample, removeWords, profanityWords)
cleanSample <- tm_map(cleanSample, stemDocument)
cleanSample <- tm_map(cleanSample, stripWhitespace)

## Saving the final corpus
saveRDS(cleanSample, file = "./cleanCorpus.rds")

## Budilding the n-grams

cleanCorpus <- readRData("./cleanCorpus.rds")
cleanCorpusDF <-data.frame(text=unlist(sapply(cleanCorpus,`[`, "content")), 
                           stringsAsFactors = FALSE)

# Building the tokenization function for the n-grams
ngramTokenizer <- function(theCorpus, ngramCount) {
  ngramFunction <- NGramTokenizer(theCorpus, 
                                  Weka_control(min = ngramCount, max = ngramCount, 
                                               delimiters = " \\r\\n\\t.,;:\"()?!"))
  ngramFunction <- data.frame(table(ngramFunction))
  ngramFunction <- ngramFunction[order(ngramFunction$Freq, 
                                       decreasing = TRUE),][1:10,]
  colnames(ngramFunction) <- c("String","Count")
  ngramFunction
}

unigram <- ngramTokenizer(cleanCorpusDF, 1)
saveRDS(unigram, file = "./unigram.rds")
bigram <- ngramTokenizer(cleanCorpusDF, 2)
saveRDS(bigram, file = "./bigram.rds")
trigram <- ngramTokenizer(cleanCorpusDF, 3)
saveRDS(trigram, file = "./trigram.rds")
quadgram <- ngramTokenizer(cleanCorpusDF, 4)
saveRDS(quadgram, file = "./quadgram.rds")