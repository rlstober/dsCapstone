# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

cat(sprintf("Total memory=%.2f MB\n", memory.size()))

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  div(titlePanel("Predict Words"), style = "color:blue"),
  #titlePanel("Text Predicition"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    #verbiage
    h4('The application will attempt to predict the next word in the phrase'),
    helpText("Instructions:"),
    helpText("1 Type in a phrase"),
    helpText("2. Select the number of words or guesses to return. You can select one, three or five, words"),  
    helpText("3. Click the Predict Button"),
    #uiOutput('resetable_input'),
    textInput('tin',
              label=h4('Phrase'),
              value = "This application is"),
    
    radioButtons("nw", label = h4("Words"),choices = list("One" = 1, "Three" = 3, "Five" = 5),selected = 3),
    submitButton(text = "Make Prediction", icon = icon("question",  lib = "font-awesome")),
   br(),
   h4('This application was built with Rstudio and Shiny'),
   img(src="RStudio-Ball.png", height = 30, width = 30)
    
    
  ),
    
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(type = "tabs", 
      tabPanel("Prediction",
        h4('This application demonstrates text prediction'),
        h4('Text prediction is an example of Natural Language processing or NLP'),
        br(),   
        fluidRow(
          column(7,h4('The number of words to predict is')),
          column(5,verbatimTextOutput("nw"))
          ),
        fluidRow(
          column(7,h4('Your incomplete phrase is')),
          column(5,verbatimTextOutput("tin"))
        ),
        fluidRow(
          column(7,h4('The cleaned phrase is')),
          column(5,verbatimTextOutput("cleanPhrase"))
        ),

       h4('My guess is '),
       tableOutput("predict") 
        ), # end predict tab
      tabPanel("Help",
               h4('This application demonstrates text prediction'),
               h4('Text prediction is an example of Natural Language processing or NLP'),
               br()   
               ) #end help tab
      ) # end tab panel
  )
))
