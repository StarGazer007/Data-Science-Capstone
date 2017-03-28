suppressPackageStartupMessages(c(
  library(shinythemes),
  library(shiny),
  library(tm),
  library(stringr),
  library(markdown),
  library(stylo)
  ))



# Trigrams
#allfreq<-readRDS(file="dictionary.RDS")


textCleaner<-function(text){
  
  cleanText <- tolower(text)
  cleanText <- removePunctuation(cleanText)
  cleanText <- removeNumbers(cleanText)
  cleanText <- str_replace_all(cleanText, "[^[:alnum:]]", " ")
  cleanText <- stripWhitespace(cleanText)
  
  return(cleanText)
}


cleanInput <- function(text){
  
  textInput <- textCleaner(text)
  textInput <- txt.to.words.ext(textInput, 
                                language="English.all", 
                                preserve.case = TRUE)

  #return(textInput)
}


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
  
  
  ### 1 ###
  wordPrediction <- as.character(allfreq[allfreq$unigram==textInput[1] & 
                                        allfreq$bigram==textInput[2] & 
                                        allfreq$trigram==textInput[3],][1,]$quadgram)

  
  return(wordPrediction)
  
}
