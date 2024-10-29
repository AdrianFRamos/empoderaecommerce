import 'package:empoderaecommerce/controller/userController.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _password;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserFromSession(); // Carrega o usuário da sessão ativa
  }

  Future<void> _loadUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');

    if (userId != null && userName != null && userEmail != null) {
      setState(() {
        _user = User(id: userId, name: userName, email: userEmail, password: '');
        _name = userName;
        _email = userEmail;
        _password = ''; // Inicializa a senha com uma string vazia
      });
    } else {
      Get.snackbar(
        'Erro',
        'Nenhum usuário logado encontrado.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/login'); // Redireciona para a tela de login
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final success = await UserController.updateUser(
          User(
            id: _user!.id,
            name: _name,
            email: _email,
            password: _password,
          ),
        );

        if (success) {
          Get.snackbar(
            'Sucesso',
            'Perfil atualizado com sucesso!',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.back(); // Volta para a tela anterior
        } else {
          Get.snackbar(
            'Erro',
            'Não foi possível atualizar o perfil.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Erro',
          'Ocorreu um erro: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      initialValue: _name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      initialValue: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        } else if (!GetUtils.isEmail(value)) {
                          return 'Formato de e-mail inválido';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha';
                        } else if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUser,
                      child: const Text('Atualizar Perfil'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
