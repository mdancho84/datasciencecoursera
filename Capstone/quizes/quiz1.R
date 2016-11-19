# Capstone - Swiftkey - Quiz 1

# Libraries
library(tidyverse) # ggplot, tidyr, dplyr, purrr, tibble, readr
library(stringr)


# Collect data
con <- file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r")
blogs <- readLines(con)
close(con)

con <- file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r")
news <- readLines(con)
close(con)

con <- file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r")
twitter <- readLines(con)
close(con)


# 1. The blogs file is how many megabytes?
file.info("Coursera-SwiftKey/final/en_US/en_US.blogs.txt")

# 2. The twitter file has how many lines of text?
twitter %>% length()

# 3. What is the length of the longest line seen in any of the three US data sets?
blogs %>%
    lapply(str_length) %>% 
    unlist() %>% 
    max()
news %>%
    lapply(str_length) %>% 
    unlist() %>% 
    max()
twitter %>%
    lapply(str_length) %>% 
    unlist() %>% 
    max()

# 4. twitter: divide number of lines "love" appears by number of lines "hate"
# appears.
love_count <- twitter %>%
    str_detect("love") %>%
    sum()
hate_count <- twitter %>%
    str_detect("hate") %>%
    sum()
love_count / hate_count

# 5. The one tweet in the twitter data set that matches the word "biostats" says what?
twitter[str_detect(twitter, "biostats")]
    
# 6. How many tweets have the exact characters "A computer once beat me at chess, 
# but it was no match for me at kickboxing".
phrase <- "A computer once beat me at chess, but it was no match for me at kickboxing"
twitter %>%
    str_detect(phrase) %>%
    sum()