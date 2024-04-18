import 'dart:convert';

class Location {
  final int id;
  final String name;
  final String address;
  final DateTime lastScanDatetime;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.lastScanDatetime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id:               json['id'] ?? 0,
      name:             json['name'] ?? '',
      address:          json['address'] ?? '',
      lastScanDatetime: DateTime.parse(json['last_scan_datetime'] ?? ''),
    );
  }
}

List<Location> locationFromJson(String jsonString) {
  final parsed = json.decode(jsonString);
  final List<dynamic> data = parsed['data'];

  return data.map<Location>((item) => Location.fromJson(item)).toList();
}
