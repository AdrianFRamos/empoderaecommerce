import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _user.avatarUrl?.isNotEmpty == true
                  ? NetworkImage(_user.avatarUrl!)
                  : null,
              child: _user.avatarUrl?.isNotEmpty != true
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              _user.name,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              _user.email,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Editar perfil
                _editProfile();
              },
              child: const Text('Editar Perfil'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Sair da conta
                _logout();
              },
              child: const Text('Sair da Conta'),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    // Navegar para a tela de edição de perfil
    Navigator.pushNamed(context, '/edit_profile', arguments: _user);
  }

  void _logout() {
    // Sair da conta
    // Remover o token de autenticação
    // Navegar para a tela de login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
