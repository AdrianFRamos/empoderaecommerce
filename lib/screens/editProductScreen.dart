import 'package:empoderaecommerce/controller/productController.dart';
import 'package:empoderaecommerce/models/productModel.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name, _description, _price, _stock;
  late Product _product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recebe o produto passado como argumento
    _product = ModalRoute.of(context)!.settings.arguments as Product;

    // Preenche os campos com os valores existentes do produto
    _name = _product.name;
    _description = _product.description;
    _price = _product.price.toString();
    _stock = _product.stock ?? '0'; // Garante que o estoque não seja nulo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Editar Produto',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: 'Nome do Produto',
                initialValue: _name,
                onSaved: (value) => _name = value!,
              ),
              _buildTextField(
                label: 'Descrição',
                initialValue: _description,
                onSaved: (value) => _description = value!,
              ),
              _buildTextField(
                label: 'Preço',
                initialValue: _price,
                inputType: TextInputType.number,
                onSaved: (value) => _price = value!,
                validator: (value) => _validateNumericField(value, 'Preço'),
              ),
              _buildTextField(
                label: 'Estoque',
                initialValue: _stock,
                inputType: TextInputType.number,
                onSaved: (value) => _stock = value!,
                validator: (value) => _validateNumericField(value, 'Estoque'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _validateAndSave,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Atualizar Produto',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        keyboardType: inputType,
        initialValue: initialValue,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'O campo $label é obrigatório';
              }
              return null;
            },
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String? _validateNumericField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'O campo $fieldName é obrigatório';
    } else if (double.tryParse(value) == null) {
      return 'O campo $fieldName deve ser um número válido';
    }
    return null;
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _updateProduct();
    }
  }

  Future<void> _updateProduct() async {
    try {
      final productController = Productcontroller();
      final updatedProduct = Product(
        id: _product.id,
        name: _name,
        description: _description,
        category: _product.category,
        price: _price,
        stock: _stock,
      );

      await productController.updateProduct(updatedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto atualizado com sucesso!')),
      );
      Navigator.pushNamed(context, '/products');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar produto: $e')),
      );
    }
  }
}