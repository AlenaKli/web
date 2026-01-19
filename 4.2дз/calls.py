import time


def rate_limit(calls, per_seconds):
    def decorator(func):
        call_history = []  
        def wrapper():
            now = time.time()

            # Удаляем старые вызовы
            while call_history and call_history[0] < now - per_seconds:
                call_history.pop(0)

            # Проверяем лимит
            if len(call_history) >= calls:
                raise RuntimeError("Rate limit exceeded")

            # Добавляем текущий вызов
            call_history.append(now)
            return func()

        return wrapper

    return decorator


# Пример использования
@rate_limit(calls=2, per_seconds=1.0)
def ping():
    return "pong"


# Тест
print(ping())
print(ping())
try:
    print(ping())  # RuntimeError
except RuntimeError as e:
    print(e)