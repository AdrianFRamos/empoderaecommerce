import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(_product.description),
            Text('Price: ${_product.price}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add product to cart
                _addToCart(_product);
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  _addToCart(Product product) async {
    // Add product to cart
    final cart = await DatabaseHelper.instance.getCart();
    cart.add(product);
    await DatabaseHelper.instance.updateCart(cart);
    // Navigate to cart screen
    Navigator.pushNamed(context, '/cart');
  }
}