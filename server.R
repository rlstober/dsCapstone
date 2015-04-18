
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
default<-c("Excellent","Wonderful","Marvelous", "Intuitive","Amusing")
load("./data/englishStop.RData")
load("./data/uniTDMfreq.RData")
deftin<-"This application is"
defnw<-3
  
  shinyServer(function(input, output) {
   
  
  
  output$resetable_input <- renderUI({
    times <- input$reset_input
    list(
      h4('The application will attempt to predict the next word to be typed'),
      br(),
      
      radioButtons("nw", label = h4("Set the Number of Single Word Predictions"),
                   choices = list("One" = 1, "Three" = 3,
                                  "Five" = 5),selected = 3),  
      textInput('tin',
                label=h4('Enter an incomplete phrase below'),
                value = "This application is"),
      h4('Hit the Predict button to update the prediction or Reset to start over')
    ) # end list
  })
  
  output$nw<-renderPrint({input$nw})
  #output$tin<-renderPrint({input$tin})
  output$tin<-reactive({
   if (length(input$tin) && sub(" ","",input$tin) == "" ) deftin else input$tin    
  })
  
  
  output$predict <- renderTable({
    if(is.null(input$nw)==TRUE) sz<-defnw else sz<-input$nw
    g1<-as.matrix(sample(default,sz),dimanes = list(NULL,"Words"))
    # add stop word
    #if (sz!=1) g1<-rbind(g1,(sample(englishStop,1)))
  })
  
  
  })

