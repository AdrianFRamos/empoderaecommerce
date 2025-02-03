import 'package:empoderaecommerce/models/userModel.dart';
import 'package:empoderaecommerce/controller/authController.dart';
import 'package:empoderaecommerce/screens/DeliveryOptionsScreen.dart';
import 'package:empoderaecommerce/screens/ProductConfirmationScreen.dart';
import 'package:empoderaecommerce/screens/ProductPriceStockScreen.dart';
import 'package:empoderaecommerce/screens/SearchProductScreen.dart';
import 'package:empoderaecommerce/screens/addProductScreen.dart';
import 'package:empoderaecommerce/screens/calendarScreen.dart';
import 'package:empoderaecommerce/screens/cartScreen.dart';
import 'package:empoderaecommerce/screens/categoriesScreen.dart';
import 'package:empoderaecommerce/screens/checkoutScreen.dart';
import 'package:empoderaecommerce/screens/confirmAdScreen.dart';
import 'package:empoderaecommerce/screens/editEnderecosScreen.dart';
import 'package:empoderaecommerce/screens/editProductScreen.dart';
import 'package:empoderaecommerce/screens/editProfileScreen.dart';
import 'package:empoderaecommerce/screens/enderecosScreen.dart';
import 'package:empoderaecommerce/screens/loginScreen.dart';
import 'package:empoderaecommerce/screens/manageProductScreen.dart';
import 'package:empoderaecommerce/screens/myproductScreen.dart';
import 'package:empoderaecommerce/screens/productDetailScreen.dart';
import 'package:empoderaecommerce/screens/productScreen.dart';
import 'package:empoderaecommerce/screens/profileScreen.dart';
import 'package:empoderaecommerce/screens/registerScreen.dart';
import 'package:empoderaecommerce/screens/homeScreen.dart';
import 'package:empoderaecommerce/screens/searchresultsScreen.dart';
import 'package:empoderaecommerce/screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('✅ Firebase inicializado com sucesso!');
  } catch (e) {
    print('❌ Erro ao inicializar o Firebase: $e');
  }

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  Sqflite.setDebugModeOn(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Empodera Ecommerce',
      theme: ThemeData(primarySwatch: Colors.blue),
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
        '/enderecos': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as int?;
          if (userId != null) {
            return EnderecosScreen(userId: userId);
          } else {
            return const LoginScreen(); 
          }
        },
        '/edit_enderecos': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args == null || !args.containsKey('userId')) {
            print("⚠️ Argumentos inválidos para EditEnderecosScreen. Redirecionando para Home.");
            return const HomeScreen();
          }

          return EditEnderecosScreen(
            isEditing: args['isEditing'] ?? false,
          );
        },
        '/categories': (context) => CategoriesScreen(),
        '/search_product': (context) {
          final category = ModalRoute.of(context)?.settings.arguments as String?;
          return SearchProductScreen(category: category ?? '');
        },
        '/search_results': (context) {
          final category = ModalRoute.of(context)?.settings.arguments as String?;
          return SearchResultsScreen(category: category ?? '');
        },
        '/product_confirmation': (context) {
          final product = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ProductConfirmationScreen(product: product ?? {});
        },
        '/product_price_stock': (context) {
          final product = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ProductPriceStockScreen(product: product ?? {});
        },
        '/delivery_options': (context) {
          final product = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return DeliveryOptionsScreen(product: product ?? {});
        },
        '/confirm_ad': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ConfirmAdScreen(
            product: arguments?['product'] ?? {},
            deliveryOptions: arguments?['deliveryOptions'] ?? {},
          );
        },
        '/my_products': (context) => const MyProductsScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) {
              return FutureBuilder<UserModel?>(
                future: _getUserFromSession(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError || snapshot.data == null) {
                    print("⚠️ Nenhum usuário logado encontrado na sessão.");
                    return const LoginScreen();
                  } else {
                    return ProfileScreen(user: snapshot.data!);
                  }
                },
              );
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

  // 🔹 Obtém o usuário logado da sessão
  Future<UserModel?> _getUserFromSession() async {
    final authController = Get.put(AuthController());
    return await authController.getUserFromSession();
  }
}
