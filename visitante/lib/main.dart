import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:visitante/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visitante/pages/home_page.dart';
 import 'package:visitante/screen_log/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(), // Asegúrate de usar AuthGate
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Verifica si el usuario está autenticado
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si no hay usuario autenticado, muestra la pantalla de login
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Algo salió mal.'));
        } else if (snapshot.hasData) {
          // Si el usuario está autenticado, dirige a la página de inicio
          return const HomePage();
        } else {
          // Si no está autenticado, muestra la pantalla de inicio de sesión
          return const LoginScreen();
        }
      },
    );
  }
}

