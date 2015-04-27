
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#
rm(list=ls()); gc()
library(shiny)
library(stringi)
library(stringr)
library(data.table)
library(sqldf)
library(wordcloud)
require(tcltk)

source("./runtimeFunctions.R")
load("./predictTDMdt.RData", .GlobalEnv)


#default prediction
default<-c("Excellent","Impressive","Responsive", "Intuitive","Well-designed","Informative", "Novel", "Well-Done", "Ambitious")
defaultR<-runif(length(default))
#default text input
deftin<-"This application is"
# number of words
defnw<-1

  
shinyServer(function(input, output) {
   
 
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
    predictResultTableSum<-predictOutput(dtIn)
    wordcloud_rep<-repeatable(wordcloud)
    output$cloud<-renderPlot(wordcloud_rep(default,defaultR, scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2")))
    if (cleanPhrase!=cleanText(deftin) ) output$cloud<- renderPlot(wordcloud_rep(predictResultTableSum$w,predictResultTableSum$Probability,max.words = 20, scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2")))
    predictResult<-sqldf("select w, Probability from predictResultTableSum order by Probability DESC limit 5")
    g1<-as.matrix(predictResult[1:sz,1])
    if (cleanPhrase==cleanText(deftin) ) g1<-as.matrix(sample(default,sz))
    dimnames(g1)<-list(NULL, "Words")
    return(g1)
   })
  
 




env <- environment()  # can use globalenv(), parent.frame(), etc
output$env <- renderTable({
  data.frame(
    object = ls(env),
    size = unlist(lapply(ls(env), function(x) {
      object.size(get(x, envir = env, inherits = FALSE))
    }))
  )
})
  
  }) # end  shinyServer function