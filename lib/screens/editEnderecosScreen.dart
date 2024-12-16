import 'package:empoderaecommerce/controller/adressController.dart';
import 'package:empoderaecommerce/models/adressModel.dart';
import 'package:flutter/material.dart';

class EditEnderecosScreen extends StatefulWidget {
  final bool isEditing;
  final Address? endereco;
  final int? userId;

  EditEnderecosScreen({
    Key? key,
    required this.isEditing,
    this.endereco,
    this.userId,
  }) : super(key: key);

  @override
  _EditEnderecosScreenState createState() => _EditEnderecosScreenState();
}

class _EditEnderecosScreenState extends State<EditEnderecosScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController infoAdicionalController = TextEditingController();

  bool semNumero = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.endereco != null) {
      final e = widget.endereco!;
      cepController.text = e.zipCode;
      estadoController.text = e.state;
      cidadeController.text = e.city;
      ruaController.text = e.street;
      numeroController.text = e.number == 'S/N' ? '' : e.number;
      complementoController.text = e.complement;
      // Caso queira armazenar telefone, bairro e outras infos, 
      // inclua colunas no BD e ajuste aqui.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          widget.isEditing ? 'Edite seu endereço' : 'Adicione um endereço',
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
            _buildTextField("Nome completo", nomeController, hint: "Como no seu RG."),
            _buildTextField("CEP", cepController, hint: "Não sei o meu CEP"),
            _buildTextField("Estado", estadoController),
            _buildTextField("Cidade", cidadeController),
            _buildTextField("Bairro", bairroController),
            _buildTextField("Rua/Avenida", ruaController, hint: "Informe o nome da rua."),
            _buildNumberField(context),
            _buildTextField("Complemento (opcional)", complementoController),
            _buildTextField("Telefone de contato", telefoneController, hint: "Caso haja problema no envio."),
            _buildTextField("Informações adicionais (opcional)", infoAdicionalController, maxLines: 3),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarEndereco,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                widget.isEditing ? 'Atualizar' : 'Salvar',
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

  void _salvarEndereco() {
    final userId = widget.isEditing ? widget.endereco!.userId : widget.userId!;
    final address = Address(
      id: widget.isEditing ? widget.endereco!.id : null,
      userId: userId,
      street: ruaController.text,
      number: semNumero ? 'S/N' : numeroController.text,
      complement: complementoController.text,
      city: cidadeController.text,
      state: estadoController.text,
      zipCode: cepController.text,
    );

    if (widget.isEditing) {
      Adresscontroller().updateAddress(address).then((_) {
        Navigator.pop(context, true);
      });
    } else {
      Adresscontroller().insertAddress(address).then((_) {
        Navigator.pop(context, true);
      });
    }
  }

  Widget _buildNumberField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField("Número", numeroController),
        ),
        Checkbox(
          value: semNumero,
          onChanged: (value) {
            setState(() {
              semNumero = value ?? false;
              if (semNumero) {
                numeroController.text = '';
              }
            });
          },
        ),
        Text("Sem número"),
      ],
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
}
