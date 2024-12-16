import 'package:empoderaecommerce/controller/adressController.dart';
import 'package:empoderaecommerce/models/adressModel.dart';
import 'package:flutter/material.dart';

class EnderecosScreen extends StatefulWidget {
  final int userId;

  EnderecosScreen({required this.userId});

  @override
  _EnderecosScreenState createState() => _EnderecosScreenState();
}

class _EnderecosScreenState extends State<EnderecosScreen> {
  late Future<List<Address>> futureEnderecos;

  @override
  void initState() {
    super.initState();
    futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Meus dados',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Address>>(
        future: futureEnderecos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  'Endereços',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text('Nenhum endereço cadastrado.'),
                SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    // Navega para adicionar endereço
                    await Navigator.pushNamed(context, '/edit_enderecos',
                        arguments: {'isEditing': false, 'userId': widget.userId});
                    // Ao voltar, recarrega a lista
                    setState(() {
                      futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('Adicionar endereço'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            );
          }

          final enderecos = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text(
                'Endereços',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              for (var endereco in enderecos)
                _buildEnderecoCard(
                  context,
                  endereco: '${endereco.street}, ${endereco.number}, ${endereco.city} - ${endereco.state}',
                  detalhes: 'CEP ${endereco.zipCode}${endereco.complement.isNotEmpty ? ' - ${endereco.complement}' : ''}',
                  addressId: endereco.id!,
                ),
              SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  // Navega para adicionar endereço
                  await Navigator.pushNamed(context, '/edit_enderecos',
                      arguments: {'isEditing': false, 'userId': widget.userId});
                  // Ao voltar, recarrega a lista
                  setState(() {
                    futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                  });
                },
                icon: Icon(Icons.add),
                label: Text('Adicionar endereço'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEnderecoCard(BuildContext context,
      {required String endereco, required String detalhes, required int addressId}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.home, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    endereco,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'Editar') {
                      // Navegar para a tela de edição com dados do endereço
                      await Navigator.pushNamed(
                        context,
                        '/edit_enderecos',
                        arguments: {
                          'isEditing': true,
                          'addressId': addressId,
                          'userId': widget.userId
                        },
                      );
                      // Ao voltar, recarrega a lista
                      setState(() {
                        futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                      });
                    } else if (value == 'Remover') {
                      _removerEndereco(context, addressId);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Editar', 'Remover'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              detalhes,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Implementar lógica para adicionar dados e horários se necessário
              },
              child: Text(
                'Adicionar dados e horários do lugar',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removerEndereco(BuildContext context, int addressId) {
    // Exemplo de diálogo de confirmação
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover endereço'),
          content: Text('Você tem certeza que deseja remover este endereço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Lógica para remover endereço do banco
                await Adresscontroller().deleteAddress(addressId);
                Navigator.of(context).pop();
                setState(() {
                  futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                });
              },
              child: Text(
                'Remover',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
