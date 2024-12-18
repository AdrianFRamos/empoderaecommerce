import 'package:empoderaecommerce/controller/loginController.dart';
import 'package:empoderaecommerce/controller/productController.dart';
import 'package:empoderaecommerce/controller/sessionController.dart';
import 'package:empoderaecommerce/models/productModel.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:empoderaecommerce/screens/cartScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      print('Usuário carregado da sessão: $_user');
      setState(() {});
    } catch (e) {
      print('Erro ao carregar sessão: $e');
      Get.snackbar(
        'Erro',
        'Falha ao carregar o usuário: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _loadProducts() async {
    try {
      //final productcontroller = Productcontroller();
      //final products = await productcontroller.getProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
      });
      print('Produtos carregados: ${_products.length}');
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
    SaveUserSession.clearSession();
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
            _buildDrawerItem(Icons.point_of_sale, 'Venda Voce', onTap: () {
              Navigator.pushNamed(context, '/categories');
            }),
            _buildDrawerItem(Icons.point_of_sale, 'Anuncios', onTap: () {
              Navigator.pushNamed(context, '/publish');
            }),
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
    height: 100, 
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(), 
      itemCount: _categoryItems.length, 
      itemBuilder: (context, index) {
        final category = _categoryItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30, 
                backgroundColor: Colors.grey.shade200, 
                child: Icon(category['icon'], size: 30, color: Colors.blue),
              ),
              SizedBox(height: 5),
              Text(
                category['label'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    ),
  );
}

final List<Map<String, dynamic>> _categoryItems = [
  {'label': 'Mercado', 'icon': Icons.local_grocery_store},
  {'label': 'Cupons', 'icon': Icons.local_offer},
  {'label': 'Moda', 'icon': Icons.checkroom},
  {'label': 'Celulares', 'icon': Icons.phone_android},
  {'label': 'Veículos', 'icon': Icons.directions_car},
  {'label': 'Compota', 'icon': FontAwesomeIcons.bottleWater,},
];

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
    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum produto disponível',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

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
                        image: AssetImage('assets/product.png'),
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
                        'R\$ ${product.price}',
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

  final List<Product> products = [
    Product(
      id: 1,
      name: 'Produto 1',
      description: 'Descrição do Produto 1',
      category: 'Categoria 1',
      price: '10.99', 
      stock: '1',
    ),
    Product(
      id: 2,
      name: 'Produto 2',
      description: 'Descrição do Produto 2',
      category: 'Categoria 2',
      price: '19.99',
      stock: '1',
    ),
    Product(
      id: 3,
      name: 'Produto 3',
      description: 'Descrição do Produto 3',
      category: 'Categoria 3',
      price: '5.99',
      stock: '1',
    ),
    Product(
      id: 4,
      name: 'Produto 4',
      description: 'Descrição do Produto 4',
      category: 'Categoria 4',
      price: '15.99',
      stock: '1',
    ),
  ];
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
