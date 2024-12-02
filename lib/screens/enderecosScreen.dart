import 'package:flutter/material.dart';

class EnderecosScreen extends StatelessWidget {
  final List<Map<String, String>> enderecos = [
    {
      'endereco': 'Rua Marechal Deodoro da Fonseca 1701 Bloco 3, AP 203',
      'detalhes':
          'CEP 84600906 - Paraná - União da Vitória\nAdrian Ferreira Ramos - 42998726282'
    },
    {
      'endereco':
          'Bairro Nossa Senhora Aparecida Rua Domícios Escaramello 73',
      'detalhes':
          'CEP 84640000 - Paraná - Bituruna\nAdrian Ramos - 42998005956'
    },
  ];

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
      body: ListView(
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
          // Renderizar os endereços dinamicamente
          for (var endereco in enderecos)
            _buildEnderecoCard(
              context,
              endereco: endereco['endereco']!,
              detalhes: endereco['detalhes']!,
            ),
          SizedBox(height: 16),
          // Botão para adicionar novo endereço
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/edit_enderecos',
                  arguments: {'isEditing': false});
            },
            icon: Icon(Icons.add),
            label: Text('Adicionar endereço'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue),
              padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnderecoCard(BuildContext context,
      {required String endereco, required String detalhes}) {
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
                  onSelected: (value) {
                    if (value == 'Editar') {
                      // Navegar para a tela de edição com dados do endereço
                      Navigator.pushNamed(
                        context,
                        '/edit_enderecos',
                        arguments: {
                          'isEditing': true,
                          'endereco': endereco,
                          'detalhes': detalhes,
                        },
                      );
                    } else if (value == 'Remover') {
                      // Implementar lógica para remover endereço
                      _removerEndereco(context, endereco);
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
                // Implementar lógica para adicionar dados e horários
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

  void _removerEndereco(BuildContext context, String endereco) {
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
              onPressed: () {
                // Lógica para remover endereço
                Navigator.of(context).pop();
                print('Endereço removido: $endereco');
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
