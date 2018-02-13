navbarPage("Laptops on BestBuy",
           tabPanel("Features",
                    fluidRow(
                      fluidRow(
                        column(3, offset = 1, selectizeInput('features', 'Features', 
                                                             choices = c('Brands', 'CPU', 'Memory', 'Drive'), selected = 'Brands')),
                        
                        column(1, checkboxInput('jit_score', 'Jitter score')),
                        column(1, checkboxInput('jit_price', 'Jitter price'))
                      ),
                      hr(),
                      column(6, plotOutput('bar')),
                      column(6, plotOutput('my_score')),
                      column(6, plotOutput('price')),
                      column(6, plotOutput('hist'))
                    )
           ),
           tabPanel("Reviews",
                    fluidRow(
                      column(12,
                             fluidRow(
                               column(2, offset = 1, selectizeInput('brands', 'Brands', 
                                                                    choices = unique(company$features))),
                               column(2, selectizeInput('proc', 'Name',
                                                        choices = unique(company$proc_name))),
                               column(2, sliderInput('sel_price', 'Price',
                                                     min = min(company$price), max = max(company$price),
                                                     value = c(min(company$price), max(company$price)))),
                               column(2, sliderInput('sel_score', 'My_score', 
                                                     min = min(company$my_score), max = max(company$my_score),
                                                     value = c(min(company$my_score), max(company$my_score)))),
                               column(1, checkboxInput('price_score', 'Score?'))),
                             hr(),
                             fluidRow(
                               column(6,
                                      fluidRow(
                                        column(6, tags$b('Pros: '), wordcloud2Output('brands_pros')),
                                        column(6, tags$b('Cons: '), wordcloud2Output('brands_cons')),
                                        br(),
                                        column(6, tags$b('Titles: '), wordcloud2Output('brands_titles')),
                                        column(6, 
                                               fluidRow(
                                                 tags$b('Statistic: '),
                                                 br(),
                                                 'Price: ',
                                                 verbatimTextOutput('brands_price'),
                                                 # 'Percent',
                                                 # verbatimTextOutput('brands_percent'),
                                                 'My_score',
                                                 verbatimTextOutput('brands_myscore')
                                               ))
                                      )),
                               column(6,
                                      fluidRow(
                                        column(6, tags$b('Pros: '), wordcloud2Output('proc_pros')),
                                        column(6, tags$b('Cons: '), wordcloud2Output('proc_cons')),
                                        br(),
                                        column(6, tags$b('Titles: '), wordcloud2Output('proc_titles')),
                                        column(6, 
                                               fluidRow(
                                                 tags$b('Statistic: '),
                                                 br(),
                                                 'Price: ',
                                                 verbatimTextOutput('proc_price'),
                                                 # 'Percent',
                                                 # verbatimTextOutput('proc_percent'),
                                                 'My_score',
                                                 verbatimTextOutput('proc_myscore')
                                               ))
                                      )))
                             
                      ))),
           tabPanel('More Reviews',
                    fluidRow(
                      column(12,
                             fluidRow(
                               column(6,  
                                      column(6, selectInput('rec_pros', 'All Pros', choices = all_pros$word, multiple = T, selected = 'ease')),
                                      column(6, sliderInput('sel_pros', 'Price', 
                                                            min = min(company$price), max = max(company$price),
                                                            value = c(min(company$price), max(company$price)))),
                                      column(6, plotOutput('rec_pros_pri')),
                                      column(6, plotOutput('rec_pros_rev')),
                                      column(12, verbatimTextOutput('rec_sum_pros')),
                                      column(12, verbatimTextOutput('rec_name_pros'))),
                               column(6,
                                      column(6, selectInput('rec_cons', 'All Cons', choices = all_cons$word, multiple = T, selected = 'noise')),
                                      column(6, sliderInput('sel_cons', 'Price', 
                                                            min = min(company$price), max = max(company$price),
                                                            value = c(min(company$price), max(company$price)))),
                                      column(6, plotOutput('rec_cons_pri')),
                                      column(6, plotOutput('rec_cons_rev')),
                                      column(12, verbatimTextOutput('rec_sum_cons')),
                                      column(12, verbatimTextOutput('rec_name_cons')))
                    )))),
           tabPanel("Price and Selling",
                    fluidRow(
                      column(12, 
                             fluidRow(
                               'Expensive?',
                               verbatimTextOutput('exp'))),
                               column(6,
                                      column(6, selectizeInput('cp1', 'Brands', 
                                                                           choices = unique(company$features))),
                                      column(6, sliderInput('price_1', 'Price1',
                                                            min = min(company$price), max = max(company$price),
                                                            value = c(min(company$price), max(company$price)))),
                                      column(12, verbatimTextOutput('exp1')),
                                      column(12, verbatimTextOutput('cp1_name'))),
                               column(6,
                                      column(6, selectizeInput('cp2', 'Brands', 
                                                                           choices = unique(company$features))),
                                      column(6, sliderInput('price_2', 'Price2',
                                                            min = min(company$price), max = max(company$price),
                                                            value = c(min(company$price), max(company$price)))),
                                      column(12, verbatimTextOutput('exp2')),
                                      column(12, verbatimTextOutput('cp2_name')))
)))