from django.shortcuts import render
import jwt
import phonenumbers
from django.http import JsonResponse
from datetime import datetime, timedelta
from django.utils import timezone
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from .constants import JWT_SECRET, SCANS_DIR
from .auth import hash_password, verify_password
from .decorators import is_auth, is_auth_return_user_id
from .models import ApiCity as City, ApiEmployee as Employee, ApiLocation as Location, ApiPhoto as Photo, ApiPrice as Price, ApiProduct as Product, ApiRemark as Remark, ApiRole as Role, ApiScan as Scan, ApiPlanogram as Planogram
from .messages import EMPLOYEE_PHONE_NOT_FOUND, INCORRECT_PASSWORD, INCORRECT_PHONE_FORMAT, error_response, normal_response

# Create your views here.
@api_view(['POST'])
def login(request):
    if request.method == 'POST':
        data = request.data
        try:
            emp = Employee.objects.get(phone = data["phone"])
        except:
            return error_response(EMPLOYEE_PHONE_NOT_FOUND)
        if verify_password(emp.hashed_password, data["password"]):
            dt    = datetime.now() + timedelta(days=1)
            token = jwt.encode(payload={
                'id':  emp.pk, 
                'exp': int(dt.timestamp())
            }, key=JWT_SECRET, algorithm='HS256')
            
            return normal_response({"token": token})
        else:
            return error_response(INCORRECT_PASSWORD)

#Функция для тестового добавления пользователя
@api_view(['POST'])
def register(request):
    if request.method == 'POST':
        data = request.data
        parsed_number = phonenumbers.parse(data["phone"], None)
        
        if not phonenumbers.is_valid_number(parsed_number):
            raise error_response(INCORRECT_PHONE_FORMAT)
        
        hashed_password = hash_password(data["password"])
        
        role = Role.objects.get(pk = 1)
        emp  = Employee.objects.create(
            first_name      = data["first_name"], 
            last_name       = data["last_name"], 
            phone           = data["phone"], 
            role            = role, 
            hashed_password = hashed_password
        )
        
        return normal_response("created")

@is_auth()
@api_view(['GET'])
def get_scans_today_count(request):
    if request.method == 'GET':
        today = timezone.now().date()
        scans = Scan.objects.filter(scan_datetime__date=today)
        data = {
                'scan_count': scans.count()
        }
    return normal_response(data)
        
@is_auth()
@api_view(['GET'])
def get_employees_count(request):
    if request.method == 'GET':
        emp = Employee.objects.count()
        data = {
                'employee_count': emp
        }
    return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_locations_count(request):
    if request.method == 'GET':
        loc = Location.objects.count()
        data = {
                'location_count': loc
        }
    return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_discount_count(request):
    if request.method == 'GET':
        prices_with_discount = Price.objects.filter(is_special_offer=True).count()
        data = {
                'discount_count': prices_with_discount
        }
    return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_last_5_products(request):
    if request.method == 'GET':
        products = Product.objects.order_by('-id')[:5]
        data = []
        for product in products:
            price = Price.objects.get(product = product)
            product_data = {
                "name":             product.name,
                "price":            price.price,
                "date_price":       price.date_price
            }
            data.append(product_data)
    return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_last_5_scans_from_employee_today(request):
    if request.method == 'GET':
        scans = Scan.objects.order_by('-id')[:5]
        data = []
        count = 0
        for scan in scans:
            products = Product.objects.filter(scan = scan)
            for product in products:
                try:
                    price = Price.objects.get(product = product) #исправить
                except:
                    price = 5000
                product_data = {
                        "employee_name":    scan.employee.first_name+ " " +scan.employee.last_name,
                        "product_name":     product.name,
                        "product_price":    price if type(price) == int else price.price
                 } 
                if count < 5:
                    count += 1
                    data.append(product_data)
                else:
                    break
            if count > 5:
                break        
    return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_all_employees(request):
    if request.method == 'GET':
        employees = Employee.objects.all()
        data = []
        for employee in employees:
            scans = Scan.objects.filter(employee = employee)
            unique_locations = set([scan.location.name + " " + scan.location.address for scan in scans])
            employee_data = {
                "name":             employee.first_name+ " " + employee.last_name,
                "role":             employee.role.name,
                "phone_number":     employee.phone,
                "locations":        [{"address": location} for location in unique_locations]
            }
            data.append(employee_data)
    return normal_response(data)

@is_auth()
@api_view(['POST'])
def add_employee(request):
    pass

@is_auth()
@api_view(['PUT', 'PATCH'])
def change_employee(request):
    pass

@is_auth()
@api_view(['DELETE'])
def delete_employee(request):
    pass

@is_auth()
@api_view(['GET'])
def get_all_locations(request):
    if request.method == 'GET':
        products = Location.objects.all()
        data = []
        for location in products:
            planograms = Planogram.objects.filter(location = location)
            location_data = {
                "name":         location.name,
                "address":      location.address,
                "city":         location.city.name,
                "planograms":        [{"planogram": planogram.name} for planogram in planograms]
            }
            data.append(location_data)
    return normal_response(data)

@is_auth()
@api_view(['POST'])
def add_location(request):
    pass

@is_auth()
@api_view(['PUT', 'PATCH'])
def change_location(request):
    pass

@is_auth()
@api_view(['DELETE'])
def delete_location(request):
    pass

@is_auth()
@api_view(['GET'])
def get_all_products(request):
    if request.method == 'GET':
        products = Product.objects.all()
        data = []
        for product in products:
            try:
                price = Price.objects.get(product = product) #исправить
            except:
                price = 5000
            product_data = {
                "name":         product.name,
                "location":     product.scan.location.city.name + product.scan.location.address,
                "price":        price if type(price) == int else price.price,
                "discount":     False  if type(price) == int else price.is_special_offer,
                "edit_date":    product.scan.scan_datetime,
            }
            data.append(product_data)
    return normal_response(data)

@is_auth()
@api_view(['POST'])
def add_product(request):
    pass

@is_auth()
@api_view(['PUT', 'PATCH'])
def change_product(request):
    pass

@is_auth()
@api_view(['DELETE'])
def delete_product(request):
    pass


@is_auth()
@api_view(['GET'])
def get_all_scans(request):
    if request.method == 'GET':
        scans = Scan.objects.all()
        data = []
        for scan in scans:
            products = Product.objects.filter(scan = scan)
            for product in products:
                try:
                    price = Price.objects.get(product = product) #исправить
                except:
                    price = 5000
                product_data = {
                    "employee_name":scan.employee.first_name+ " " +scan.employee.last_name,
                    "city":         scan.location.city.name,
                    "address":      scan.location.address,
                    "product_name": product.name,
                    "price":        price if type(price) == int else price.price,
                    "discount":     False  if type(price) == int else price.is_special_offer,
                    "edit_date":    scan.scan_datetime,
                }
                data.append(product_data)
    return normal_response(data)

@is_auth()
@api_view(['POST'])
def add_scan(request):
    pass

@is_auth()
@api_view(['PUT', 'PATCH'])
def change_scan(request):
    pass

@is_auth()
@api_view(['DELETE'])
def delete_scan(request):
    pass