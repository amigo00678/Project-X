
class Product:
	name = CharField()
	price = DecimalField()
	brand = ForeignKey()
	group = ForeignKey()
	discount = DecimalField()

	@property
	def disc_price(self):
		return self.price * self.discount * 0.01

	@property
	def discount(self):
		now = datetime.now()
		return max(
			Discount.objects.filter(brand=self.brand, start_date__gte=now, end_date__lte=now).first().size,
			Discount.objects.filter(group=self.group, start_date__gte=now, end_date__lte=now).first().size,
			Discount.objects.filter(product=self, start_date__gte=now, end_date__lte=now).first().size())

class Brand:
	name = CharField()


class Group:
	name = CharField()


class Client:
	name = CharField()
	username = CharField()
	password = CharField()


class DiscountTypeE:
	PRODUCT=1
	BRAND=2
	GROUP=3
	CLIENT=4
	

class Discount:
	type = IntegerField(choices=DiscountTypeE)
	size = IntegerField()
	start_date = DateTimeField()
	end_date = DateTimeField()

	product = ForeignKey('Product', null=True)
	brand = ForeignKey('Brand', null=True)
	client = ForeignKey('Client', null=True)
	group = ForeignKey('Group', null=True)


