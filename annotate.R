# rm(list=ls()); gc()
library(NLP)
library(tm)
library(RWeka)
library(SnowballC)
library(ggplot2)
library(slam)



#File names
blogSave<-"./data/blogs.RData"
twitterSave<-"./data/twitter.RData"
newsSave<-"./data/news.RData"

load(blogSave)
load(twitterSave)
load(newsSave)


## Need sentence and word token annotations.
require("NLP")
Maxent_Chunk_Annotator(language = "en", probs = FALSE, model = NULL)

sent_token_annotator <- Maxent_Sent_Token_Annotator(s) {
  stri_split_boundaries(s, type="sentence")
}
word_token_annotator <- Maxent_Word_Token_Annotator()

a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))
pos_tag_annotator <- Maxent_POS_Tag_Annotator()
pos_tag_annotator
a3 <- annotate(s, pos_tag_annotator, a2)
a3
## Variant with POS tag probabilities as (additional) features.
head(annotate(s, Maxent_POS_Tag_Annotator(probs = TRUE), a2))






s <- String("  First sentence.  Second sentence.  ")
##           ****5****0****5****0****5****0****5**

## A very trivial sentence tokenizer.
sent_tokenizer <-
  function(s) {
    s <- as.String(s)
    m <- gregexpr("[^[:space:]][^.]*\\.", s)[[1L]]
    Span(m, m + attr(m, "match.length") - 1L)
  }
## (Could also use Regexp_Tokenizer() with the above regexp pattern.)
sent_tokenizer(s)
stri_locate_all_boundaries(s)

stri_split_boundaries(s, type="sentence")
stri_split_boundaries(s, type="sentence", skip_sentence_sep=TRUE,simplify=TRUE,tokens_only =TRUE)
    
##           ****5****0****5****0****5****0****5**

## A very trivial sentence tokenizer.
s <- String("  First sentence.  Second sentence.  ")
sent_tokenizer <-
  function(s) {
    s <- as.String(s)
    m <- gregexpr("[^[:space:]][^.]*\\.", s)[[1L]]
    Span(m, m + attr(m, "match.length") - 1L)
  }

sent_tokenizer <-
  function(s) {stri_split_boundaries(s, type="sentence")
  }

## (Could also use Regexp_Tokenizer() with the above regexp pattern.)
sent_tokenizer(s)
## A simple sentence token annotator based on the sentence tokenizer.
sent_token_annotator <- Simple_Sent_Token_Annotator(sent_tokenizer)
(sent_token_annotator)
a1 <- annotate(s, sent_token_annotator)
a1
## Extract the sentence tokens.
s[a1]