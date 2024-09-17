import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _description, _price;
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
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                initialValue: _product.name,
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
                initialValue: _product.description,
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
                initialValue: _product.price.toString(),
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
                    // Update product in database
                    _updateProduct();
                  }
                },
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateProduct() async {
    // Update product in database
    final database = await DatabaseHelper.instance;
    final product = Product(
      id: _product.id,
      name: _name,
      description: _description,
      price: double.parse(_price),
    );
    await database.updateProduct(product);
    // Navigate to products screen
    Navigator.pushNamed(context, '/products');
  }
}