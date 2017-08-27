# -*- coding: utf-8 -*-
'''
Реализовать базовый класс (используя метакласс), который бы фиксировал тип атрибута
Проблема: как это сделать, используя метакласс?
'''

class StrongType(object):
	def __setattr__(self, name, value):
		print name, value
		if self.__dict__.get(name, None) and type(self.__dict__[name]) != type(value):
			raise TypeError('Assigning value of wrong type!')
		self.__dict__[name] = value

class SClass(StrongType):
	pass


boo = SClass()
boo.asd = 1
print(boo.asd)
try:
	boo.asd = 'hello'
	print('Wrong type assinged!')
except TypeError:
	pass
print(boo.asd)
