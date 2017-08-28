# -*- coding: utf-8 -*-
'''
Реализовать базовый класс (используя метакласс) и дескрипторы, которые бы на основе класса создавали SQL-схему (ANSI SQL) для модели:

>>> class Image(Table):

...     height = Integer()
...     width = Integer()
...     path = Str(128)

>>> print Image.sql()

CREATE TABLE image (
    height integer,
    width integer,
    path varchar(128)
)
'''

class Property(object):
	def __get__(self, instance, owner):
		if not instance:
			return self
		return self.value

	def __set__(self, obj, value):
		if type(self.value) != type(value):
			raise TypeError('Assigning value of wrong type!')
		self.value = value

	def sql(self):
		return ''


class Integer(Property):
	def __init__(self):
		self.value = 0

	def sql(self):
		return 'integer'


class Str(Property):
	def __init__(self, max_l=128):
		self.value = ''
		self.max_l=max_l

	def __set__(self, obj, value):
		try:
			if len(value) > self.max_l:
				raise ValueError('Assigning value of wrong size!')
		except TypeError:
			pass

		super(Str, self).__set__(obj, value)

	def sql(self):
		return 'varchar('+str(self.max_l)+')'


class Table(object):
	class __metaclass__(type):
		def __iter__(self):
			for attr_name in dir(self):
				if not attr_name.startswith('__'):
					yield attr_name

		def __len__(self):
			len = 0
			for attr_name in dir(self):
				if not attr_name.startswith('__'):
					len += 1
			return len

		def sql(self):
			if not len(self):
				raise ValueError('No fields in table class!')
			result = 'create table '+self.__name__+'('
			for attr_name in self:
				attr = getattr(self, attr_name)
				result += '\n'+attr_name+' '+attr.sql()+','
			return result[:-1]+')'


class Image(Table):
	height=Integer()
	width=Integer()
	path=Str(8)


class EmptyTalbe(Table):
	pass


print (Image.sql())

i = Image()
i.height=1

print(i.height)

try:
	i.height='hello'
	print('Wrong type value assigned!')
except TypeError:
	pass

i.path = 'hello!'
print(i.path)
ppath = i.path

try:
	i.path = 1
	print('Wrong type value assigned!')
except TypeError:
	pass

assert ppath == i.path

try:
	i.path='hello! hello! hello!'
	print('Wrong size value assigned!')
except ValueError:
	pass

assert ppath == i.path

try:
	print(EmptyTalbe.sql())
	print('SQL of empty table printed!')
except ValueError:
	pass
