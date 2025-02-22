import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardCadastro extends StatefulWidget {
  const DashboardCadastro({Key? key}) : super(key: key);

  @override
  _DashboardCadastroState createState() => _DashboardCadastroState();
}

class _DashboardCadastroState extends State<DashboardCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _ridController = TextEditingController();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _historicoController = TextEditingController();
  bool _isLoading = false;

  Future<void> cadastrarPessoa() async {
    setState(() {
      _isLoading = true;
    });

    // Validação do formulário
    if (_formKey.currentState!.validate()) {
      try {
        // Verificar se o RID já existe no Firestore
        final existingPerson = await FirebaseFirestore.instance
            .collection('pessoas')
            .where('rid', isEqualTo: _ridController.text)
            .limit(1)
            .get();

        if (existingPerson.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('RID já existe!')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Validar a idade
        int idade;
        try {
          idade = int.parse(_idadeController.text);
          if (idade <= 0) {
            throw Exception("Idade deve ser maior que zero.");
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Idade inválida: $e')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Validar CPF
        if (_cpfController.text.length != 11) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CPF inválido: Deve conter 11 dígitos.')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Validar nome e RID
        if (_nomeController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nome inválido: Não pode ser vazio.')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (_ridController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('RID inválido: Não pode ser vazio.')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Criar a estrutura no Firestore e adicionar dados
        final pessoaRef = FirebaseFirestore.instance.collection('pessoas').doc(_ridController.text);

        // Criação do documento da pessoa
        await pessoaRef.set({
          'rid': _ridController.text,
          'cpf': _cpfController.text,
          'nome': _nomeController.text,
          'idade': idade,
        });

        // Adicionar um histórico como subcoleção (caso queira ter um histórico para cada pessoa)
        await pessoaRef.collection('historico').add({
          'data': FieldValue.serverTimestamp(),
          'detalhes': _historicoController.text,
        });

        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        // Limpar o formulário e redirecionar
        _clearForm();

        // Navega para a tela de exibição, passando o rid
        Navigator.pushNamed(context, '/exibicao', arguments: _ridController.text);
      } on FirebaseException catch (e) {
        _showErrorSnackBar('Erro ao cadastrar: ${e.message}');
      } catch (e) {
        _showErrorSnackBar('Erro ao cadastrar: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearForm() {
    _ridController.clear();
    _cpfController.clear();
    _nomeController.clear();
    _idadeController.clear();
    _historicoController.clear();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Pessoa")),
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
                      controller: _ridController,
                      decoration: const InputDecoration(labelText: 'RID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'RID é obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cpfController,
                      decoration: const InputDecoration(labelText: 'CPF'),
                      keyboardType: TextInputType.number,
                      maxLength: 11, // Limit CPF to 11 digits
                      validator: (value) {
                        if (value == null || value.length != 11) {
                          return 'CPF inválido (11 dígitos)';
                        }
                        return null;
                      },
                    ),
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
                    TextFormField(
                      controller: _historicoController,
                      decoration: const InputDecoration(labelText: 'Histórico'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: cadastrarPessoa,
                      child: const Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
