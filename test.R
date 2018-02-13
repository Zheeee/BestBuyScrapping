ggplot(data = company, aes(x = review_num, y = percent)) + geom_point(aes(col = features))
# review_num percent percent may not be true
library(plotly)
plot_ly(data = company, x = ~review_num, y = ~rank, color = ~features)
plot_ly(data = company, x = ~review_num, y = ~percent, color = ~features)

expensive = company %>% 
  filter(., grepl('price', cons)) %>% 
  filter(., price_off == 'regular')
summary(expensive)

mico = company %>% 
  filter(., features == 'Microsoft') %>% 
  filter(., price >= 2000)
summary(mico)

app = company %>% 
  filter(., features == 'Apple') %>% 
  filter(., price >= 2000)
summary(app)

dell = company %>% 
  filter(., features == 'Dell') %>% 
  filter(., price >= 1500)
summary(dell)

test = company %>% 
  filter(., (price >= 100) & (price <= 200)) %>% 
  select(., price, percent, review_num, my_score, rank)
