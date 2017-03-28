#********************************
# helper.R
#
#

# Preload required R librabires

#status <- "Loading Libraries"

library(tm)
library(RWeka)
library(R.utils)
library(dplyr)
library(parallel)


makeCorpus<- function(x) {
  corpus<-Corpus(VectorSource(x))
  # corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, content_transformer(tolower))
  # corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stemDocument)
  corpus<- tm_map(corpus,removePunctuation)
  # corpus<- tm_map(corpus,removeNumbers)
  return(corpus)
}

getPrediction<- function(w){
  
  # transform as training set was (lowercase, stem, strip punctuation etc.)
  w<-iconv(w, to='ASCII', sub=' ')
  w<-process(w)
  w<-paste0(w, collapse=" ")
  return(w)
}


process<- function(x) {
  x=gsub(",?", "", x)
  x=gsub("\\.{3,}", "", x)
  x=gsub("\\:", "", x)
  x=gsub("\\'", "", x)
  x=gsub("\\|", "", x)
  x=gsub("\\{", "", x)
  x=gsub("\\}", "", x)
  x<-strsplit(unlist(x),"[\\.]{1}")
  x<-strsplit(unlist(x),"\\?+")
  x<-strsplit(unlist(x),"\\!+") # Error: non-character argument?
  x<-strsplit(unlist(x),"\\-+")
  x<-strsplit(unlist(x),"\\(+")
  x<-strsplit(unlist(x),"\\)+")
  x<-strsplit(unlist(x),"\\\"")
  x<-gsub("^\\s+", "", unlist(x))
  x<-gsub("\\s+$", "", unlist(x))
  x<-gsub("\\s*~\\s*", " ", unlist(x))
  x<-gsub("\\/", " ", unlist(x))
  x<-gsub("\\+", " ", unlist(x))
  x<-gsub("it s ", "its ", unlist(x))
  x<-gsub("i m not", "im not", unlist(x))
  x<-gsub("i didn t", "i didnt", unlist(x))
  x<-gsub("i don t", "i dont", unlist(x))
  x<-gsub(" i m ", " im ", unlist(x))
  x=x[which(nchar(x)!=1)]
  x=x[which(nchar(x)!=0)]
  
  return(x)
}
