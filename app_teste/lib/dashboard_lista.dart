import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardAtendimento extends StatelessWidget {
  // Função para buscar todos os atendimentos e cruzar com os dados das pessoas
  Future<List<Map<String, dynamic>>> _fetchAtendimentos() async {
    try {
      // Recuperar todos os atendimentos
      final atendimentosSnapshot = await FirebaseFirestore.instance
          .collection('atendimentos')
          .orderBy('numero_atendimento')  // Ordenar pelo tipo de atendimento
          .get();

      List<Map<String, dynamic>> atendimentos = [];

      // Para cada atendimento, buscar os dados da pessoa (cruzando pelo 'rid')
      for (var atendimentoDoc in atendimentosSnapshot.docs) {
        String rid = atendimentoDoc['rid'];
        int numeroAtendimento = atendimentoDoc['numero_atendimento'];

        // Buscar os dados da pessoa pelo 'rid'
        var pessoaDoc = await FirebaseFirestore.instance
            .collection('pessoas')
            .doc(rid)
            .get();

        if (pessoaDoc.exists) {
          var pessoaData = pessoaDoc.data();
          if (pessoaData != null) {
            int idade = pessoaData['idade'];
            String nome = pessoaData['nome'];
            String cpf = pessoaData['cpf'];

            // Adicionar os dados do atendimento com os dados da pessoa
            atendimentos.add({
              'rid': rid,
              'numero_atendimento': numeroAtendimento,
              'nome': nome,
              'cpf': cpf,
              'idade': idade,
            });
          }
        }
      }

      // Ordenar atendimentos pela idade (prioridade: idade maior)
      atendimentos.sort((a, b) => b['idade'].compareTo(a['idade']));  // Descendente (mais velho tem mais prioridade)

      return atendimentos;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atendimentos")),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Usando FutureBuilder para carregar os dados
        future: _fetchAtendimentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar atendimentos: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum atendimento encontrado.'));
          }

          final atendimentos = snapshot.data!;

          return SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nome')),
                DataColumn(label: Text('CPF')),
                DataColumn(label: Text('Idade')),
                DataColumn(label: Text('Tipo de Atendimento')),
              ],
              rows: atendimentos.map((atendimento) {
                String tipoAtendimento = '';
                switch (atendimento['numero_atendimento']) {
                  case 1:
                    tipoAtendimento = 'Atendimento';
                    break;
                  case 2:
                    tipoAtendimento = 'Exames';
                    break;
                  case 3:
                    tipoAtendimento = 'Farmácia';
                    break;
                }

                return DataRow(
                  cells: [
                    DataCell(Text(atendimento['nome'])),
                    DataCell(Text(atendimento['cpf'])),
                    DataCell(Text(atendimento['idade'].toString())),
                    DataCell(Text(tipoAtendimento)),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
