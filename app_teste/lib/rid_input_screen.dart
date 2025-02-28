import 'package:flutter/material.dart';
import 'dashboard_exibicao.dart'; // Tela de Consulta

class RidInputScreen extends StatelessWidget {
  final TextEditingController _ridController = TextEditingController();

  RidInputScreen({super.key});

  // Função para navegar para a tela de exibição passando o rid como parâmetro
  void _navigateWithRid(BuildContext context) {
    final rid = _ridController.text;

    if (rid.isNotEmpty) {
      // Navega para a tela de exibição e passa o rid como argumento
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => DashboardExibicao(
                rid: rid,
              ), // Passa o rid para a tela de exibição
        ),
      );
    } else {
      // Caso o RID esteja vazio, exibe um erro
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Por favor, insira um RID')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cores de exemplo; ajuste conforme o seu design
    final Color corFundo = const Color(0xFF69C569); // Verde claro
    final Color corContainer = const Color(0xFF347A34); // Verde escuro

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: const Text('Tela De busca de cadastro'),
        backgroundColor: corContainer,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: corContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Container do LOGO
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

                  // Campo para digitar o RID
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'RID é obrigatório';
                      }
                      return null;
                    },
                    controller: _ridController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'digite o RID',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão para buscar dados
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () => _navigateWithRid(context),
                      child: const Text(
                        'Buscar dados',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
