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


# wordcloud_rep <- repeatable(wordcloud)
# output$Cloud<-renderPlot({
#   defaultR<-runif(length(default))
#   wordcloud_rep(default,defaultR, max.words = length(default), scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2"))
# })  
# 
# output$Cloud<-renderPlot({
#   wordcloud_rep(predictResultTableSum$w,predictResultTableSum$Probability,max.words = 20, scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2"))
# })  




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


# wordcloud_rep <- repeatable(wordcloud)
# output$Cloud<-reactive({
#   if (cleanPhrase==cleanText(deftin) ) { 
#   defaultR<-runif(length(default))
#   renderPlot<-wordcloud_rep(default,defaultR, max.words = length(default), scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2"))
#   } else renderPlot<-wordcloud_rep(predictResultTableSum$w,predictResultTableSum$Probability,max.words = 20, scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2"))
#   } )
#   


# wordcloud_rep <- repeatable(wordcloud)
# output$Cloud<-renderPlot({
#     defaultR<-runif(length(default))
#     wordcloud_rep(default,defaultR, max.words = length(default), scale=c(3.5,0.2), colors=brewer.pal(4,"Dark2"))
# 
# })


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