EMPLOYEE_PHONE_NOT_FOUND = "Пользователь по данному номеру телефона не найден!"
INCORRECT_PASSWORD = "Неверный пароль!"
INCORRECT_PHONE_FORMAT = "Неправильно введен формат номера телефона!"
TOKEN_HAS_EXPIRED = "Срок токена истек!"
from django.http import JsonResponse

def error_response(message, status_code = 400):
    return JsonResponse({'status': 'error', 'message': message}, status=status_code)

def normal_response(data, status_code = 200):
    return JsonResponse({'status': 'success', 'data': data}, status=status_code)
