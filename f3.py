# -*- coding: utf-8 -*-
'''
Написать класс, который бы по всем внешним признакам был бы словарем, но позволял обращаться к ключам как к атрибутам.

Для решения также можно переписать __getattr__
	def __getattr__(self, name):
		return self.__getitem__(name)
Но при обращении к несуществующему аттрибуту, появляется KeyError, а не AttributeError
'''


class DictAttr(dict):
	def __init__(self, *args, **kwargs):
		super(DictAttr, self).__init__(*args, **kwargs)
		for name, value in args[0]:
			setattr(self, name, value)

	def __str__(self):
		fname = self.__class__.__name__+'('
		for name, val in self.__dict__.iteritems():
			fname += name+'='+str(val)+','
		return fname[:-1]+')'


x = DictAttr([('one', 1), ('two', 2), ('three', 3)])

print(x)
print(x['three'])
print(x.get('one'))
print(x.get('five', 'missing'))
print(x.one)
print(x.two)
print(x.three)
print(x.five)
