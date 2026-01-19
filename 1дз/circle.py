import math


class Circle:
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return math.pi * self.radius ** 2

    def circumference(self):
        return 2 * math.pi * self.radius

    def __str__(self):
        return f"Круг с радиусом {self.radius}"


# Демонстрация работы
circle1 = Circle(5)
print(circle1)
print(f"Площадь: {circle1.area():.2f}")
print(f"Длина окружности: {circle1.circumference():.2f}")

circle2 = Circle(10)
print(f"\n{circle2}")
print(f"Площадь: {circle2.area():.2f}")
print(f"Длина окружности: {circle2.circumference():.2f}")