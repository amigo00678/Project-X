# -*- coding: utf-8 -*-
'''
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
