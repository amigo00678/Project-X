# -*- coding: utf-8 -*-
'''
Реализовать дескрипторы, которые бы фиксировали тип атрибута
'''

class Property(object):
	def __init__(self, value=None):
		self.value = value

	def __get__(self, obj, objtype):
		return self.value

	def __set__(self, obj, value):
		if type(self.value) != type(value):
			raise TypeError('Assigning value of wrong type!')
		self.value = value


class SClass(object):
	x = Property(0)
	hello = Property('')


s = SClass()
s.x = 10
s.hello = 'asta la vista!'

try:
	s.x = 'hello'
	print('Wrong type assinged!')
except TypeError:
	pass

try:
	s.hello = 10
	print('Wrong type assinged!')
except TypeError:
	pass

