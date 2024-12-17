import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'label': 'Eletrônicos', 'icon': Icons.devices},
    {'label': 'Moda', 'icon': Icons.checkroom},
    {'label': 'Casa e Móveis', 'icon': Icons.chair},
    {'label': 'Esporte', 'icon': Icons.sports_soccer},
    {'label': 'Veículos', 'icon': Icons.directions_car},
    {'label': 'Livros', 'icon': Icons.book},
    {'label': 'Alimentos', 'icon': Icons.fastfood},
    {'label': 'Brinquedos', 'icon': Icons.toys},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Selecione uma Categoria',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/add_product',
                  arguments: {'category': category['label']});
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category['icon'], size: 50, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    category['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
