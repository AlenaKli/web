class MenuItem:
    def __init__(self, name, price, calories):
        self.name = name
        self.price = price
        self.calories = calories

    def __str__(self):
        return f"{self.name} - {self.price} руб, {self.calories} ккал"


class Cafe:
    def __init__(self, name, seats):
        self.name = name
        self.seats = seats
        self.menu = []

    def add_dish(self, dish):
        self.menu.append(dish)

    def show_info(self):
        print(f"Кафе '{self.name}'")
        print(f"Посадочных мест: {self.seats}")
        print("Меню:")
        for dish in self.menu:
            print(f"  {dish}")


class Order:
    def __init__(self, date):
        self.date = date
        self.dishes = []
        self.total = 0

    def add_dish(self, dish):
        self.dishes.append(dish)
        self.total += dish.price

    def show_order(self):
        print(f"Заказ от {self.date}:")
        for dish in self.dishes:
            print(f"  {dish.name} - {dish.price} руб")
        print(f"Итого: {self.total} руб")


# Демонстрация работы
# Создание блюда
dish1 = MenuItem("Кофе", 150, 50)
dish2 = MenuItem("Булочка", 80, 200)
dish3 = MenuItem("Сэндвич", 250, 350)

# Создание кафе с 30 посадочными местами
my_cafe = Cafe("Уютное место", 30)
my_cafe.add_dish(dish1)
my_cafe.add_dish(dish2)
my_cafe.add_dish(dish3)

# Показ инфы о кафе
my_cafe.show_info()

# Создание заказа
order = Order("15.01.2024")
order.add_dish(dish1)
order.add_dish(dish2)


print()
order.show_order()