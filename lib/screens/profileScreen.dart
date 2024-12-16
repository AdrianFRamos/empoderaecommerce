import 'dart:io';
import 'package:empoderaecommerce/controller/sessionController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empoderaecommerce/models/userModel.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  File? _avatarImage;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadAvatarFromPreferences(); // Carrega o avatar salvo
  }

  Future<void> _loadAvatarFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('userAvatarPath');
    if (avatarPath != null) {
      setState(() {
        _avatarImage = File(avatarPath);
      });
    }
  }

  Future<void> _saveAvatarToPreferences(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAvatarPath', path);
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
      await _saveAvatarToPreferences(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.yellow[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Cabeçalho do perfil
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickAvatar, // Escolher avatar ao tocar
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarImage != null
                        ? FileImage(_avatarImage!)
                        : _user.avatarUrl?.isNotEmpty == true
                            ? NetworkImage(_user.avatarUrl!) as ImageProvider
                            : null,
                    child: _avatarImage == null &&
                            (_user.avatarUrl?.isEmpty ?? true)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _user.name,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  _user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          // Itens do menu
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Dados pessoais'),
            onTap: () {
              // Navegar para a tela de dados pessoais
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Endereços'),
            onTap: () async {
              // Obter o usuário da sessão
              User? loggedUser = await SaveUserSession.getUserFromSession();

              if (loggedUser != null) {
                final userId = loggedUser.id;
                Navigator.pushNamed(context, '/enderecos', arguments: userId);
              } else {
                // Se não há usuário logado, vá para login
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacidade'),
            onTap: () {
              // Navegar para a tela de privacidade
              Navigator.pushNamed(context, '/privacidade');
            },
          ),
          const Divider(),
          // Botões de ações
          ElevatedButton(
            onPressed: () {
              // Navegar para a edição de perfil
              Navigator.pushNamed(context, '/edit_profile', arguments: _user);
            },
            child: const Text('Editar Perfil'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Função de logout
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: const Text('Sair da Conta'),
          ),
        ],
      ),
    );
  }
}
