import 'package:flutter/material.dart';

class ManageProductsScreen extends StatefulWidget {
  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    // Load products from database
    final database = await DatabaseHelper.instance;
    _products = await database.getProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_products[index].name),
            subtitle: Text(_products[index].description),
            trailing: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit product screen
                    Navigator.pushNamed(context, '/edit_product', arguments: _products[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Delete product from database
                    _deleteProduct(_products[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product screen
          Navigator.pushNamed(context, '/add_product');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _deleteProduct(Product product) async {
    // Delete product from database
    final database = await DatabaseHelper.instance;
    await database.deleteProduct(product);
    setState(() {});
  }
}