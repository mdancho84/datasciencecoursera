

# Prerequisites ------
library(tidyverse) # ggplot, tidyr, dplyr, purrr, tibble, readr
library(tidytext) # http://tidytextmining.com/
library(stringr)
library(forcats)

data(stop_words) # words that are common in english language

# Collect data -------
con <- file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r")
blogs <- readLines(con)
close(con)

con <- file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r")
news <- readLines(con)
close(con)

con <- file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r")
twitter <- readLines(con)
close(con)

# Tidy data -------
blogs_df <- tibble(line = 1:length(blogs), text = blogs)
news_df <- tibble(line = 1:length(news), text = news)
twitter_df <- tibble(line = 1:length(twitter), text = twitter)

blogs_unigram <- blogs_df %>%
    unnest_tokens(word, text) 

blogs_bigram <- blogs_df %>% 
    unnest_tokens(bigram, text, token = "ngrams", n = 2)


