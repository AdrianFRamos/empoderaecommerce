import 'package:flutter/foundation.dart';

class Product {
  final int? id;
  final String name;
  final String description;
  final String category;
  final double price;

  Product({this.id, required this.name, required this.description,required this.category, required this.price});

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
    );
  }
}