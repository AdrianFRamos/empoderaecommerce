import 'package:empoderaecommerce/helper/databaseHelper.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = ModalRoute.of(context)!.settings.arguments as User;
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
              backgroundImage: _user.avatarUrl.isNotEmpty
                  ? NetworkImage(_user.avatarUrl)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
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
