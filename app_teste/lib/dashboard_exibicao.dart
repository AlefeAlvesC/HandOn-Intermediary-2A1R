import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardExibicao extends StatelessWidget {
  final String rid;

  // O construtor precisa aceitar o rid como argumento
  const DashboardExibicao({Key? key, required this.rid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dados da Pessoa")),
      body: FutureBuilder<Map<String, dynamic>?>( 
        future: _fetchPessoaData(rid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }

          if (snapshot.data == null) {
            return const Center(child: Text('Pessoa não encontrada'));
          }

          final pessoa = snapshot.data!; // Dados da pessoa

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${pessoa['nome']}', style: const TextStyle(fontSize: 20)),
                Text('CPF: ${pessoa['cpf']}'),
                Text('Idade: ${pessoa['idade']}'),
                const SizedBox(height: 16),
                // Aqui você pode acessar o histórico como antes
                Text('Histórico:', style: const TextStyle(fontSize: 18)),
                // Código para exibir histórico
              ],
            ),
          );
        },
      ),
    );
  }

  // Método para buscar os dados do paciente pelo rid
  Future<Map<String, dynamic>?> _fetchPessoaData(String rid) async {
    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('pessoas')
          .doc(rid)  // Busca pelo rid (ID do documento no Firestore)
          .get();

      return docSnap.exists ? docSnap.data() as Map<String, dynamic> : null;
    } catch (e) {
      return Future.error(e);
    }
  }
}
