# -*- coding: utf-8 -*-
'''
Написать родительский класс XDictAttr так, 
чтобы у наследника динамически определялся ключ по наличию метода get_<KEY>.
'''


class XDictAttr(dict):
	def __init__(self, *args, **kwargs):
		super(XDictAttr, self).__init__(*args, **kwargs)
		for name, value in args[0]:
			setattr(self, name, value)

	def __getitem__(self, name):
		fname = 'get_'+name
		if hasattr(self, fname):
			m = getattr(self, fname)
			return m()
		return super(XDictAttr, self).__getitem__(name)

	def __str__(self):
		fname = self.__class__.__name__+'('
		for name, val in self.__dict__.iteritems():
			fname += name+'='+str(val)+','
		return fname[:-1]+')'

	def get(self, key, default=None):
		fname = 'get_'+key
		if hasattr(self, fname):
			m = getattr(self, fname)
			return m()
		return super(XDictAttr, self).get(key, default)


class A(XDictAttr):
	def get_foo(self):
		return 'foo'
	def get_xyz(self):
		return 'xyz'


x = XDictAttr([('one', 1), ('two', 2), ('three', 3)])

print(x)
print(x['three'])
print(x.get('one'))
print(x.get('five', 'missing'))
print(x.one)
print(x.two)
print(x.three)

y = A([('one', 'one'), ('two', 'two'), ('three', 'three')])

print(y)
print(y['three'])
print(y.get('one'))
print(y.get('five', 'missing'))
print(y.one)
print(y.two)
print(y.three)
print(y['foo'])
print(y.get('foo'))
print(y.get('xyz'))
print(y.get('bzz'))
