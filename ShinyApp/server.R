library(shiny)
library(RSQLite)

source("helper.R")
#source("lib/compessor.R")
#source("lib/decompressor.R")

setwd("L:/git/Data-Science-Capstone/ShinyApp")

shinyServer(function(input, output){
  

  
  # Trigrams
  afreq<-readRDS("L:/git/Data-Science-Capstone/ShinyApp/data/dictionary.RDS")
  
  
  library(compiler)
  getPrediction.=cmpfun(getPrediction)
  
#output prediction
  output$predicted <- renderText({
    as.character(getPrediction.(input$textIn))
  })
  
})