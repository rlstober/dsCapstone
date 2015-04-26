
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(stringi)
library(stringr)
library(data.table)
library(sqldf)
library(wordcloud)
require(tcltk)

source("./runtimeFunctions.R")
load("./predictTDMdt.RData", .GlobalEnv)
default<-c("Excellent","Impressive","Responsive", "Intuitive","Well-designed","Informative", "Novel", "Well-Done", "Ambitious")
deftin<-"This application is"
defnw<-3
  
shinyServer(function(input, output) {
   

 
  
#defaults

   
output$default<-renderText({input$default})  
    
  output$nw<-renderText({input$nw})
  output$tin<-reactive({
   if (length(input$tin) && sub(" ","",input$tin) == "" ) deftin else input$tin    
  })

  
  output$predict <- renderTable({
    if(is.null(input$nw)==TRUE) sz<-defnw else sz<-input$nw
    cleanPhrase<-cleanText(input$tin)
    if (length(input$tin) && sub(" ","",input$tin) == "" ) cleanPhrase<-cleanText(deftin) 
    cleanPhrase<-cleanText(input$tin)
    output$cleanPhrase<-renderText({cleanPhrase})
    dtIn<-dtInput(cleanPhrase)
    predictOut<-predictOutput(dtIn)
    g1<-as.matrix(predictOut[1:sz,1],dimnames = list(NULL,"Words"))
    if (cleanPhrase==cleanText(deftin) ) g1<-as.matrix(sample(default,sz),dimnames = list(NULL,"Words"))
    return(g1)
   })
  
  
  
  }) # end  shinyServer function