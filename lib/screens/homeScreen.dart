import 'package:empoderaecommerce/controller/loginController.dart';
import 'package:empoderaecommerce/controller/productController.dart';
import 'package:empoderaecommerce/controller/sessionController.dart';
import 'package:empoderaecommerce/models/productModel.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:empoderaecommerce/screens/manageProductScreen.dart';
import 'package:empoderaecommerce/screens/cartScreen.dart';
import 'package:flutter/material.dart';
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
    _loadUser();
    _loadProducts();
  }

  Future<void> _loadUser() async {
    _user = await SaveUserSession.getUserFromSession();
    setState(() {});
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
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar Empodera',
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
            ),
          ],
        ),
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
                  Get.toNamed(
                    '/edit_profile',
                    arguments: _user,
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
            ListTile(
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageProductsScreen()));
              },
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
            ),
            ListTile(
              title: const Text('Calendário'),
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Localização e Banner Principal
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black54),
                const SizedBox(width: 5),
                Text(
                  'Endereço',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Categorias
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryIcon('Supermercado', Icons.local_grocery_store),
                  _buildCategoryIcon('Cupons', Icons.local_offer),
                  _buildCategoryIcon('Moda', Icons.checkroom),
                  _buildCategoryIcon('Celulares', Icons.phone_android),
                  _buildCategoryIcon('Veículos', Icons.directions_car),
                  // Adicione no banco
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Promoções 
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'OFERTAS DO DIA',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildProductList(),

            const SizedBox(height: 20),

            _buildProductList(),
          ],
        ),
      ),
    );
  }

  // Widget para um ícone de categoria
  Widget _buildCategoryIcon(String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 30,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  // Widget para a lista de produtos
  Widget _buildProductList() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Número de produtos que você deseja mostrar
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      image: const DecorationImage(
                        image: AssetImage('assets/product.png'), // Substitua pela imagem do produto
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nome do Produto',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'R\$ 99,90',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
