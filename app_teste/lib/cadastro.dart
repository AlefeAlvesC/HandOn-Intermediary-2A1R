import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardCadastro extends StatefulWidget {
  const DashboardCadastro({super.key});

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
        final existingPerson =
            await FirebaseFirestore.instance
                .collection('pessoas')
                .where('rid', isEqualTo: _ridController.text)
                .limit(1)
                .get();

        if (existingPerson.docs.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('RID já existe!')));
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Idade inválida: $e')));
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
        final pessoaRef = FirebaseFirestore.instance
            .collection('pessoas')
            .doc(_ridController.text);

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
        Navigator.pushNamed(
          context,
          '/exibicao',
          arguments: _ridController.text,
        );
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      // Cor de fundo da tela
      backgroundColor: const Color(
        0xFF69C569,
      ), // Ajuste para a cor que preferir
      appBar: AppBar(
        backgroundColor: const Color(0xFF347A34), // Tom de verde mais escuro
        title: const Text('Cadastro de paciente'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(
                0xFF347A34,
              ), // Cor verde escura para o container
              borderRadius: BorderRadius.circular(16),
            ),
            width: double.infinity,
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // LOGO (por enquanto, apenas um container simulando a área da logo)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 100, // Largura da imagem
                                height: 100, // Altura da imagem
                                fit: BoxFit.contain, // Ajuste da imagem
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Campo para RID
                          TextFormField(
                            controller: _ridController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'RID é obrigatório';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'digite o RID',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo para CPF
                          TextFormField(
                            controller: _cpfController,
                            validator: (value) {
                              if (value == null || value.length != 11) {
                                return 'CPF inválido (11 dígitos)';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'digite o CPF',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo para Nome
                          TextFormField(
                            controller: _nomeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nome é obrigatório';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'digite o nome',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo para Idade
                          TextFormField(
                            controller: _idadeController,
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'digite a idade',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _historicoController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Historico',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botão de Cadastrar
                          ElevatedButton(
                            onPressed: cadastrarPessoa,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text(
                              'Cadastrar',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
