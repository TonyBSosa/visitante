import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return const LoginScreen();
        }
        return const HomePage();
      },
    ),
    
  ],
);

