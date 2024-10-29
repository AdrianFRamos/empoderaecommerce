import 'package:empoderaecommerce/const/saveUserSession.dart';
import 'package:empoderaecommerce/controller/loginController.dart';
import 'package:empoderaecommerce/controller/productController.dart';
import 'package:empoderaecommerce/models/productModel.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:empoderaecommerce/screens/manageProductScreen.dart';
import 'package:empoderaecommerce/screens/cartScreen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginController _loginController = Get.put(LoginController());
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser(); // Carrega o usuário logado
    _loadProducts(); // Carrega os produtos
  }

  Future<void> _loadUser() async {
    _user = await SaveUserSession.getUserFromSession();
    setState(() {}); // Atualiza o estado para refletir o usuário
  }

  Future<void> _loadProducts() async {
    final productcontroller = Productcontroller();
    final products = await productcontroller.getProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _logout() {
    _loginController.emailController.clear();
    _loginController.passwordController.clear();
    Get.offAllNamed('/login'); // Redireciona para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            const Divider(),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                if (_user != null) {
                  Get.toNamed(
                    '/edit_profile',
                    arguments: _user, // Passa o usuário como argumento
                  );
                } else {
                  Get.snackbar(
                    'Erro',
                    'Usuário não encontrado',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageProductsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Calendário'),
              onTap: () {
                Navigator.pushNamed(context, '/calendar'); 
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: _logout, // Chama a função de logout
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _filteredProducts = _products
                      .where((product) => product.name
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.description),
                    trailing: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
