import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardExibicao extends StatelessWidget {
  final String cpf; // Recebe o CPF via argumento

  const DashboardExibicao({Key? key, required this.cpf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exibição de Dados")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pessoas')
              .where('cpf', isEqualTo: cpf)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Nenhuma pessoa encontrada com esse CPF."));
            }

            var pessoa = snapshot.data!.docs.first;
            var nome = pessoa['nome'];
            var idade = pessoa['idade'];
            var rid = pessoa['rid'];
            var historico = pessoa['historico'];

            return ListView(
              children: <Widget>[
                ListTile(
                  title: const Text("Nome"),
                  subtitle: Text(nome),
                ),
                ListTile(
                  title: const Text("Idade"),
                  subtitle: Text(idade.toString()),
                ),
                ListTile(
                  title: const Text("RID"),
                  subtitle: Text(rid),
                ),
                const ListTile(
                  title: Text("Histórico"),
                ),
                // Exibe os históricos
                for (var item in historico)
                  ListTile(
                    title: Text(
                      'Data: ${item['data'].toDate()}',
                    ),
                    subtitle: Text(item['detalhes']),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
