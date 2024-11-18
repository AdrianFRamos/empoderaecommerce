import 'package:empoderaecommerce/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Meu perfil',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do perfil
            Container(
              color: Colors.yellow[700],
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _user.avatarUrl?.isNotEmpty == true
                        ? NetworkImage(_user.avatarUrl!)
                        : null,
                    child: _user.avatarUrl?.isNotEmpty != true
                        ? const Icon(Icons.person, size: 50, color: Colors.black)
                        : null,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Opções do perfil
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileOption(
                    context,
                    icon: Icons.perm_identity,
                    title: 'Dados pessoais',
                    subtitle:
                        'Informações do seu documento de identidade e sua atividade econômica.',
                    onTap: _editProfile,
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.account_circle,
                    title: 'Dados da sua conta',
                    subtitle:
                        'Dados que representam a conta no Mercado Livre e Mercado Pago.',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.lock,
                    title: 'Segurança',
                    subtitle: 'Você configurou a segurança da sua conta.',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.subscriptions,
                    title: 'Meli+',
                    subtitle:
                        'Assinatura com benefícios em frete, compras e entretenimento.',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.credit_card,
                    title: 'Cartões',
                    subtitle: 'Cartões salvos na sua conta.',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.location_on,
                    title: 'Endereços',
                    subtitle: 'Endereços salvos na sua conta.',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.privacy_tip,
                    title: 'Privacidade',
                    subtitle:
                        'Preferências e controle do uso dos seus dados.',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    context,
                    icon: Icons.chat,
                    title: 'Comunicações',
                    subtitle:
                        'Escolha que tipo de informação você quer receber.',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Sair da Conta'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  void _editProfile() {
    Navigator.pushNamed(context, '/edit_profile', arguments: _user);
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
