from django.http import JsonResponse
from django.urls import reverse
from django.shortcuts import render
from django.shortcuts import redirect
import jwt
from .messages import TOKEN_HAS_EXPIRED, error_response
from .constants import JWT_SECRET

def is_auth():
    def decorator(controler_func):
        def wrap(request, *args, **kwargs):
            token = request.headers._store["authorization"][1].replace("Bearer ", "")
            try:
                payload = jwt.decode(token, key=JWT_SECRET, algorithms=['HS256', 'RS256'])
            except jwt.ExpiredSignatureError: 
                return error_response(TOKEN_HAS_EXPIRED, 401)
            return controler_func(request, *args, **kwargs)
        return wrap
    return decorator

def is_auth_return_user_id():
    def decorator(controler_func):
        def wrap(request, *args, **kwargs):
            token = request.headers._store["authorization"][1].replace("Bearer ", "")
            try:
                payload = jwt.decode(token, key=JWT_SECRET, algorithms=['HS256', 'RS256'])
            except jwt.ExpiredSignatureError: 
                return error_response(TOKEN_HAS_EXPIRED, 401)
            return controler_func(request, payload["id"], *args, **kwargs)
        return wrap
    return decorator
