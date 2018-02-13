# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy 

class BestbuyItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    # price = scrapy.Field()
    pros = scrapy.Field()
    cons = scrapy.Field()
    review_num = scrapy.Field()
    proc_name = scrapy.Field()
    help_ = scrapy.Field()
    unhelp_ = scrapy.Field()
    author = scrapy.Field()
    score = scrapy.Field()
    title = scrapy.Field()
    percent = scrapy.Field()
