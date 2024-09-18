import 'package:empoderaecommerce/addProductScreen.dart';
import 'package:empoderaecommerce/cartScreen.dart';
import 'package:empoderaecommerce/checkoutScreen.dart';
import 'package:empoderaecommerce/editProductScreen.dart';
import 'package:empoderaecommerce/editProfileScreen.dart';
import 'package:empoderaecommerce/loginScreen.dart';
import 'package:empoderaecommerce/manageProductScreen.dart';
import 'package:empoderaecommerce/productDetailScreen.dart';
import 'package:empoderaecommerce/productScreen.dart';
import 'package:empoderaecommerce/profileScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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