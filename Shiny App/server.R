library(shiny)
library(RSQLite)

source("helper.R")


shinyServer(function(input, output){
  
  getPrediction<- function(w){
    
    # transform as training set was (lowercase, stem, strip punctuation etc.)
    w<-iconv(w, to='ASCII', sub=' ')
    w<-process(w)
    w<-paste0(w, collapse=" ")
    
  }
  
  # Trigrams
  #afreq=readRDS("allfreq.RDS")
  
#output prediction
  output$predicted <- renderText({
    as.character(getPrediction.(input$textIn))
  })
  
})