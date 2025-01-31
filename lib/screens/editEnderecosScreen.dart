import 'package:empoderaecommerce/controller/adressController.dart';
import 'package:empoderaecommerce/controller/authController.dart';
import 'package:empoderaecommerce/models/adressModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditEnderecosScreen extends StatefulWidget {
  final bool isEditing;

  EditEnderecosScreen({Key? key, required this.isEditing}) : super(key: key);

  @override
  _EditEnderecosScreenState createState() => _EditEnderecosScreenState();
}

class _EditEnderecosScreenState extends State<EditEnderecosScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  bool semNumero = false;
  int? _addressId;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarDados();
  }

  void _carregarDados() async {
    if (_isLoading) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        final isEditing = args['isEditing'] ?? false;
        final addressId = args['addressId'] as int?;

        if (isEditing && addressId != null) {
          final address = await Adresscontroller().getAddressById(addressId);
          setState(() {
            _addressId = addressId;
            cepController.text = address?.zipCode ?? '';
            estadoController.text = address?.state ?? '';
            cidadeController.text = address?.city ?? '';
            bairroController.text = address?.bairro ?? '';
            ruaController.text = address?.street ?? '';
            numeroController.text = address?.number == 'S/N' ? '' : address?.number ?? '';
            complementoController.text = address?.complement ?? '';
            telefoneController.text = address?.telefone ?? '';
            _isLoading = false;
          });
        }
      } else {
        _isLoading = false;
      }
    }
  }

  Future<void> _buscarEnderecoPeloCEP() async {
    final cep = cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length == 8) {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          estadoController.text = data['uf'] ?? '';
          cidadeController.text = data['localidade'] ?? '';
          bairroController.text = data['bairro'] ?? '';
          ruaController.text = data['logradouro'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar o CEP. Verifique o valor digitado.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP inválido. Digite um CEP com 8 dígitos.')),
      );
    }
  }

  void _salvarEndereco() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await AuthController().getUserFromSession();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não está logado.')),
        );
        return;
      }

      final address = Address(
        id: _addressId ?? 0,
        userId: user.id,
        street: ruaController.text.trim(),
        number: semNumero ? 'S/N' : numeroController.text.trim(),
        complement: complementoController.text.trim(),
        city: cidadeController.text.trim(),
        state: estadoController.text.trim(),
        zipCode: cepController.text.trim(),
        bairro: bairroController.text.trim(),
        telefone: telefoneController.text.trim(),
      );

      try {
        if (widget.isEditing) {
          await Adresscontroller().updateAddress(address);
        } else {
          await Adresscontroller().insertAddress(address);
        }
        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar endereço: $error')),
        );
      }
    }
  }  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    String? hint,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text(
          widget.isEditing ? 'Editar Endereço' : 'Adicionar Endereço',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("CEP", cepController, icon: Icons.map, inputType: TextInputType.number, validator: _validateCampoObrigatorio),
              ElevatedButton(
                onPressed: _buscarEnderecoPeloCEP,
                child: const Text('Buscar pelo CEP'),
              ),
              _buildTextField("Estado", estadoController, icon: Icons.location_city),
              _buildTextField("Cidade", cidadeController, icon: Icons.apartment),
              _buildTextField("Bairro", bairroController, icon: Icons.house),
              _buildTextField("Rua", ruaController, icon: Icons.streetview, validator: _validateCampoObrigatorio),
              _buildTextField("Número", numeroController, icon: Icons.confirmation_number, inputType: TextInputType.number, validator: _validateCampoObrigatorio),
              _buildTextField("Complemento", complementoController, icon: Icons.add_location_alt),
              _buildTextField("Telefone", telefoneController, icon: Icons.phone, inputType: TextInputType.phone),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarEndereco,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(widget.isEditing ? 'Atualizar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateCampoObrigatorio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }
}
