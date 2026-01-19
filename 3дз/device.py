class Device:
    def __init__(self, brand, battery_capacity):
        self.brand = brand
        self.battery_capacity = battery_capacity

    def show_device_info(self):
        print(f"Бренд: {self.brand}")
        print(f"Батарея: {self.battery_capacity} мАч")


class Smartphone(Device):
    def __init__(self, brand, battery_capacity, screen_resolution):
        super().__init__(brand, battery_capacity)
        self.screen_resolution = screen_resolution

    def show_device_info(self):
        super().show_device_info()
        print(f"Разрешение экрана: {self.screen_resolution}")


class Laptop(Device):
    def __init__(self, brand, battery_capacity, processor_performance):
        super().__init__(brand, battery_capacity)
        self.processor_performance = processor_performance

    def show_device_info(self):
        super().show_device_info()
        print(f"Производительность процессора: {self.processor_performance}")


# инфа о смартфоне
print("Смартфон:")
phone = Smartphone("Apple", 3500, "1080x1920")
phone.show_device_info()

print()

# инфа о ноутбуке
print("Ноутбук:")
laptop = Laptop("Dell", 8000, "3.5 GHz")
laptop.show_device_info()