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
import 'package:empoderaecommerce/registerScreen.dart';
import 'package:empoderaecommerce/homeScreen.dart';
import 'package:empoderaecommerce/helper/databaseHelper.dart'; 
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inicialize o databaseFactory para sqflite_common_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

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
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/products': (context) => const ProductScreen(),
        '/product_details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/edit_product': (context) => const EditProductScreen(),
        '/manage_products': (context) => const ManageProductsScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) {
              return ProfileScreen(user: user);
            },
          );
        }
        return null;
      },
    );
  }
}
