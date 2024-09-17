import 'package:flutter/material.dart';
import 'package:your_app/login_screen.dart';
import 'package:your_app/product_screen.dart';
import 'package:your_app/product_details_screen.dart';
import 'package:your_app/cart_screen.dart';
import 'package:your_app/checkout_screen.dart';
import 'package:your_app/add_product_screen.dart';
import 'package:your_app/edit_product_screen.dart';
import 'package:your_app/manage_products_screen.dart';
import 'package:your_app/profile_screen.dart';
import 'package:your_app/edit_profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => LoginScreen(),
        '/products': (context) => ProductScreen(),
        '/product_details': (context) => ProductDetailsScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
        '/add_product': (context) => AddProductScreen(),
        '/edit_product': (context) => EditProductScreen(),
        '/manage_products': (context) => ManageProductsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
      },
    );
  }
}