import 'package:empoderaecommerce/const/hashedPassword.dart';
import 'package:empoderaecommerce/controller/loginController.dart';
import 'package:empoderaecommerce/controller/sessionController.dart';
import 'package:empoderaecommerce/controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserController controller = Get.put(UserController());

  bool _acceptContact = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Complete os dados para criar sua conta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implementar lógica de registro com o Google
                  },
                  icon: Image.asset(
                    'assets/icons/google.png',
                    height: 24,
                  ),
                  label: const Text('Cadastrar-se com o Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("ou preencha seus dados"),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'exemplo@email.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    } else if (!GetUtils.isEmail(value)) {
                      return 'Formato de e-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Sobrenome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    } else if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.numberController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: '55',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptContact,
                      onChanged: (value) {
                        setState(() {
                          _acceptContact = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Aceito que entrem em contato comigo por SMS e WhatsApp.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ao clicar em "Continuar", aceito os Termos e condições e autorizo o uso dos meus dados de acordo com a Declaração de privacidade.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ao continuar, vamos te enviar um código para validar seu celular.',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final name = controller.nameController.text.trim();
      final email = controller.emailController.text.trim().toLowerCase();
      final lastname = controller.lastnameController.text.trim();
      final password = controller.passwordController.text.trim();
      final number = controller.numberController.text.trim();

      try {
        final email = controller.emailController.text.trim().toLowerCase();
        final hashedPassword = hashPassword(password.trim());
        final userId = await controller.insertUser(name, email, lastname, hashedPassword, number);

        if (userId != 0) {
          final loginController = Get.put(LoginController());
          final user = await loginController.getUserByEmailAndPassword(email, hashedPassword);

          //print('User retornado: $user');
          //print('Mounted: $mounted');
          //print('Email usado: $email');
          //print('Password usado: $password');

          if (user != null && mounted) {
            await SaveUserSession.saveUserSession(user);
            print('Usuário logado e sessão salva: ${user.toMap()}');
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            _showSnackbar('Falha no login após o registro.');
          }
        } else {
          _showSnackbar('Falha no registro');
        }
      } catch (error) {
        _showSnackbar('Erro: $error');
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    controller.nameController.dispose();
    controller.emailController.dispose();
    controller.passwordController.dispose();
    controller.lastnameController.dispose();
    controller.numberController.dispose();
    super.dispose();
  }
}
