import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _description, _price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) => _price = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // Add product to database
                    _addProduct();
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addProduct() async {
    // Add product to database
    final database = await DatabaseHelper.instance;
    final product = Product(
      name: _name,
      description: _description,
      price: double.parse(_price),
    );
    await database.addProduct(product);
    // Navigate to products screen
    Navigator.pushNamed(context, '/products');
  }
}