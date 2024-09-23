import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:empoderaecommerce/models/productModel.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _price;
  late Product _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product = ModalRoute.of(context)!.settings.arguments as Product;
    _name = _product.name;
    _description = _product.description;
    _price = _product.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: _description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                initialValue: _price,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) => _price = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Update product in database
                    _updateProduct();
                  }
                },
                child: const Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    // Update product in database
    final database = DatabaseHelper.instance;
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
