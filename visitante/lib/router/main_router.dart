import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visitante/screen_log/login_screen.dart';
import 'package:visitante/screen_log/register_screen.dart';
import 'package:visitante/pages/home_page.dart';

final mainRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              // Usuario autenticado
              return const HomePage();
            } else {
              // Usuario no autenticado
              return const LoginScreen();
            }
          },
        );
      },
    ),
  ],
);

