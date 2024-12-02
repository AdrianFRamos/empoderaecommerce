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
    try {
      _user = await SaveUserSession.getUserFromSession();
      setState(() {});
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao carregar o usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _loadProducts() async {
    try {
      final productcontroller = Productcontroller();
      final products = await productcontroller.getProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
      });
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao carregar produtos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _logout() {
    _loginController.emailController.clear();
    _loginController.passwordController.clear();
    SaveUserSession.clearSession(); // Certifique-se de que esta função limpa a sessão.
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
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow[700]),
              accountName: Text(_user?.name ?? 'Usuário'),
              accountEmail: Text(_user?.email ?? 'email@exemplo.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (_user?.avatarUrl ?? "A")[0],
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              onDetailsPressed: () {
                if (_user != null) {
                  Navigator.pushNamed(context, '/profile', arguments: _user);
                } else {
                  Get.snackbar(
                    'Erro',
                    'Nenhum usuário logado.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
            _buildDrawerItem(Icons.search, 'Buscar'),
            _buildDrawerItem(Icons.shopping_bag, 'Minhas compras'),
            _buildDrawerItem(Icons.favorite, 'Favoritos'),
            _buildDrawerItem(Icons.local_offer, 'Ofertas do dia'),
            _buildDrawerItem(Icons.history, 'Historico'),
            _buildDrawerItem(Icons.point_of_sale, 'Venda Voce'),
            _buildDrawerItem(Icons.help, 'Ajuda'),
            _buildDrawerItem(Icons.calendar_today, 'Calendário', onTap: () {
              Navigator.pushNamed(context, '/calendar');
            }),
            const Divider(),
            _buildDrawerItem(Icons.logout, 'Logout', onTap: _logout),
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
                const Icon(Icons.location_on, color: Colors.black54),
                const SizedBox(width: 5),
                Text(
                  'Endereço',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCategoryIcons(),
            const SizedBox(height: 20),
            _buildPromotionsBanner(),
            const SizedBox(height: 20),
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryIcon('Supermercado', Icons.local_grocery_store),
          _buildCategoryIcon('Cupons', Icons.local_offer),
          _buildCategoryIcon('Moda', Icons.checkroom),
          _buildCategoryIcon('Celulares', Icons.phone_android),
          _buildCategoryIcon('Veículos', Icons.directions_car),
        ],
      ),
    );
  }

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
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildPromotionsBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.white),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'OFERTAS DO DIA',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
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
                      image: DecorationImage(
                        image: AssetImage('assets/product.png'), // Verifique o caminho da imagem
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'R\$ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.green),
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

  Widget _buildDrawerItem(IconData icon, String title,
      {bool hasNotification = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Row(
        children: [
          Text(title),
          if (hasNotification)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
