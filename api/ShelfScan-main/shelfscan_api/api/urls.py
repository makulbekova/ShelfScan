from django.urls import path
from . import controllers

# Определение URL-маршрутов (urlpatterns) для приложения keycontrol.
urlpatterns = [
    path('test', controllers.test, name='test'),
    path('login', controllers.login, name='login'),
    path('register', controllers.register, name='register'),
    path('cities', controllers.get_cities, name='cities'),
    path('locations', controllers.get_locations, name='locations'),
    path('locations/<int:city_id>', controllers.get_locations_from_city_id, name='locations_from_city'),
    path('photo_process', controllers.photo_process, name="photo_process"),
    path('send_product_photo', controllers.send_product_photo, name="send_product_photo"),
    path('get_scans_from_location/<int:location_id>', controllers.get_scans_from_location, name="get_scans_from_location"),
    path('get_scan_info/<int:scan_id>', controllers.get_scan_info, name="get_scan_info"),
    path('get_employee_data', controllers.get_employee_data, name="get_employee_data"),
    path('get_employee_data_for_bar_chart', controllers.get_employee_data_for_bar_chart, name="get_employee_data_for_bar_chart"),
    path('get_scans_from_employee', controllers.get_scans_from_employee, name="get_scans_from_employee"),
    path('get_products_and_prices_from_scan/<int:scan_id>', controllers.get_products_and_prices_from_scan, name="get_products_and_prices_from_scan"),
    path('delete_product/<int:product_id>', controllers.delete_product, name="delete_product"),
    path('update_product/<int:product_id>', controllers.update_product, name="update_product"),
]