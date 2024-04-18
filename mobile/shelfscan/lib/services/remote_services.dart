import 'dart:convert';

import 'package:ShelfScan/models/employee.dart';
import 'package:ShelfScan/models/location.dart';
import 'package:ShelfScan/models/product.dart';
import 'package:ShelfScan/models/scan.dart';
import 'package:ShelfScan/models/scan_info.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class RemoteServices
{
  final Box _boxAuth = Hive.box("auth");
  String host = 'http://192.168.1.91:8000/api/';   // home wifi
  // String host = 'http://192.168.237.83:8000/api/';  // mobile
  // String host = 'http://192.168.1.103:8000/api/';  // Inar
  
  Future<List<Location>?> getLocations() async{
    var client = http.Client();

    var uri = Uri.parse('${host}locations'); 
    var response = await client.get(
      uri, 
      headers: {'Authorization': 'Bearer ${_boxAuth.get("token")}'},
    );

    if(response.statusCode == 200){
      var json = response.body;
      return locationFromJson(json);
    }
    return null;
  }


  Future<List<Scan>?> getScansFromLocation(int locationId) async {
    var client = http.Client();
    var uri = Uri.parse('${host}get_scans_from_location/${locationId}');
    var response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer ${_boxAuth.get("token")}'},
    );

    if (response.statusCode == 200) {
      var json = response.body;
      return scanFromJson(json);
    }
    return null;
  }

  Future<ScanInfo?> getScanInfo(int scanId) async {

    var client = http.Client();
    var uri = Uri.parse('${host}get_scan_info/${scanId}');
    var response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer ${_boxAuth.get("token")}'},
    );

    if (response.statusCode == 200) {
      var json = response.body;
      return scanInfoFromJson(json);
    }
    return null;
  }



  Future<List<Product>?> getProductsFromScan(int scanId) async {
    var client = http.Client();
    var uri = Uri.parse('${host}get_products_and_prices_from_scan/${scanId}');
    var response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer ${_boxAuth.get("token")}'},
    );

    if (response.statusCode == 200) {
      var json = response.body;
      return productFromJson(json);
    }
    return null;
  }

  Future<String?> deleteProduct(int productId) async {
    try {
      var response = await http.delete(
        Uri.parse('${host}delete_product/$productId'),
        headers: {
          'Authorization': 'Bearer ${_boxAuth.get("token")}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to delete product: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    }
  }

  Future<String?> updateProduct(int productId, Map<String, dynamic> data) async {
    try {
      var response = await http.put(
        Uri.parse('${host}update_product/$productId'),
        headers: {
          'Authorization': 'Bearer ${_boxAuth.get("token")}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to update product: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to update product: $error');
    }
  }


  Future<String?> login(String phone, String password) async {
    var client = http.Client();
    var uri = Uri.parse('${host}login');
    var data = {'phone': phone, 'password': password};

    try {
      var response = await client.post(
        uri,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var token = responseData['data']['token'] as String?;
        if (token != null) {
          await saveTokenToLocal(token);
          return token;
        }
      } else if (response.statusCode == 400){
        var responseData = jsonDecode(response.body);
        print('HTTP ${response.statusCode}: ${responseData['message']}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }

    return null;
  }

  Future<void> saveTokenToLocal(String token) async {
    await _boxAuth.put('token', token);
  }


  Future<Employee?> getEmployeeData() async {
    var client = http.Client();
    var uri = Uri.parse('${host}get_employee_data');

    try {
      var response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${_boxAuth.get("token")}'
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body)['data']['employee'];
        return Employee.fromJson(responseData);
      } else {
        print('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } finally {
      client.close();
    }

    return null;
  }

  Future<List<Map<String, dynamic>>?> getScanCountsForLastSevenDays() async {
    var client = http.Client();
    var uri = Uri.parse('${host}get_employee_data_for_bar_chart');

    try {
      var response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${_boxAuth.get("token")}'
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse['data']);
      } else {
        throw Exception('Failed to fetch scan counts: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch scan counts: $error');
    }
  }


  Future<String> uploadAndProcessProductPhoto(int scanId, String imgBase64) async {
    try {
      Map<String, dynamic> requestBody = {
        'scan_id': scanId,
        'img_base64': imgBase64,
      };

      String requestBodyJson = json.encode(requestBody);

      var response = await http.post(
        Uri.parse('${host}send_product_photo'), 
        headers: {
          'Authorization': 'Bearer ${_boxAuth.get("token")}',
          "content-type" : "application/json",
        },
        body: requestBodyJson, 
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to upload and process photo: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to upload and process photo: $error');
    }
  }

  Future<int?> uploadAndProcessRealogramPhoto(int locationId, String imgBase64) async {
    try {
      Map<String, dynamic> requestBody = {
        'location_id': locationId,
        'img_base64': imgBase64,
      };

      String requestBodyJson = json.encode(requestBody);

      var response = await http.post(
        Uri.parse('${host}photo_process'), 
        headers: {
          'Authorization': 'Bearer ${_boxAuth.get("token")}',
          "content-type" : "application/json",
        },
        body: requestBodyJson, 
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var scanId = responseData['data']['scan_id'] as int?;
        return scanId;
      } else {
        throw Exception('Failed to upload and process photo: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Failed to upload and process photo: $error');
    }
  }



}