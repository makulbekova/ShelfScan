from django.db import models

class Role(models.Model):
    name = models.CharField(max_length=255)

class Employee(models.Model):
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=255)
    hashed_password = models.CharField(max_length=255)
    role = models.ForeignKey(Role, on_delete=models.RESTRICT)

class City(models.Model):
    name = models.CharField(max_length=255)

class Location(models.Model):
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    city = models.ForeignKey(City, on_delete=models.RESTRICT)

class Photo(models.Model):
    photo_path = models.CharField(max_length=255)

class Scan(models.Model):
    scan_datetime = models.DateTimeField()
    location = models.ForeignKey(Location, on_delete=models.RESTRICT)
    employee = models.ForeignKey(Employee, on_delete=models.RESTRICT)
    photo = models.ForeignKey(Photo, on_delete=models.RESTRICT)

class Remark(models.Model):
    scan = models.ForeignKey(Scan, on_delete=models.RESTRICT)
    remark = models.TextField()

class Planogram(models.Model):
    photo_path = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    description = models.TextField()
    location = models.ForeignKey(Location, on_delete=models.RESTRICT)

class Product(models.Model):
    name = models.CharField(max_length=255)
    sku = models.CharField(max_length=255)
    scan = models.ForeignKey(Scan, on_delete=models.RESTRICT)

class Price(models.Model):
    product = models.ForeignKey(Product, on_delete=models.RESTRICT)
    price = models.FloatField()
    is_special_offer = models.BooleanField()
    date_price = models.DateField()