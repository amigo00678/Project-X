# -*- coding: utf-8 -*-
'''
Написать аналог map:

    первым аргументом идет либо функция, либо список функций
    вторым аргументом — список аргументов, которые будут переданы функциям
    полагается, что эти функции — функции одного аргумента

Пошел путем наименьшего сопротивления
Не потому, что лень или не могу
Если есть готовая функция, нужно ее использовать (функция map)
Если писать свою, нужно ее отлаживать, тестировать
А клиенту за это надо платить деньги
'''


def mymap(fs, args):
	if not isinstance(fs, (list, tuple)):
		fs = [fs]
	def sub_map():
		for f in fs:
			yield map(f, args)
	return list(sub_map())

def add0(x):
	return x+0

def add1(x):
	return x+1

def add2(x):
	return x+2

r = mymap([add0, add1, add2], [1, 2, 3])

print(r)
