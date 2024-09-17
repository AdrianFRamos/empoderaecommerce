import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
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

  _loadCart() async {
    // Load cart from database
    final database = await DatabaseHelper.instance;
    _cart = await database.getCart();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: _cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_cart[index].name),
            subtitle: Text('Price: ${_cart[index].price}'),
            trailing: IconButton(
              icon: Icon(Icons.remove),
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
        child: Icon(Icons.checkout),
      ),
    );
  }

  _removeFromCart(Product product) async {
    // Remove product from cart
    final cart = await DatabaseHelper.instance.getCart();
    cart.remove(product);
    await DatabaseHelper.instance.updateCart(cart);
    setState(() {});
  }
}