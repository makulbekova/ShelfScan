import os
import jwt
import base64
import phonenumbers

from django.http import JsonResponse
from datetime import datetime, timedelta
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt

from .constants import JWT_SECRET, SCANS_DIR
from .auth import hash_password, verify_password
from .decorators import is_auth, is_auth_return_user_id
from .models import City, Employee, Location, Photo, Price, Product, Remark, Role, Scan
from .messages import EMPLOYEE_PHONE_NOT_FOUND, INCORRECT_PASSWORD, INCORRECT_PHONE_FORMAT, error_response, normal_response

@api_view(['GET'])
def test(request):
    if request.method == 'GET':
        return JsonResponse({'data': 'test'})
    

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
def get_cities(request):
    if request.method == 'GET':
        cities = City.objects.all()
        
        data = [{
            "name": city.name
        } for city in cities]
        
        return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_locations(request):
    if request.method == 'GET':
        locations = Location.objects.all()
        
        data = [{
            "id":                 location.pk, 
            "name":               location.name, 
            "address":            location.address, 
            "last_scan_datetime": Scan.objects.filter(location=location).last().scan_datetime 
                                    if Scan.objects.filter(location=location).exists() else datetime(1, 1, 1, 0, 0, 0)
        } for location in locations]
        
        return normal_response(data)
    
@is_auth()
@api_view(['GET'])
def get_locations_from_city_id(request, city_id):
    if request.method == 'GET':
        city      = City.objects.get(pk = city_id)
        locations = Location.objects.filter(city = city)
        
        data = [{
            "id":      location.pk, 
            "name":    location.name, 
            "address": location.address
        } for location in locations]
        
        return normal_response(data)
    
@is_auth()
@api_view(['GET'])
def get_scans_from_location(request, location_id):
    if request.method == 'GET':
        location = Location.objects.get(pk = location_id)
        scans    = Scan.objects.filter(location = location)
        
        data = []
        for scan in scans:
            remarks_count  = Remark.objects.filter(scan=scan).count()
            products_count = Product.objects.filter(scan=scan).count()

            scan_data = {
                "scan_id":        scan.pk,
                "scan_datetime":  scan.scan_datetime,
                "remarks_count":  remarks_count,
                "products_count": products_count,
            }
            data.append(scan_data)
            
        return normal_response(data)

@is_auth()
@api_view(['GET'])
def get_scan_info(request, scan_id):
    if request.method == 'GET':
        scan         = Scan.objects.get(pk = scan_id)
        location     = scan.location
        full_address = f"г. {location.city.name}, {location.address}"
        photo_path   = scan.photo.photo_path
        
        with open(photo_path, 'rb') as photo_file:
            photo_data = base64.b64encode(photo_file.read()).decode('utf-8')

        data = {
            "name":         location.name,
            "full_address": full_address,
            "scan_date":    scan.scan_datetime,
            "photo_base64": photo_data
        }
        return normal_response(data)

@is_auth_return_user_id()
@api_view(['GET'])
def get_employee_data(request, user_id):
    if request.method == 'GET':
        emp  = Employee.objects.get(pk = user_id)
        data = {
            "id":         emp.pk, 
            "first_name": emp.first_name, 
            "last_name":  emp.last_name, 
            "phone":      emp.phone
        }
        
        return normal_response({"employee": data})
    
@is_auth_return_user_id()
@api_view(['GET'])
def get_employee_data_for_bar_chart(request, user_id):
    if request.method == 'GET':
        emp = Employee.objects.get(pk=user_id)
        
        current_date = datetime.now().date()
        
        data = []
        for i in range(7):
            date_to_check = current_date - timedelta(days = 6 - i) 
            
            scan_count = Scan.objects.filter(
                employee            = emp,
                scan_datetime__date = date_to_check
            ).count()
            
            data.append({
                'date':       date_to_check,
                'scan_count': scan_count
            })
        
        return normal_response(data)


    

@is_auth_return_user_id()
@api_view(['GET'])
def get_scans_from_employee(request, user_id):
    if request.method == 'GET':
        emp   = Employee.objects.get(pk = user_id)
        scans = Scan.objects.filter(employee = emp)
        
        data = []
        for scan in scans:
            scan_data = {
                "scan_id":       scan.pk,
                "scan_datetime": scan.scan_datetime,
            }
            data.append(scan_data)
            
        return normal_response({"scans_by_employee": data})

