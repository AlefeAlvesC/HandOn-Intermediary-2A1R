import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dashboard_cadastro.dart'; // Tela de Cadastro
import 'dashboard_exibicao.dart'; // Tela de Consulta
import 'dashboard_lista.dart'; // Tela de Lista de Pacientes
import 'rid_input_screen.dart'; // Tela que pede o RID

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro e Consulta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/cadastro': (context) => DashboardCadastro(),
        '/exibicao': (context) => DashboardExibicao(rid: ''), // Inicializa com rid vazio
        '/lista': (context) => DashboardAtendimento(),
        '/rid_input': (context) => RidInputScreen(), // Rota para a tela de input do RID
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: const Text('Cadastrar Pessoa'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navega para a tela onde o usuário digita o RID
                Navigator.pushNamed(context, '/rid_input');
              },
              child: const Text('Consultar Dados pelo RID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/lista');
              },
              child: const Text('Listar Pacientes'),
            ),
          ],
        ),
      ),
    );
  }
}
