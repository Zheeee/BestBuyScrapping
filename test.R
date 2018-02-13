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
  filter(., (price >= 100) & (price <= 200))
test1 = company %>% 
  filter(., as.logical(apply(sapply(c('price', 'bar'), function(x) grepl(x, company$pros)), 1, prod)))

sti = c('a', 'b', 'c')
grepl('a c', sti)
'a c' %in% sti
c('a', 'c') %in% sti
all(c(T,F,T,F), c(F,T,T,T))
a = c(T,F,T,F)
b = c(F,F,F,T)
c = matrix(c(a, b), nrow = length(a))
as.logical(apply(c, 1, prod))
c = cbind(a, b)
as.logical(apply(c, 1, prod))








