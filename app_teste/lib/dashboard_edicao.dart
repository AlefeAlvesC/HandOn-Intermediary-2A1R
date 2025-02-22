import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardEdicao extends StatefulWidget {
  final String rid; // Este parâmetro será passado pela tela de lista

  const DashboardEdicao({Key? key, required this.rid}) : super(key: key);

  @override
  _DashboardEdicaoState createState() => _DashboardEdicaoState();
}

class _DashboardEdicaoState extends State<DashboardEdicao> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _idadeController = TextEditingController();

  bool _isLoading = false;

  // Função para buscar os dados do paciente no Firestore
  Future<void> _getPacienteData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('pessoas').doc(widget.rid).get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data()!;
        _nomeController.text = data['nome'];
        _cpfController.text = data['cpf'];
        _idadeController.text = data['idade'].toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  // Função para atualizar os dados no Firestore
  Future<void> _updatePacienteData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('pessoas').doc(widget.rid).update({
          'nome': _nomeController.text,
          'cpf': _cpfController.text,
          'idade': int.parse(_idadeController.text),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );

        // Voltar para a tela anterior após atualizar
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar dados: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getPacienteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cpfController,
                      decoration: const InputDecoration(labelText: 'CPF'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 11) {
                          return 'CPF inválido (11 dígitos)';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _idadeController,
                      decoration: const InputDecoration(labelText: 'Idade'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Idade é obrigatória';
                        }
                        try {
                          int idade = int.parse(value);
                          if (idade <= 0) {
                            return 'Idade deve ser maior que zero';
                          }
                        } catch (e) {
                          return 'Idade inválida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updatePacienteData,
                      child: const Text('Salvar Alterações'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
