# -*- coding: utf-8 -*-
'''
Написать базовый класс Observable, который бы позволял наследникам:

        при передаче **kwargs заносить соответствующие значения как атрибуты
        сделать так, чтобы при print отображались все публичные атрибуты

'''


class Observable(object):
	def __init__(self, **kwargs):
		for name, value in kwargs.iteritems():
			setattr(self, name, value)

	def __str__(self):
		fname = self.__class__.__name__+'('
		for name, val in self.__dict__.iteritems():
			fname += name+'='+str(val)+','
		return fname[:-1]+')'


class A(Observable):
	pass


a = A(foo=1, bar=6, name='Amrok')

print(a)
print(a.foo)
print(a.bar)
print(a.name)
