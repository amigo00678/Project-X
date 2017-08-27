# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from random import randint
from decimal import Decimal

from django.test import TestCase
from django.db.models import Count, F

from polls.models import *


class ATestCase(TestCase):
	def test_product_select(self):
		for cname in ['CatA', 'CatB', 'CatC', 'CatD']:
			cat = Category.objects.create(name=cname)
			for pname in ['Prod1', 'Prod2', 'Prod3', 'Prod4', 'Prod5']:
				prod = Product.objects.create(category=cat, name=pname+'_'+cname, price=0)

		count = Product.objects.count()
		prods = Product.objects.order_by('?')[:count / 3]
		for prod in prods:
			prod.price = randint(100, 300)
			prod.save()
			print(prod.name, prod.price)

		prods = Product.objects.filter(price=Decimal(0))
		for prod in prods:
			prod.price = randint(0, 99)

		prods = Product.objects.filter(price__gte=Decimal(100))
		self.assertEqual(prods.count(), count / 3)

		print('>>>>>>>>>')
		r = prods.values('category').annotate(ccount=Count('id'), cat_name=F('category__name'))
		for res in r:
			print res

		print('>>>>>>>>>')
		r = r.filter(ccount__gt=1)
		for res in r:
			print res

		print('>>>>>>>>>')
		for p in Product.objects.all():
			print(p.category.name, p.name, p.price)
