from scrapy import Spider, Request
from bestbuy.items import BestbuyItem
import json
import re

class BestbuySpider(Spider):
	name = 'bestbuy_spiders'
	allowed_urls = ['https://www.bestbuy.com/site/']
	start_urls = ["https://www.bestbuy.com/site/searchpage.jsp?cp={0}&searchType=search&st=laptop&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&nrp=&sp=-bestsellingsort%20skuidsaas&list=n&af=true&iht=y&usc=All%20Categories&ks=960&keys=keys&qp=category_facet%3DAll%20Laptops~pcmcat138500050001%5Econdition_facet%3DCondition~New".format(x) for x in range(1,27)]
	
	def parse(self, response):
		# get the urls to detail pages

		temp = response.xpath("//div[@itemprop = 'name']/h4/a/@href").extract()
		urls_detail = ['https://www.bestbuy.com' + x for x in temp]

		for url in urls_detail:
			yield Request(url, callback = self.parse_detail)

	def parse_detail(self, response):
		# get the number of reviews
		review_num = response.xpath("//a[@id ='ratings-count-link']/text()").extract_first()
		review_num = int(re.findall("\d+", review_num)[0])//2
		# price
		# price = response.xpath("//div[@class='pb-regular-price']/text()").extract_first()[5:]
		# first review page
		first = response.xpath("//a[@class = 'btn btn-default ']/@href").extract()
		# all pages
		if review_num > 60:
			pages = [first[0] + '?page=' + str(x) for x in range(2, review_num//20)]
			all_pages = first + pages
		elif review_num <= 60 and review_num > 40:
			pages = [first[0] + '?page=' + str(x) for x in range(2, 4)]
			all_pages = first + pages
		elif review_num <= 40 and review_num > 20:
			pages = [first[0] + '?page=' + str(x) for x in range(2, 3)]
			all_pages = first + pages
		else:
			all_pages = first
		
		for page in all_pages:
			yield Request(page, callback = self.parse_review, meta = {'review_num': review_num})

	def parse_review(self, response):
		# price = response.meta['price']
		pros = ' - '.join(response.xpath("//div[@class = 'pros-container']//span[@class = 'feature-text']/text()").extract())
		cons = ' - '.join(response.xpath("//div[@class = 'cons-container']//span[@class = 'feature-text']/text()").extract())
		review_num = response.meta['review_num']
		proc_name = response.xpath("//a[@data-track = 'Product Description']/text()").extract_first()
		# get percent 
		avg_rec = response.xpath("//span[@class = 'average-score percent']/text()").extract()
		# get percent
		percent = ''.join(avg_rec)
		reviews = response.xpath("//li[@class = 'review-item']")

		for review in reviews:
			# get unhelp number
			unhelp_ = review.xpath(".//button[@data-track = 'Unhelpful']/text()").extract()[1]
			# get help number
			help_ = review.xpath(".//button[@data-track = 'Helpful']/text()").extract()[1]
			# get author
			author = review.xpath(".//div[@class = 'author']/text()").extract_first()
			# get score
			score = float(review.xpath(".//span[@class = 'c-review-average']/text()").extract_first())
			# get title
			title = review.xpath(".//h4[@class = 'col-md-9 col-sm-9 col-xs-12 title']/text()").extract_first()
			
			item = BestbuyItem()
			# item['price'] = price
			item['pros'] = pros
			item['cons'] = cons
			item['review_num'] = review_num
			item['proc_name'] = proc_name
			item['unhelp_'] = unhelp_
			item['help_'] = help_
			item['author'] = author
			item['score'] = score
			item['title'] = title
			item['percent'] = percent

			yield item