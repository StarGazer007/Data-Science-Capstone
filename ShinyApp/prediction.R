# Call the Libraries
suppressPackageStartupMessages(c(
  library(shiny),
  library(shinythemes),
  library(tm),
  library(stringr),
  library(markdown),
  library(stylo)))

# Load the Data files
qData <- readRDS(file="data/quadgram.rds")
tData <- readRDS(file="data/trigram.rds")
bData <- readRDS(file="data/bigram.rds")

#clean the data
dataCleaner<-function(text){
  
  cleanText <- tolower(text)
  cleanText <- removePunctuation(cleanText)
  cleanText <- removeNumbers(cleanText)
  cleanText <- str_replace_all(cleanText, "[^[:alnum:]]", " ")
  cleanText <- stripWhitespace(cleanText)
  
  return(cleanText)
}

inputCleaner <- function(text){
  
  textInput <- dataCleaner(text)
  textInput <- txt.to.words.ext(textInput, 
                                language="English.all", 
                                preserve.case = TRUE)
  
  return(textInput)
}

# Word prediction based on trigrams
nextWordPrediction <- function(wordCount,textInput){
  
  if (wordCount>=3) {
    textInput <- textInput[(wordCount-2):wordCount] 
    
  }
  
  else if(wordCount==2) {
    textInput <- c(NA,textInput)   
  }
  
  else {
    textInput <- c(NA,NA,textInput)
  }
  
  wordPrediction <- as.character(qData[qData$unigram==textInput[1] & 
                                       qData$bigram==textInput[2] & 
                                       qData$trigram==textInput[3],][1,]$quadgram)
  
  if(is.na(wordPrediction)) {
    wordPrediction <- as.character(tData[tData$unigram==textInput[2] & 
                                          tData$bigram==textInput[3],][1,]$trigram)
    
    if(is.na(wordPrediction)) {
      wordPrediction <- as.character(bData[bData$unigram==textInput[3],][1,]$bigram)
    }
  }
  
  
  print(wordPrediction)
  
}