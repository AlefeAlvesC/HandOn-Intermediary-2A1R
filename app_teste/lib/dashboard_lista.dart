import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardAtendimento extends StatelessWidget {
  const DashboardAtendimento({Key? key}) : super(key: key);

  // Cores para o layout
  final Color corFundo = const Color(0xFF69C569); // Verde claro
  final Color corContainer = const Color(0xFF347A34); // Verde escuro

  // Função para buscar todos os atendimentos e cruzar com os dados das pessoas
  Future<List<Map<String, dynamic>>> _fetchAtendimentos() async {
    try {
      // Recuperar todos os atendimentos da coleção 'atendimentos'
      final atendimentosSnapshot =
          await FirebaseFirestore.instance
              .collection('atendimentos')
              .orderBy(
                'number',
              ) // Ordena inicialmente pelo tipo de atendimento (1,2,3)
              .get();

      List<Map<String, dynamic>> listaAtendimentos = [];

      // Para cada atendimento, buscar os dados da pessoa (cruzando pelo 'rfid')
      for (var atendimentoDoc in atendimentosSnapshot.docs) {
        String rfid = atendimentoDoc['rfid'];
        int numeroAtendimento = atendimentoDoc['number'];

        // Buscar dados da pessoa
        var pessoaDoc =
            await FirebaseFirestore.instance
                .collection('pessoas')
                .doc(rfid)
                .get();

        if (pessoaDoc.exists) {
          var pessoaData = pessoaDoc.data();
          if (pessoaData != null) {
            int idade = pessoaData['idade'];
            String nome = pessoaData['nome'];
            String cpf = pessoaData['cpf'];

            // Montar objeto unificado
            listaAtendimentos.add({
              'rfid': rfid,
              'numeroAtendimento': numeroAtendimento,
              'nome': nome,
              'cpf': cpf,
              'idade': idade,
            });
          }
        }
      }

      // Critério de prioridade:
      // 1) Idade decrescente
      // 2) Em caso de empate, tipo de atendimento decrescente (3 > 2 > 1)
      listaAtendimentos.sort((a, b) {
        int compareIdade = b['idade'].compareTo(a['idade']);
        if (compareIdade != 0) {
          return compareIdade;
        }
        return b['numeroAtendimento'].compareTo(a['numeroAtendimento']);
      });

      return listaAtendimentos;
    } catch (e) {
      return Future.error(e);
    }
  }

  // Método auxiliar para construir cada seção
  Widget _buildSection(String titulo, List<Map<String, dynamic>> dados) {
    if (dados.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título centralizado da seção
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Tabela com os dados
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all<Color>(
              Colors.green.shade800,
            ),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            dataRowColor: MaterialStateProperty.all<Color>(
              Colors.green.shade700,
            ),
            dataTextStyle: const TextStyle(color: Colors.white),
            columns: const [
              DataColumn(label: Text('Nome')),
              DataColumn(label: Text('RFID')),
              DataColumn(label: Text('Idade')),
            ],
            rows:
                dados.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['nome'])),
                      DataCell(Text(item['rfid'])),
                      DataCell(Text(item['idade'].toString())),
                    ],
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo verde claro
      backgroundColor: corFundo,
      // AppBar com fundo verde escuro
      appBar: AppBar(
        title: const Text("Atendimentos"),
        backgroundColor: corContainer,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              // Container verde escuro para o conteúdo
              decoration: BoxDecoration(
                color: corContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchAtendimentos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar atendimentos: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum atendimento encontrado.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final atendimentos = snapshot.data!;

                  // Filtrar os atendimentos em três grupos
                  final atendimentoGroup =
                      atendimentos
                          .where((item) => item['numeroAtendimento'] == 1)
                          .toList();
                  final exameGroup =
                      atendimentos
                          .where((item) => item['numeroAtendimento'] == 2)
                          .toList();
                  final farmaciaGroup =
                      atendimentos
                          .where((item) => item['numeroAtendimento'] == 3)
                          .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSection("Atendimento", atendimentoGroup),
                      _buildSection("Exame", exameGroup),
                      _buildSection("Farmácia", farmaciaGroup),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
