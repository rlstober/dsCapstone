
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
default<-c("Excellent","Wonderful","Marvelous", "Intuitive","Amusing")
load("./data/englishStop.RData")
deftxt<-"This application is"
  
  shinyServer(function(input, output) {
   
  output$nw<-renderPrint({input$nw})
  output$tin<-renderPrint({input$tin})
#   if (length(input$tin) == 0 )
#     output$tin= renderPrint({deftxt})
#     else output$tin<-renderPrint({input$tin})
  
  #g1<-sample(default,1)
  #output$predict <- renderPrint({sample(default,1)})
#   output$predict <- renderTable({
#     output$nw<-renderPrint(input$nw)
#     output$tin<-renderPrint(input$tin)
#     #
#     g1<-as.matrix(sample(default,input$nw-1),dimanes = list(NULL,"Words"))
#     # add stop word
#     g1<-rbind(g1,(sample(englishStop,1)))

  })
    
 # })

