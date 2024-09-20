import 'package:flutter/material.dart';
import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/manageProductScreen.dart';
import 'package:empoderaecommerce/cartScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadUser();
  }

  Future<void> _loadProducts() async {
    final database = DatabaseHelper.instance;
    final products = await database.getProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  Future<void> _loadUser() async {
    // Exemplo de como carregar o usuário logado
    final database = DatabaseHelper.instance;
    final user = await database.getUserByEmailAndPassword('user@example.com', 'password'); // Substitua pelos dados reais
    setState(() {
      _user = user;
    });
  }

  void _filterProducts(String query) {
    final filteredProducts = _products.where((product) {
      final productName = product.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      return productName.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredProducts = filteredProducts;
    });
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
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                if (_user != null) {
                  Navigator.pushNamed(
                    context,
                    '/edit_profile',
                    arguments: _user,
                  );
                }
              },
            ),
            ListTile(
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageProductsScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
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
              onChanged: _filterProducts,
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
                    trailing: Text('\$${product.price.toStringAsFixed(2)}'),
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
