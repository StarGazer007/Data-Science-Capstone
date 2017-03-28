Woracle 
========================================================
font-import: https://fonts.googleapis.com/css?family=Open+Sans
font-family: 'Open Sans'
transition: rotate
css:style.css

Text prediction shiny application created for

    Coursera-Johns Hopkins University 
      Data Science Specialization
      Switftkey Capstone Project 
      
Author: Lisa Rodgers

Date: March 16th, 2017

Woracle Predictions
========================================================
transition: rotate
css:style.css

The aim of this application is to meet the need of a text predictive Shiny application which can predict the users next word with speed and accuracy 
with the emphasise  on the latter. 

<blockquote>"It will not matter how fast the app is, if it is inaccurate."</blockquote>

The algorithm is based on a N-Gram model that was built from
a large corpora supplied by SwiftKey. The material was sourced from Twitter, News and Blogs.

#### Corpora Stats

Total Size  | Total Words
----------- | -----------
28MB        |  4,500,000



Shiny App Interface
========================================================
transition: rotate

Woracle uses a clean minimal user interface (UI) which
access the data compression and predict algorithems working 
in the background.

<image of user interface>

The user enter text into the input box and waits for the next word to be 
predicted. 


Algorithm behind the app
========================================================

Fast and simple, the algorithm is build for accurancy first,
then speed. The average typist types *36WPM*, the algorithm will
work to meet that critiria.

##### Trigam model was utilized.

- accurancy: 60%

- speed: 1 to 2 secs

- memory used: 4MB

- hard disk used: 50MB


Try Woracle Today
========================================================

Demo:[Online](http://www.shinyapps.com)

Source Code:
[GitHub](https://github.com/StarGazer007/Data-Science-Capstone)

