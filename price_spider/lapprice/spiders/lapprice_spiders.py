from scrapy import Spider, Request
from lapprice.items import LappriceItem
import json
import re

class LappriceSpider(Spider):
	name = 'lapprice_spiders'
	allowed_urls = ['https://www.bestbuy.com/site/']
	start_urls = ["https://www.bestbuy.com/site/searchpage.jsp?cp={0}&searchType=search&st=laptop&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&nrp=&sp=-bestsellingsort%20skuidsaas&list=n&af=true&iht=y&usc=All%20Categories&ks=960&keys=keys&qp=category_facet%3DAll%20Laptops~pcmcat138500050001%5Econdition_facet%3DCondition~New".format(x) for x in range(1,27)]

	def parse(self, response):
		divs = response.xpath("//div[@class = 'list-item']")
		for div in divs:
			json_ = json.loads(div.xpath("./@data-price-json").extract_first())
			price = json_['currentPrice']
			price_off = json_['priceDomain']['pricingType']
			proc_name = div.xpath(".//a[@data-rank = 'pdp']/text()").extract_first()
			image = div.xpath(".//img/@src").extract_first()

			item = LappriceItem()
			item['price'] = price
			item['price_off'] = price_off
			item['proc_name'] = proc_name
			item['image'] = image

			yield item



