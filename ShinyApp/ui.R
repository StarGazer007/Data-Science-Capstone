library(shiny)

# Define UI for application that draws a histogram
shinyUI( fluidPage(
            theme ="slate.css",
            style ="overflow: hidden;",
  
            # Top Bar
            fluidRow( 
              style =  "display: block;
                       position: relative;
                       overflow: hidden;
                       #background-color: #275494; 
                       
                       background-image: url('top.png');

                       height: auto; 
                       min-height: 200px;
                       padding:0;
                       border-bottom:3px solid #16222D;",
      
              column(1, img(src = "quicktype.png", 
                          
                            style = "display:block;
                                     clear:both;
                                     height: 220px;
                                     overflow:hidden;
                                     padding:10px;"
                           )
                    ),
      
              column(10, tags$h1(style="font-size:68px;
                                   padding-top: 50px;
                                   color:#78ACC4;
                                   text-align:center; ", 
                                  "Text Prediction"
                            )
                     
                     ),
      
              column(1, tags$a(target="_blank", href="https://github.com/StarGazer007/Data-Science-Capstone.git", 
                        tags$img(src = "github-ribbon.png", 
                                 style="display:block;
                                        position: absolute;
                                        right:0;
                                        height:250px;
                                        overflow:hidden;
                                        clear:both;", 
                                    align="right"
                                )
                            )
                   )),
            
            # User Input
            fluidRow(
                      style = "display: block; 
                               margin:2% 0;
                               ",
                      column(12,
                             style = "display: block; 
                                      margin:0 25%; 
                                      clear: both;",

                             textInput("textIn", label = h3("Enter a sentence:", value = "", style="font-size:44px;"),  width = "50%"),
                             helpText("Type in a sentence above")
                         
                      )),
            # System Prediction
            fluidRow(
                     
                     column(12,
                            tags$h2("The next word could be",align="center",
                                                        style="font-size:65px"),
                           
                            #h2(textOutput("sentence"), align="center",
                                                      # style="font-size:65px;color:aqua;"),
                            
                            actionButton("action", label = "Action"),
                          
                            tags$h2(textOutput("predicted"), align="center", 
                                                        style="display:block;
                                                               margin:0 auto;
                                                               color:white;
                                                               padding: 15px;
                                                               width: 250px;
                                                               height: 100px;
                                                               background-color:#78acc4; 
                                                               font-size:46px; ")
                      
                     )       
                   
            ),
            tags$footer( style="width:100%;",
              fluidRow(
              style="position: absolute;
                     bottom: 0;
                     width:100%;
                     overflow: hidden;
                     background-color: #16222d;
                     height: 95px;",
              column(6,
                     a(target="_blank", href="https://swiftkey.com", 
                       img(src = "swift-key.png",
                           style = "opacity:0.45;width:180px;padding:0 15px;") ),
                     a(target="_blank", href="https://www.coursera.org/", 
                       img(src = "coursera.png",
                           style = "opacity:0.45;width:170px;padding:0 15px;") ),
                     a(target="_blank", href="https://www.jhu.edu/", 
                       img(src = "johnshopkins.png",
                           style = "opacity:0.45;width:160px;padding:0 15px;") )
                     ),
              column(5,
                     style = " 
                              position:relative; 
                              height:98%;
                              padding-top:10px;
                              margin: 0 auto;
                              #background-color:black;",
                     
                     tags$ol(
                      style="
                            float:right;
                            list-style-type: none;
                            margin: 20px;
                            padding: 0 15px;",
                      tags$li(icon("facebook", "fa-3x"),style="display: inline;padding:5px; color:#2B3E50;"), 
                      tags$li(icon("twitter", "fa-3x"),style="display: inline;padding:5px;color:#2B3E50;"), 
                      tags$li(icon("linkedin", "fa-3x"),style="display: inline;padding:5px;color:#2B3E50;"),
                      tags$li(icon("google-plus-official", "fa-3x"),style="display: inline;padding:5px;color:#2B3E50;"),
                      tags$li(icon("instagram", "fa-3x"),style="display: inline;padding:5px;color:#2B3E50;")
                     )
                     ),
              
              column(1,
              style="
                     padding:0;",
              a(target="_blank", href="http://lisa.rodgers.space/", 
                img(src = "author.png",
                    style = "width:120px;padding:0 15px;") )
              )
              )
            )
  )
  
  )