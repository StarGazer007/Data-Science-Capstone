library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme ="slate.css",
  
  # Application title
  fluidRow( 
    style = "background-color: #000; height: 200px; padding: 20px;",
   
    column(3, img(src = "logo.svg", height = 100, width = "100px")),
    
    column(5, h1(style="font-size:68px;color:white;", "Woracle"))
    
    ),
  
  fluidRow(
    style = "height: 250px;padding:25px;",
    column(3),
    
   column(5,
          br(),
          textInput("textIn", label = h3("Enter a sentence:", style="font-size:44px;"),  value = "happy birthday to",  width = "100%"),
          helpText("Type in a sentence above, hit enter (or press the button below).")
          
          
          )
   
    
    
  ),
  fluidRow(
    style = "height: 500px;",
    column(3),
    
    column(5,
           h2(textOutput("sentence"), align="center"),
           h1(textOutput("predicted"), align="center", style="color:black"),
           hr(),
           h3("Top 5 Possibilities:", align="center"),
           div(tableOutput("alts"), align="center")  
           
           )
  ),
  
  fluidRow(
    style = "background-color: #000; height: 50px;",
    column(4, 
           offset = 8,
           p(style="font-size:14px;color:white;font-weight:bold;", "powered by Shiny", align="center")
           
           
           
           )
    
  )

  )
  )