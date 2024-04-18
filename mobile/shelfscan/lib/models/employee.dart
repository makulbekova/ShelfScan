import 'dart:convert';

class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id:        json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName:  json['last_name'] ?? '',
      phone:     json['phone'] ?? '',
    );
  }
}

List<Employee> employeeFromJson(String jsonString) {
  final parsed = json.decode(jsonString);
  final List<dynamic> data = parsed['data'];
  
  return data.map<Employee>((item) => Employee.fromJson(item)).toList();
}
