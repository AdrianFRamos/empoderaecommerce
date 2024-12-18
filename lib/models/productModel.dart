import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String stock;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Produto sem nome',
      description: map['description'] ?? 'Sem descrição',
      price: map['price']?.toString() ?? '0.0',
      stock: map['stock']?.toString() ?? '0',
      category: map['category'] ?? 'Sem categoria',
    );
  }
}