# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models


class Category(models.Model):
	name = models.CharField('Cat', max_length=64)


class Product(models.Model):
	category = models.ForeignKey(Category, verbose_name='Cat')
	name = models.CharField('Name', max_length=128)
	price = models.DecimalField('Price', max_digits=10, decimal_places=2)
