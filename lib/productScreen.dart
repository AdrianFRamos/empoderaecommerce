import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    // Load products from database or API
    final database = await DatabaseHelper.instance;
    _products = await database.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index].name),
            subtitle: Text(_products[index].description),
            onTap: () {
              // Navigate to product details screen
              Navigator.pushNamed(context, '/product_details', arguments: _products[index]);
            },
          );
        },
      ),
    );
  }
}