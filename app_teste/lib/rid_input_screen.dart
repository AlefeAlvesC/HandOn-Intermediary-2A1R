import 'package:flutter/material.dart';
import 'dashboard_exibicao.dart'; // Tela de Consulta

class RidInputScreen extends StatelessWidget {
  final TextEditingController _ridController = TextEditingController();

  // Função para navegar para a tela de exibição passando o rid como parâmetro
  void _navigateWithRid(BuildContext context) {
    final rid = _ridController.text;

    if (rid.isNotEmpty) {
      // Navega para a tela de exibição e passa o rid como argumento
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardExibicao(rid: rid), // Passa o rid para a tela de exibição
        ),
      );
    } else {
      // Caso o RID esteja vazio, exibe um erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um RID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informe o RID')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _ridController,
              decoration: const InputDecoration(
                labelText: 'RID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'RID é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateWithRid(context), // Chama a função para navegação com RID
              child: const Text('Buscar Dados'),
            ),
          ],
        ),
      ),
    );
  }
}
