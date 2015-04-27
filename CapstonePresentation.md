John Hopkins Data Science Specialization 
========================================================
## Capstone Project

author: Robert Stober

date: 4/18/2015


Predict Words
========================================================
* New Shiny Application is a great teaching tool 
* Use it to demonstrate
  + Principles Natural Language Processing (NLP)
  + Shiny Application Development
  + R Programming


How it Works: The Application
=======================================================
* Enter number of words to be predicted
  + default is 1
* Enter a Phrase
  + default is 'This application is'
* Click the Predict button to predict the next word in the phrase
* Best guess, and if selected, additional likely words are displayed


How it Works: The Algorithm
========================================================
* Bag of Word Algorithm with Stupid Back Off Model
  + Kneser-Ney Smoothing of Unigrams
* Pre-processing
  + Convert to lower case, Remove punctuation and stop words
* Build Unigram, Bigram Trigram and 4-gram Frequency Matrices
  + Remove sparse terms
* Subset Train and Test
  + Determine Based on accuracy against test set


Try it Out
========================================================
[Click Here to Try the Predict Words Application](http://rlstober.shinyapps.io/PredictWords/)|
------------- |
![Predict words](Capture.png)|

