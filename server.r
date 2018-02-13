function(input, output, session) { 
  observe({
    price = company$price[company$features == input$brands]
    updateSliderInput(
      session, 'sel_price',
      min = min(price), max = max(price),
      value = c(min(price), max(price))
    )
  })
  
  observe({
    score = round(company$my_score[company$features == input$brands], 1)
    updateSliderInput(
      session, 'sel_score',
      min = min(score), max = max(score),
      value = c(min(score), max(score))
    )
  })
  
  observe({
    cho = company[company$features == input$brands,]
    if (input$price_score == T) {
      change = cho$proc_name[(cho$my_score >= input$sel_score[1]) & (cho$my_score <= input$sel_score[2])]
    } else {
      change = cho$proc_name[(cho$price >= input$sel_price[1]) & (cho$price <= input$sel_price[2])]
    }
    
    updateSelectizeInput(
      session, 'proc',
      choices = change, selected = change[1]
    )
  })
  
  features = reactive({
    if (input$features == 'Brands') {
      return(
        feature_dup %>% 
          filter(., features %in% brands_name))
    } else if (input$features == 'CPU') {
      return(
        feature_dup %>%
          filter(., !grepl('Drive', features)) %>%
          filter(., grepl('Intel', features)))
    } else if (input$features == 'Memory') {
      return(
        feature_dup %>% 
          filter(., grepl('Memory', features))
      )
    } else {
      return(
        feature_dup %>% 
          filter(., grepl('Drive', features))
      )
    }
  })
  
  brands_cons = reactive({
    text = company$cons[company$features == input$brands]
    test = trimws(text)
    myCorpus = Corpus(VectorSource(test))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    brands_cons <- data.frame(word = names(v),freq=v)
  })
  
  brands_pros = reactive({
    text = company$pros[company$features == input$brands]
    test = trimws(text)
    myCorpus = Corpus(VectorSource(test))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    brands_pros <- data.frame(word = names(v),freq=v)
  })
  
  brands_titles = reactive({
    text = company$title[company$features == input$brands]
    test = trimws(text)
    myCorpus = Corpus(VectorSource(test))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords, c(stopwords("english"), 'Laptop', 'laptop', 'computer', 'Great', 'great'))
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    brands_titles <- data.frame(word = names(v),freq=v)
  })
  
  stat = reactive({
    company %>% 
      filter(., features == input$brands) %>% 
      select(., price, percent, my_score)
  })
  
  proc_cons = reactive({
    text = company$cons[company$proc_name == input$proc]
    test = trimws(text)
    myCorpus = Corpus(VectorSource(test))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    proc_cons <- data.frame(word = names(v),freq=v)
  })
  
  proc_pros = reactive({
    text = company$pros[company$proc_name == input$proc]
    test = trimws(text)
    myCorpus = Corpus(VectorSource(test))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    proc_pros <- data.frame(word = names(v),freq=v)
  })
  
  proc_titles = reactive({
    text = company$title[company$proc_name == input$proc]
    test = trimws(text)
    myCorpus = Corpus(VectorSource(test))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords, c(stopwords("english"), 'Laptop', 'laptop', 'computer', 'Great', 'great'))
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    proc_titles <- data.frame(word = names(v),freq=v)
  })
  
  stat_proc = reactive({
    company %>% 
      filter(., proc_name == input$proc) %>% 
      select(., price, percent, my_score)
  })
  
  observe({
    price = company$price[company$features == input$cp1]
    updateSliderInput(
      session, 'price_1',
      min = min(price), max = max(price),
      value = c(min(price), max(price))
    )
  })
  
  observe({
    price = company$price[company$features == input$cp2]
    updateSliderInput(
      session, 'price_2',
      min = min(price), max = max(price),
      value = c(min(price), max(price))
    )
  })
  
  price_dep1 = reactive({
    company %>% 
      filter(., (price >= input$price_1[1]) & (price <= input$price_1[2])) %>% 
      filter(., features == input$cp1) %>% 
      select(., proc_name, price, percent, review_num, my_score, rank)
  })
  
  price_dep2 = reactive({
    company %>% 
      filter(., (price >= input$price_2[1]) & (price <= input$price_2[2])) %>% 
      filter(., features == input$cp2) %>% 
      select(., proc_name, price, percent, review_num, my_score, rank)
  })
  
  output$bar = renderPlot({
    ggplot(data = features(), aes(x = features)) +
      geom_bar() + ggtitle('Barplot')
  })
  
  rec_dep1 = reactive({
    temp = company %>% 
      filter(., (price >= input$sel_pros[1]) & (price <= input$sel_pros[2]))
    if (length(input$rec_pros) == 0) {
      temp %>% 
        filter(., grepl('ease', pros)) %>% 
        select(., proc_name, price, percent, review_num, my_score, rank)
    } else {
      temp %>% 
        filter(., as.logical(apply(sapply(input$rec_pros, function(x) grepl(x, temp$pros)), 1, prod))) %>% 
        select(., proc_name, price, percent, review_num, my_score, rank)
    }
  })
  
  rec_dep2 = reactive({
    temp = company %>% 
      filter(., (price >= input$sel_cons[1]) & (price <= input$sel_cons[2]))
    if (length(input$rec_cons) == 0) {
      temp %>% 
        filter(., grepl('noise', cons)) %>% 
        select(., proc_name, price, percent, review_num, my_score, rank)
    } else {
      temp %>% 
        filter(., as.logical(apply(sapply(input$rec_cons, function(x) grepl(x, temp$cons)), 1, prod))) %>% 
        select(., proc_name, price, percent, review_num, my_score, rank)
    }
  })
  
  output$my_score = renderPlot({
    if (input$jit_score == T) {
      ggplot(data = features(), aes(x = reorder(features, my_score, FUN = median), y = my_score)) +
        geom_boxplot(outlier.alpha = 0.4) + ggtitle('Features Vs my_score') + xlab('') + ylab('') +
        geom_jitter(width = 0.4, alpha = 0.3)
    } else {
      ggplot(data = features(), aes(x = reorder(features, my_score, FUN = median), y = my_score)) +
        geom_boxplot(outlier.alpha = 0.4) + ggtitle('Features Vs my_score') + xlab('') + ylab('')
    }
  })
  
  output$price = renderPlot({
    if (input$jit_price == T) {
      ggplot(data = features(), aes(x = reorder(features, price, FUN = median), y = price)) +
        geom_boxplot(outlier.color = 'red', outlier.shape = 1) + ggtitle('Features Vs price') + xlab('') + ylab('') +
        geom_jitter(width = 0.4, alpha = 0.1)
    } else {
      ggplot(data = features(), aes(x = reorder(features, price, FUN = median), y = price)) +
        geom_boxplot(outlier.color = 'red', outlier.shape = 1) + ggtitle('Features Vs price') + xlab('') + ylab('')
    }
  })
  
  output$hist = renderPlot({
    ggplot(data = features(), aes(x = price)) + 
      geom_histogram(aes(y = ..density..), 
                     bins = 40, 
                     col = 'red', alpha = 0.5, fill = 'red') + 
      geom_density(aes(y = ..density..), col = 'blue') + ggtitle('Price Distribution')
  })
  
  output$brands_pros = renderWordcloud2({
    wordcloud2(brands_pros(), size = 0.5, color = 'random-light')
  })
  
  output$brands_cons = renderWordcloud2({
    wordcloud2(brands_cons(), size = 0.5)
  })
  
  output$brands_titles = renderWordcloud2({
    wordcloud2(brands_titles(), size = 0.7)
  })
  
  output$brands_price = renderPrint({
    summary(stat()$price)
  })
  
  # output$brands_percent = renderPrint({
  #   summary(stat()$percent)
  # })
  
  output$brands_myscore = renderPrint({
    summary(stat()$my_score)
  })
  
  output$proc_pros = renderWordcloud2({
    wordcloud2(proc_pros(), size = 0.5, color = 'random-light')
  })
  
  output$proc_cons = renderWordcloud2({
    wordcloud2(proc_cons(), size = 0.5)
  })
  
  output$proc_titles = renderWordcloud2({
    wordcloud2(proc_titles(), size = 0.7)
  })
  
  output$proc_price = renderPrint({
    unique(stat_proc()$price)
  })
  
  # output$proc_percent = renderPrint({
  #   unique(stat_proc()$percent)
  # })
  
  output$proc_myscore = renderPrint({
    summary(stat_proc()$my_score)
  })
  
  output$exp1 = renderPrint({
    cp1 = price_dep1() %>% 
      select(., -proc_name)
    summary(cp1)
  })
  
  output$exp2 = renderPrint({
    cp2 = price_dep2() %>%
      select(., -proc_name)
    summary(cp2)
  })
  
  output$exp = renderPrint({
    summary(expensive$price)
  })
  
  output$cp1_name = renderPrint({
    print(unique(price_dep1()$proc_name))
  })
  
  output$cp2_name = renderPrint({
    print(unique(price_dep2()$proc_name))
  })
  
  output$rec_pros_pri = renderPlot({
    ggplot(data = rec_dep1(), aes(x = price)) + 
      geom_histogram(aes(y = ..density..), 
                     bins = 40, 
                     col = 'red', alpha = 0.5, fill = 'red') + 
      geom_density(aes(y = ..density..), col = 'blue') + ggtitle('Price Distribution')
  })
  
  output$rec_pros_rev = renderPlot({
    ggplot(data = rec_dep1(), aes(x = review_num)) + 
      geom_histogram(aes(y = ..density..), 
                     bins = 40, 
                     col = 'red', alpha = 0.5, fill = 'red') + 
      geom_density(aes(y = ..density..), col = 'blue') + ggtitle('Reviews Distribution')
  })
  
  output$rec_sum_pros = renderPrint({
    cp1 = rec_dep1() %>% 
      select(., -proc_name)
    summary(cp1)
  })
  
  output$rec_name_pros = renderPrint({
    print(unique(rec_dep1()$proc_name))
  })
  
  output$rec_cons_pri = renderPlot({
    ggplot(data = rec_dep2(), aes(x = price)) + 
      geom_histogram(aes(y = ..density..), 
                     bins = 40, 
                     col = 'red', alpha = 0.5, fill = 'red') + 
      geom_density(aes(y = ..density..), col = 'blue') + ggtitle('Price Distribution')
  })
  
  output$rec_cons_rev = renderPlot({
    ggplot(data = rec_dep2(), aes(x = review_num)) + 
      geom_histogram(aes(y = ..density..), 
                     bins = 40, 
                     col = 'red', alpha = 0.5, fill = 'red') + 
      geom_density(aes(y = ..density..), col = 'blue') + ggtitle('Reviews Distribution')
  })
  
  output$rec_sum_cons = renderPrint({
    cp1 = rec_dep2() %>% 
      select(., -proc_name)
    summary(cp1)
  })
  
  output$rec_name_cons = renderPrint({
    print(unique(rec_dep2()$proc_name))
  })
}