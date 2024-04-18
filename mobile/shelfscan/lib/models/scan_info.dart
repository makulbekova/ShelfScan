import 'dart:convert';

class ScanInfo {
  final String name;
  final String fullAddress;
  final DateTime scanDate;
  final String photoBase64; 

  ScanInfo({
    required this.name,
    required this.fullAddress,
    required this.scanDate,
    required this.photoBase64, 
  });

  factory ScanInfo.fromJson(Map<String, dynamic> json) {
    return ScanInfo(
      name:        json['name'],
      fullAddress: json['full_address'],
      scanDate:    DateTime.parse(json['scan_date'] ?? ''),
      photoBase64: json['photo_base64'],
    );
  }
}

ScanInfo scanInfoFromJson(String jsonString) {
  final Map<String, dynamic> parsed = json.decode(jsonString);
  final Map<String, dynamic> data   = parsed['data'];
  
  return ScanInfo.fromJson(data);
}
