import 'dart:io';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                child: _avatarImage == null && (_user.avatarUrl?.isEmpty ?? true)
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
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
      ),
    );
  }
}
