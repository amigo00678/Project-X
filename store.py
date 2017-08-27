'''
Предложить структуру хранения данных и технологию их обработки для проекта интернет-магазина (упрощённо).
В магазине тысячи товаров различного предназначения, брендов и т.д.

 

В интернет-магазине необходимо предусмотреть систему скидок. Виды скидок:

    Скидка на единичный товар
    Скидка на бренд
    Скидка на группу товаров (группы: предназначение(техника, одежда,...), пол)
    Скидка клиента

Скидка имеет начало и конец действия. У каждого товара в определённый момент может быть ни одной/одна/несколько скидок.
Скидка в данный момент рассчитывается как максимум из действующих скидок для товара. Скидку клиента учитывать в процессе покупки товара, при отображении каталога товаров цены с учётом скидки клиента не пересчитывать. Остальные скидки при отображении каталога должны быть показаны.

Необходимо, чтобы была возможность сортировки товаров по актуальной цене - с учётом скидок.
 

Какие django-приложения для решения задачи предлагаете использовать (готовые движки магазинов не предлагать)?
'''

class Product:
	name = CharField()
	price = DecimalField()
	brand = ForeignKey()
	group = ForeignKey()
	discount = DecimalField()
	actual_price = DecimalField()


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


'''
Использовать django-cron для обновления цены на продукт каждую минуту
'''

from django_cron import CronJobBase, Schedule


class MyCronJob(CronJobBase):
	RUN_EVERY_MINS = 1 # every 2 hours

	schedule = Schedule(run_every_mins=RUN_EVERY_MINS)
	code = 'my_app.my_cron_job'    # a unique code

	def do(self):
		update_prices()


def update_prices():
	for p in Product.objects.all():
		brand_disc = Discount.objects.filter(brand=p.brand, start_date__gte=now, end_date__lte=now).first()
		group_disc = Discount.objects.filter(group=p.group, start_date__gte=now, end_date__lte=now).first()
		product_disc = Discount.objects.filter(product=p, start_date__gte=now, end_date__lte=now).first()

		disc = max(
			brand_disc.size if brand_disc else 0,
			group_disc.size if group_disc else 0,
			product_disc if product_disc else 0)

		if disc:
			new_price = p.price * disc * 0.01

			if new_price != p.actual_price:
				p.actual_price = new_price
				p.save()
