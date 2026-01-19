
DISABLED = False

def disabled_if_flag(func):
    def wrapper():
        if DISABLED:
            raise RuntimeError("Feature disabled")
        return func()
    return wrapper

@disabled_if_flag
def work():
    return "done"

# Пример использования
DISABLED = False
print(work())   # done

DISABLED = True
try:
    print(work())   # RuntimeError: Feature disabled
except RuntimeError as e:
    print(e)
