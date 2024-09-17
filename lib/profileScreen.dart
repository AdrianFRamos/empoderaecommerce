import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_user.avatarUrl),
            ),
            SizedBox(height: 20),
            Text(
              _user.name,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              _user.email,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Editar perfil
                _editProfile();
              },
              child: Text('Editar Perfil'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Sair da conta
                _logout();
              },
              child: Text('Sair da Conta'),
            ),
          ],
        ),
      ),
    );
  }

  _editProfile() {
    // Navegar para a tela de edição de perfil
    Navigator.pushNamed(context, '/edit_profile', arguments: _user);
  }

  _logout() {
    // Sair da conta
    // Remover o token de autenticação
    // Navegar para a tela de login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}