suppressPackageStartupMessages(c(
  library(shinythemes),
  library(shiny),
  library(tm),
  library(stringr),
  library(markdown),
  library(stylo)
  ))



loadDictionary <- function(x){
   # x<-getwd()
   # x<-paste0(x,"/ShinyApp/data")
    corpus <-VCorpus(DirSource(x, encoding = "UTF-8"),
                              readerControl = list(language = "lat"))

    uniTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
    uni.tdm<- TermDocumentMatrix(corpus, control = list(tokenize =  uniTokenizer))

    library(dtplyr)
    library(slam)
    library(data.table)

    convertNgram <- function (tdm) {
      
       colnames(tdm) <- "freq"
       freq<-row_sums(tdm)
     
       word<-row.names(tdm)
       df<- data.frame(word,freq)
      
  
       return(df)
    }
   uniFreq <-convertNgram(uni.tdm)
   return(uniFreq)
   #rm(corpus, tri.tdm)
  #  gc()

}

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

  return(textInput)
}


nextWordPrediction <- function(df,wordCount,textInput) {
  if (wordCount >= 3) {
    textInput <- textInput[(wordCount - 2):wordCount]
    msg <- 'not searched'
  }
  
  else if (wordCount == 2) {
    textInput <- c(NA,textInput)
    msg <- 'not searched'
  }
  
  else {
    df<-uniFreq
    textInput<-"the"
    textInput <- as.character(textInput)
    sortGrams <- df[order(df$word),]
    userWord <- sortGrams[which(sortGrams$word %like% 'the'),]
    
    sortFreq <- userWord[order(-userWord$freq),]
    wd<-head(sortFreq$word,n=1)
    
    
   biTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
    bi.tdm<- TermDocumentMatrix(corpus, control = list(tokenize =  biTokenizer))
    colnames(bi.tdm) <- "freq"
    freq<-row_sums(bi.tdm)
    
    word<-row.names(bi.tdm)
    df<- data.frame(word,freq)
    sortGrams <- df[order(df$word),]
    userWord <- sortGrams[which(sortGrams$word %like% 'the'),]
    sortFreq <- userWord[order(-userWord$freq),]
    wd<-head(sortFreq$word,n=1)
    
    
  }
  
  
  
  #msg <- textInput
  #a <-paste(wordCount,textInput)
  return(wd)
  
}
