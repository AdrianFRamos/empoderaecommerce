import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String category;
  final int userId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.userId
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'userId': userId,
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
      stock: map['stock'] ?? '0',
      userId: map['userId'] ?? '0',
      category: map['category'] ?? 'Sem categoria',
    );
  }
}