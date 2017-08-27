# -*- coding: utf-8 -*-
'''
Написать класс, который регистрирует свои экземпляры и предоставляет интерфейс итератора по ним
'''


class Reg(object):
	objects = []
	def __init__(self, *args, **kwargs):
		super(Reg, self).__init__(*args, **kwargs)
		Reg.objects.append(self)

	class __metaclass__(type):
		def __iter__(self):
			for o in Reg.objects:
				yield o


x = Reg()
y = Reg()
z = Reg()

for i in Reg:
	print(i)
