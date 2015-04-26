
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
# library(wordcloud)
# require(tcltk)

source("./runtimeFunctions.R")
load("./predictTDMdt.RData", .GlobalEnv)

#default prediction
default<-c("Excellent","Impressive","Responsive", "Intuitive","Well-designed","Informative", "Novel", "Well-Done", "Ambitious")
#default text input
deftin<-"This application is"
# number of words
defnw<-3
# wordcloud image number
nc<<-0
  
shinyServer(function(input, output) {
   

  
#defaults

   
output$default<-renderText({input$default})  
    
  output$nw<-renderText({input$nw})
  output$tin<-reactive({
   if (length(input$tin) && sub(" ","",input$tin) == "" ) deftin else input$tin    
  })




  output$predict <- renderTable({
    nc<-2
    if(is.null(input$nw)==TRUE) sz<-defnw else sz<-input$nw
    cleanPhrase<-cleanText(input$tin)
    if (length(input$tin) && sub(" ","",input$tin) == "" ) cleanPhrase<-cleanText(deftin) 
    cleanPhrase<-cleanText(input$tin)
    output$cleanPhrase<-renderText({cleanPhrase})
    dtIn<-dtInput(cleanPhrase)
    predictResultTableSum<-predictOutput(dtIn)
    predictResult<-sqldf("select w, Probability from predictResultTableSum order by Probability DESC limit 5")
    g1<-as.matrix(predictResult[1:sz,1])
    if (cleanPhrase==cleanText(deftin) ) g1<-as.matrix(sample(default,sz))
    dimnames(g1)<-list(NULL, "Words")
    return(g1)
   })
  
 


  # Send a pre-rendered image, and don't delete the image after sending it
#   output$cloud <- renderImage({
#     # When input$n is 1, filename is ./images/image1.jpeg
#     # add 1 to image number each time range 0 -3
#     if (nc==3) nc<<-0 else nc<<- nc+1
#     #if start use image 0
#     if (deftin == input$tin) nc<<-0
#     filename <- normalizePath(file.path('./www',
#                               paste('cloud', nc, '.png', sep='')))
# 
#     # Return a list containing the filename
#     list(src = filename)
#   }, deleteFile = FALSE)







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