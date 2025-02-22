import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatelessWidget {
  final TextEditingController _ridController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  Dashboard({Key? key}) : super(key: key); // Adicionando um construtor constante

  void addFila(BuildContext context) async {
    // Verificar se os campos não estão vazios
    if (_ridController.text.isNotEmpty && _statusController.text.isNotEmpty) {
      try {
        // Adicionar dados no Firestore
        await FirebaseFirestore.instance.collection('filas').add({
          'rid': _ridController.text,
          'status': _statusController.text,
          'data_hora': FieldValue.serverTimestamp(),
        });

        // Limpar os campos após adicionar
        _ridController.clear();
        _statusController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fila adicionada com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar à fila: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha ambos os campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard - Gerenciar Fila")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ridController,
              decoration: const InputDecoration(labelText: 'RID'),
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => addFila(context),
              child: const Text('Adicionar à Fila'),
            ),
            const SizedBox(height: 16),
            // Lista de itens da fila
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('filas')
                    .orderBy('data_hora')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var filas = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: filas.length,
                    itemBuilder: (context, index) {
                      var fila = filas[index];
                      // Formatar a data para exibição
                      var dataHora = (fila['data_hora'] as Timestamp?)?.toDate();
                      var formattedDate = dataHora != null
                          ? '${dataHora.day}/${dataHora.month}/${dataHora.year} ${dataHora.hour}:${dataHora.minute}'
                          : 'Data indisponível';

                      return ListTile(
                        title: Text(fila['rid']),
                        subtitle: Text('${fila['status']} - $formattedDate'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
