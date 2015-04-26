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
   hr() ,
   fluidRow(
     column(8,h6('Contact Me')),
     column(4,a(img(src="gmail.png", height = 30, width = 30), href="mailto:bob.stober@gmail.com"))
    ),
   fluidRow(
     column(8, h6('Bob Stober at Linked In')),
     column(4,a(img(src="linkedin-sociocon.png", height = 30, width = 30), href="https://www.linkedin.com/in/bobstober"))
   )
   ,
   fluidRow(
     column(8,h6('This application was built with Rstudio and Shiny')),
     column(4,a(img(src="RStudio-Ball.png", height = 30, width = 30), href="http://www.rstudio.com/"))
   )
   #h6('This application was built with Rstudio and Shiny'),
   #a(img(src="RStudio-Ball.png", height = 30, width = 30)),
#    h6('Bob Stober at Linked In'),
#    a(img(src="RStudio-Ball.png", height = 30, width = 30), href="https://www.linkedin.com/in/bobstober")
        
  ), # end of side panel
    
  # Main
  mainPanel(
    tabsetPanel(type = "tabs", 
      tabPanel("Prediction",
        h4('This application demonstrates text prediction.Text prediction is an example of Natural Language processing or NLP'),
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

        fluidRow(
          column(7,h4("Thinking about some words...")),
          column(5,h4('My guess is '))
        ),
        
          fluidRow(
            column(7,a(img(src = "cloud0.png")) ),
            #column(7,imageOutput("cloud")),
            column(5,br(),br(),tableOutput("predict"))
        )
        
#       h4('Thinking about some words '),
#       plotOutput("Cloud"),
#       h4('My guess is '),
#       tableOutput("predict") 
        ), # end predict tab
      tabPanel("Help",
               
               h4('Explanation'),
               h5('Type in the phrase for which the application will predict the next word.
                    You can think of what of your own, or copy and paste a pharse from the news or twitter
                    On the main panel you will see the original phrase and the cleaned up phrase as well. 
                    Notice the start token that is used to represent the beginning oof the sentence.
                    '),
               hr(),
               h5('You can select the number of words to return. The choices are One, Thre or five.
                  When seekcting one word the single best choice is returned. If two words happen to have the exact same probablity
                  the one that comes first aplhabetically will be returned.
                  You can further the range of returned words and see some of the other top choices available. This is more reflective of an keyboard
                  application, where a few words may be presented from which to choose.
                  choose.'),
               hr(),
               h5('The predicted words appear as a grid. They are ranked by probability. 
                  A word cloud image is presented fror illustrative purposes.
                  '),
               hr(),
               h5('For more information on the modeling process, check out the Modeling tab.')
              
               ), #end help tab
      tabPanel("Modeling",
         h4('The modeling process steps:'),
         helpText("1. Download Files and Extract from Archive"),
         helpText("2. Read Files In"),
         helpText("3. Clean Data and Save as RData Files"),
         helpText("4. Create Sample Data and Save as RData Files"),
         helpText("5. Build N-Gram Frequency Tables and Save as RData Files"),
         helpText("6. Build Predictive Data Table and Save as RData File"),
         helpText("7. Split Predictive Data Table into Train and Test"),
         helpText("8. Build Predicitve Frequency Models from Train"),
         helpText("9. Evaluate Accuracy Against Test"),
         helpText("10. If Accuracy is NOT Satisfacory, Go back to Previous Step"),
         helpText("11. If Accuracy is NOT Satisfacory, Save Predictive Data Table for use in Application"),
         
         br()   
), #end help tab
      tabPanel("RunTime",
               h4('RunTime Environment'),
               br() ,
               tableOutput('env')
      ) #end Runtime tab
  ) # end tab panel
  )
))
