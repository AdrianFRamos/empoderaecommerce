import 'package:flutter/material.dart';

class EditEnderecosScreen extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController infoAdicionalController =
      TextEditingController();

  final bool isEditing;
  final Map<String, dynamic>? endereco;

  EditEnderecosScreen({Key? key, required this.isEditing, this.endereco})
      : super(key: key) {
    if (isEditing && endereco != null) {
      // Preenche os controladores com os dados do endereço
      nomeController.text = endereco!['nome'] ?? '';
      cepController.text = endereco!['cep'] ?? '';
      estadoController.text = endereco!['estado'] ?? '';
      cidadeController.text = endereco!['cidade'] ?? '';
      bairroController.text = endereco!['bairro'] ?? '';
      ruaController.text = endereco!['rua'] ?? '';
      numeroController.text = endereco!['numero'] ?? '';
      complementoController.text = endereco!['complemento'] ?? '';
      telefoneController.text = endereco!['telefone'] ?? '';
      infoAdicionalController.text = endereco!['infoAdicional'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          isEditing ? 'Edite seu endereço' : 'Adicione um endereço',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nome completo", nomeController,
                hint: "Como aparecem no seu RG ou CNH."),
            _buildTextField("CEP", cepController, hint: "Não sei o meu CEP"),
            _buildTextField("Estado", estadoController),
            _buildTextField("Cidade", cidadeController),
            _buildTextField("Bairro", bairroController),
            _buildTextField("Rua/Avenida", ruaController,
                hint: "Informe somente o nome da rua ou avenida."),
            _buildNumberField(context),
            _buildTextField("Complemento (opcional)", complementoController),
            _buildTextField("Telefone de contato", telefoneController,
                hint:
                    "Se houver algum problema no envio, você receberá uma ligação neste número."),
            _buildTextField("Informações adicionais deste endereço (opcional)",
                infoAdicionalController,
                maxLines: 3,
                hint:
                    "Descrição da fachada, pontos de referência, informações de segurança etc."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  // Atualizar o endereço existente
                  print("Atualizar: ${nomeController.text}");
                  // Chame a função para atualizar os dados no backend
                } else {
                  // Adicionar novo endereço
                  print("Adicionar: ${nomeController.text}");
                  // Chame a função para adicionar os dados no backend
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                isEditing ? 'Atualizar' : 'Salvar',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Como cuidamos da sua privacidade",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNumberField(BuildContext context) {
    bool semNumero = false;
    return Row(
      children: [
        Expanded(
          child: _buildTextField("Número", numeroController),
        ),
        Checkbox(
          value: semNumero,
          onChanged: (value) {
            semNumero = value ?? false;
          },
        ),
        Text("Sem número"),
      ],
    );
  }
}
