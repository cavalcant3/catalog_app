import 'dart:convert';


class Product {
  final String? id;
  String name;
  String? description;
  double price;


  Product({this.id, required this.name, this.description, required this.price});


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }


  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'name': name,
    'description': description,
    'price': price,
  };


  @override
  String toString() => jsonEncode(toJson());
}