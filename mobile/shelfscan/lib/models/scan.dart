import 'dart:convert';

class Scan {
  final int scanId;
  final DateTime scanDatetime;
  final int remarksCount;
  final int productsCount;

  Scan({
    required this.scanId,
    required this.scanDatetime,
    required this.remarksCount,
    required this.productsCount,
  });

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      scanId:        json['scan_id'] ?? 0,
      scanDatetime:  DateTime.parse(json['scan_datetime'] ?? ''),
      remarksCount:  json['remarks_count'] ?? 0,
      productsCount: json['products_count'] ?? 0,
    );
  }
}

List<Scan> scanFromJson(String jsonString) {
  final Map<String, dynamic> parsed = json.decode(jsonString);
  final List<dynamic> data = parsed['data'];
  
  return data.map((item) => Scan.fromJson(item)).toList();
}


