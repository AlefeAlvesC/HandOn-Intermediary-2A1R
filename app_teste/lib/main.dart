import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cadastro.dart';
import 'dashboard_lista.dart';
import 'rid_input_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro e Consulta',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/cadastro': (context) => DashboardCadastro(),
        '/rid_input': (context) => RidInputScreen(),
        '/lista':
            (context) =>
                DashboardAtendimento(), // Rota para a tela de input do RID
      },
    );
  }
}

class GensusApp extends StatelessWidget {
  const GensusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro e Consulta',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/cadastro': (context) => DashboardCadastro(),
        '/lista': (context) => DashboardAtendimento(),
        // Tela de input do RID
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            color: const Color(0xFF1B5E20),
            width: double.infinity,
            margin: EdgeInsets.only(top: 24),
            child: Center(
              child: Text(
                'GENSUS-ADM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            width: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(16),
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
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CustomButton(
                  text: 'Cadastrar paciente',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/cadastro',
                    ); // Correção da navegação
                  },
                ),
                CustomButton(
                  text: 'Consultar Dados',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/rid_input',
                    ); // Correção da navegação
                  },
                ),
                CustomButton(
                  text: 'Fila de Paciente',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/lista',
                    ); // Correção da navegação
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Logo maloca',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
