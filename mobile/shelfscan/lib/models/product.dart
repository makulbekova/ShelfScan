import 'dart:convert';

class Product {
  final int productId;
  final String name;
  final String sku;
  final double price;
  final bool isSpecialOffer;
  final DateTime datePrice;

  Product({
    required this.productId,
    required this.name,
    required this.sku,
    required this.price,
    required this.isSpecialOffer,
    required this.datePrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId:      json['product_id'] ?? 0,
      name:           json['name'] ?? '',
      sku:            json['sku'] ?? '',
      price:          json['price'] ?? 0.0,
      isSpecialOffer: json['is_special_offer'] ?? false,
      datePrice:      DateTime.parse(json['date_price'] ?? ''),
    );
  }
}

List<Product> productFromJson(String jsonString) {
  final Map<String, dynamic> parsed = json.decode(jsonString);
  final List<dynamic> productsData  = parsed['data']['products'];

  return productsData.map((item) => Product.fromJson(item)).toList();
}
