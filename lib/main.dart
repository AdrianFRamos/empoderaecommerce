import 'package:empoderaecommerce/models/userModel.dart';
import 'package:empoderaecommerce/screens/addProductScreen.dart';
import 'package:empoderaecommerce/screens/calendarScreen.dart';
import 'package:empoderaecommerce/screens/cartScreen.dart';
import 'package:empoderaecommerce/screens/checkoutScreen.dart';
import 'package:empoderaecommerce/screens/editProductScreen.dart';
import 'package:empoderaecommerce/screens/editProfileScreen.dart';
import 'package:empoderaecommerce/screens/loginScreen.dart';
import 'package:empoderaecommerce/screens/manageProductScreen.dart';
import 'package:empoderaecommerce/screens/productDetailScreen.dart';
import 'package:empoderaecommerce/screens/productScreen.dart';
import 'package:empoderaecommerce/screens/profileScreen.dart';
import 'package:empoderaecommerce/screens/registerScreen.dart';
import 'package:empoderaecommerce/screens/homeScreen.dart';
import 'package:empoderaecommerce/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
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
        '/calendar': (context) => const CalendarScreen(),
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
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Página não encontrada')),
            body: const Center(child: Text('404 - Página não encontrada')),
          ),
        );
      },
    );
  }
}
