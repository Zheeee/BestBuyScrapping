setwd("~/Documents/R/BCR/WebScraping")
library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)
library(stringr)
library(wordcloud)
library(SnowballC)
library(tm)
library(wordcloud2)
library(plotly)

# import data
reviews = read.csv('./data/reviews.csv', stringsAsFactors = F)
price = read.csv("./data/price.csv", stringsAsFactors = F)
price = price %>% 
  mutate(., rank = as.numeric(rownames(.))) 

# join reviews and price
reviews_price = reviews %>% 
  left_join(., price, by = "proc_name") %>% 
  arrange(., rank) %>% 
  na.omit(.) %>% 
  mutate(., index = as.integer(rownames(.)))

# create duplicate rows based on laptops' features
temp = reviews_price %>% 
  select(., proc_name, index) %>% 
  mutate(., features = sapply(proc_name, function(x) unlist(strsplit(x, split = " - | – | / |- ")))) %>% 
  mutate(., freq = sapply(features, function(x) length(x)))
temp_expand = temp[rep(rownames(temp), temp$freq), 1:3]
temp_ = temp_expand %>% 
  mutate(., pos = rownames(.)) %>% 
  mutate(., pos_ = mapply(function(x, y) ifelse(any(grep('\\.', x) > 0), 
                                                as.integer(strsplit(x, split = '\\.')[[1]][1]) - y + 1 + as.integer(strsplit(x, split = '\\.')[[1]][2]),
                                                as.integer(x) - y + 1),
                          pos, index)) %>% 
  mutate(., num_row = as.integer(rownames(.))) %>% 
  mutate(., features = mapply(function(y, z) features[y][[1]][z], num_row, pos_)) %>% 
  select(., index, features)

# adjust display
temp_$features = gsub('”', '\\"', temp_$features)
disp_size = str_extract(temp_$features, '[1-9]+\\.?[1-9]?\\"')
disp_size = str_extract(disp_size, '[1-9]+\\.?[1-9]?')

# adjust cpu
temp_$features = gsub('Intel Core m3', 'Intel Core M3', temp_$features)
temp_$features = gsub('Intel® Core™ i5', 'Intel Core i5', temp_$features)

# adjust memory
temp_$features = gsub('8 GB Memory', '8GB Memory', temp_$features)
temp_ = temp_ %>% 
  mutate(., features = mapply(function(x,y) ifelse(is.na(y) == T, x, y), features, disp_size))

# merge reviews_price and temp
feature_dup = reviews_price %>% 
  inner_join(., temp_, by = 'index') %>% 
  filter(., help_ >= unhelp_) %>%
  mutate(., my_score = score * (help_ / (help_ + unhelp_))) %>%
  filter(., my_score != 0)

# adjust recommand percent
feature_dup$percent = gsub('%', '', feature_dup$percent)
feature_dup$percent = as.numeric(feature_dup$percent)

# company name
brands_name =  '"Asus"      "Apple"     "HP"        "Dell"      "Lenovo"    "Samsung"   "Microsoft" "Acer"      "Alienware"  "MSI"  "Google" "Razer"'
brands_name = gsub('\\"', '', brands_name)
brands_name = strsplit(brands_name, split = ' +')[[1]]

company = feature_dup %>% 
  filter(., features %in% brands_name)

# laptops which has price as cons
expensive = company %>% 
  filter(., grepl('price', cons)) %>% 
  filter(., price_off == 'regular')

# All pros freq
text = company$pros
test = trimws(text)
myCorpus = Corpus(VectorSource(test))
myCorpus = tm_map(myCorpus, content_transformer(tolower))
myCorpus = tm_map(myCorpus, removePunctuation)
myCorpus = tm_map(myCorpus, removeNumbers)
myCorpus = tm_map(myCorpus, removeWords, c(stopwords("english"), 'use', 'value', 'touch', 'easy', 'set', 'screen', 'lightweight'))
dtm <- TermDocumentMatrix(myCorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
all_pros <- data.frame(word = names(v),freq=v) %>% 
  filter(., freq >= 130)

# All cons freq
text = company$cons
test = trimws(text)
myCorpus = Corpus(VectorSource(test))
myCorpus = tm_map(myCorpus, content_transformer(tolower))
myCorpus = tm_map(myCorpus, removePunctuation)
myCorpus = tm_map(myCorpus, removeNumbers)
myCorpus = tm_map(myCorpus, removeWords, c(stopwords("english"), 'touch', 'hard', 'modes', 'mode', 'sleep', 'update'))
dtm <- TermDocumentMatrix(myCorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
all_cons <- data.frame(word = names(v),freq=v) %>% 
  filter(., freq >= 550)