@is_auth()
@api_view(['GET'])
def get_products_and_prices_from_scan(request, scan_id):
    if request.method == 'GET':
        scan     = Scan.objects.get(pk = scan_id)
        products = Product.objects.filter(scan = scan)
        
        data = []
        for product in products:
            price = Price.objects.get(product = product)
            
            product_data = {
                "product_id":       product.pk,
                "name":             product.name,
                "sku":              product.sku,
                "price":            price.price,
                "is_special_offer": price.is_special_offer,
                "date_price":       price.date_price
            }
            data.append(product_data)
            
        return normal_response({"products": data})
    
    
@csrf_exempt
@is_auth()
@api_view(['DELETE'])
def delete_product(request, product_id):
    try:
        product = Product.objects.get(pk=product_id)
        product.delete()
        # Also delete associated price if it exists
        Price.objects.filter(product_id=product_id).delete()
        return normal_response("Запись удалена")
    except Product.DoesNotExist:
        return error_response("Продукт не найден")

@csrf_exempt
@is_auth()
@api_view(['PUT'])
def update_product(request, product_id):
    data = request.data
    try:
        product      = Product.objects.get(pk=product_id)
        product.name = data.get('name', product.name)
        product.sku  = data.get('sku', product.sku)
        product.save()

        if 'price' in data:
            price_data             = data['price']
            price, _               = Price.objects.get_or_create(product=product)
            price.price            = price_data.get('price', price.price)
            price.is_special_offer = price_data.get('is_special_offer', price.is_special_offer)
            price.date_price       = price_data.get('date_price', price.date_price)
            price.save()

        return normal_response("Запись обнавлена")
    except Product.DoesNotExist:
        return error_response("Продукт не найден")

@csrf_exempt 
@is_auth_return_user_id()
@api_view(['POST'])
def photo_process(request, user_id):
    data = request.data
    
    print(os.getcwd())
    print("processing photo...")
    
    img_bytes    = str.encode(data["img_base64"])
    filename_cnt = len([name for name in os.listdir(SCANS_DIR) if os.path.isfile(os.path.join(SCANS_DIR, name))])
    
    location = Location.objects.get(pk = data["location_id"])
    employee = Employee.objects.get(pk = user_id)
    
    #TODO: После обучения ИИ добавить цикл for для несколько продуктов, логику обработки ИИ, обьектов и текста 
    
    with open(f"{SCANS_DIR}\\image_{filename_cnt+1}.jpg", "wb") as fh:
        fh.write(base64.decodebytes(img_bytes))
        photo = Photo.objects.create(photo_path = f"{SCANS_DIR}\\image_{filename_cnt+1}.jpg")
        
    scan = Scan.objects.create(
        scan_datetime = datetime.now(), 
        location      = location, 
        employee      = employee, 
        photo         = photo, 
        product       = Product.objects.get(pk=1)
    )
    
    return normal_response({"scan_id": scan.pk})


@csrf_exempt 
@is_auth()
@api_view(['POST'])
def send_product_photo(request):
    data = request.data
    
    print(os.getcwd())
    print("processing photo...")
    
    scan = Scan.objects.get(pk = data["scan_id"])
    
    img_bytes    = str.encode(data["img_base64"])
    filename_cnt = len([name for name in os.listdir(SCANS_DIR) if os.path.isfile(os.path.join(SCANS_DIR, name))])
    
    #TODO: После обучения ИИ добавить цикл for для несколько продуктов, логику обработки ИИ, обьектов и текста 
    
    with open(f"{SCANS_DIR}\\image_{filename_cnt+1}.jpg", "wb") as fh:
        fh.write(base64.decodebytes(img_bytes))
        photo = Photo.objects.create(photo_path = f"{SCANS_DIR}\\image_{filename_cnt+1}.jpg")
        
    product = Product.objects.create(
        name = "Тест", 
        sku  = "123", 
        scan = scan
    )
    Price.objects.create(
        product          = product, 
        price            = 2500, 
        is_special_offer = False, 
        date_price       = datetime.now().date()
    )

    return normal_response("created")
