import 'package:empoderaecommerce/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:empoderaecommerce/helper/databaseHelper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    // Load cart from database
    final database = DatabaseHelper.instance;
    _cart = await database.getCart();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: _cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_cart[index].name),
            subtitle: Text('Price: ${_cart[index].price}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                // Remove product from cart
                _removeFromCart(_cart[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to checkout screen
          Navigator.pushNamed(context, '/checkout');
        },
        child: const Icon(Icons.check_circle),
      ),
    );
  }

  Future<void> _removeFromCart(Product product) async {
    // Remove product from cart
    final database = DatabaseHelper.instance;
    await database.removeProductFromCart(product.id!);
    _cart = await database.getCart();
    setState(() {});
  }
}
