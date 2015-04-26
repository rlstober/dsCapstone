#shinyFragments




#   output$resetable_input <- renderUI({
#     times <- input$reset_input
#     list(
#       h4('The application will attempt to predict the next word to be typed'),
#       br(),
#       
#       radioButtons("nw", label = h4("Set the Number of Single Word Predictions"),
#                    choices = list("One" = 1, "Three" = 3,
#                                   "Five" = 5),selected = 3),  
#       textInput('tin',
#                 label=h4('Enter an incomplete phrase below'),
#                 value = "This application is"),
#       h4('Hit the Predict button to update the prediction or Reset to start over')
#     ) # end list
#   })
#   


# output$nw<-renderText({
#   if (is.null(input$nw) ==TRUE) defnw else input$nw
# }) 
# output$tin<-renderText({
#   #if (length(input$tin) && sub(" ","",input$tin) == "" ) deftin else input$tin 
#   if (is.null(input$tin) ==TRUE) deftin else input$tin 
# }) 
# output$nw<-renderText({
#   if (is.null(input$nw) ==TRUE) defnw else input$nw
# }) 
# 
# 
# output$cleanPhrase<-renderText({
#  if (is.null(input$tin) ==TRUE) cleanText(deftin) else cleanText(input$tin)
#  })



#actionButton("predictButton", label = "Predict", icon = icon("question",  lib = "font-awesome")),
#actionButton("reset_input", label = "Reset", icon = icon("refresh",  lib = "font-awesome")),



output$predict <- renderTable({
  if(is.null(input$nw)==TRUE) sz<-defnw else sz<-input$nw
  #run default
  if (input$default == "Reset") {
    defUI1<-defUI
    g1<-as.matrix(sample(default,sz),dimnames = list(NULL,"Words"))
    return(g1)
  }
  #     # run predict
  
  if (input$default == "Predict") { 
    cleanPhrase<-cleanText(input$tin)
    dtIn<-dtInput(cleanPhrase)
    predictOut<-predictOutput(dtIn)
    g1<-as.matrix(predictOut[1:sz,1],dimnames = list(NULL,"Words"))
  }
})


#         h4('The number of words to predict is'),
#         verbatimTextOutput("nw"),
# 
#         h4('Your incomplete phrase is'),
#         verbatimTextOutput("tin"),
br(),
h4('The cleaned phrase is '),
verbatimTextOutput("cleanPhrase") ,