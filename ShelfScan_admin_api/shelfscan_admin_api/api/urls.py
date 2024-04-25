from django.urls import path
from . import controllers

# Определение URL-маршрутов (urlpatterns) для приложения keycontrol.
urlpatterns = [
    path('login', controllers.login, name='login'),
    path('register', controllers.register, name='register'),
    path('get_scans_today_count', controllers.get_scans_today_count, name='get_scans_today_count'),
    path('get_employees_count', controllers.get_employees_count, name='get_employees_count'),
    path('get_locations_count', controllers.get_locations_count, name='get_locations_count'),
    path('get_last_5_products', controllers.get_last_5_products, name='get_last_5_products'),
    path('get_last_5_scans_from_employee_today', controllers.get_last_5_scans_from_employee_today, name="get_last_5_scans_from_employee_today"),
    path('get_all_employees', controllers.get_all_employees, name="get_all_employees"),
    path('get_all_locations', controllers.get_all_locations, name="get_all_locations"),
    path('get_all_products', controllers.get_all_products, name="get_all_products"),
    path('get_all_scans', controllers.get_all_scans, name="get_all_scans")
    
]