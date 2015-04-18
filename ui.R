
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  div(titlePanel("Text Predicition"), style = "color:blue"),
  #titlePanel("Text Predicition"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    h4('The application will attempt to predict the next word to be typed'),
    br(),
    
    radioButtons("nw", label = h4("Set the Number of Single Word Predictions"),
                 choices = list("One" = 1, "Three" = 3,
                             "Five" = 5),selected = 5),  
    textInput('tin',
                label=h4('Enter an incomplete phrase below'),
                value = "This application is"),
    h4('Hit the Predict button to update the prediction or Reset to start over'), 
    actionButton("predict", label = "Predict", icon = icon("question",  lib = "font-awesome")),
    actionButton("reset", label = "Reset", icon = icon("refresh",  lib = "font-awesome")),
    #submitButton(text = "Make Prediciton"),
   br(),
   h4('This application was built with Rstudio and Shiny'),
   img(src="RStudio-Ball.png", height = 30, width = 30)
    
    
  ),
    
  
  # Show a plot of the generated distribution
  mainPanel(
    h4('This application demonstrates text prediction'),
    h4('Text prediction is an example of Natural Language processing or NLP'),
    br(),   
    helpText("This application demonstrates text predicition."),
    
    
    h4('The number of words to predict is'),
    verbatimTextOutput("nw"),
    h4('Your incomplete phrase is'),
    verbatimTextOutput("tin"),
    br(),
    h4('My guess is '),
    #verbatimTextOutput("predict")   
    tableOutput("predict")  

  )
))
