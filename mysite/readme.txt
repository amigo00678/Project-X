Даны модели:

class Category(models.Model):   
	name = models.CharField(‘Категория товара’, max_length=64)   
	…


class Product(models.Model):   
	category = models.ForeignKey(Category, verbose_name=‘Категория’)    
	name = models.CharField(‘Наименование товара’, max_length=128)   
	price = models.DecimalField(‘Цена единицы, руб.’, max_digits=10, decimal_places=2)


а) С помощью Django ORM выбрать товары, цена которых больше или равна 100 руб.,
	сгруппировать по категориям и посчитать количество товаров в каждой категории.


б) То же самое, но оставить лишь категории, в которых строго больше 10 товаров

 
в) Написать код python, который выводит в консоль перечень всех товаров. Каждая строка должна содержать следующие данные:

    название категории товара,
    наименование товара,
    цена.

По возможности, минимизировать количество обращений к базе данных и количество передаваемых данных


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Реализация:
polls/tests.py


Выполнение:
python manage.py test

