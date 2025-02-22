import 'package:flutter/material.dart';
import 'dashboard_exibicao.dart'; // A tela que vai exibir os dados

class DashboardEntradaCPF extends StatefulWidget {
  @override
  _DashboardEntradaCPFState createState() => _DashboardEntradaCPFState();
}

class _DashboardEntradaCPFState extends State<DashboardEntradaCPF> {
  final _cpfController = TextEditingController();

  void _buscarPessoa() {
    final cpf = _cpfController.text;
    if (cpf.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardExibicao(rid: cpf), // Envia o CPF como 'rid'
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o CPF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Pessoa pelo CPF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'Digite o RID',
                hintText: 'RID',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buscarPessoa,
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
