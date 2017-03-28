suppressPackageStartupMessages(c(library(shiny),library(shinythemes)) )

source("prediction.R")


shinyServer(function(input, output) {
  
  wordPrediction <- reactive({
    text <- input$textIn
    textInput <- inputCleaner(text)
    wordCount <- length(textInput)
    wordPrediction <- nextWordPrediction(wordCount,textInput)})
  
  output$predicted <- renderPrint(wordPrediction())
  #output$sentence <- renderText({input$textIn}, quoted = FALSE)
})