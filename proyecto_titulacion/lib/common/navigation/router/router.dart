import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

// Tus páginas reales
import 'package:proyecto_titulacion/features/auth/ui/login_page.dart';
import 'package:proyecto_titulacion/features/auth/ui/register_page.dart';
import 'package:proyecto_titulacion/common/ui/main_layout.dart';

final router = GoRouter(
  initialLocation: '/login',

  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (_, __) => const MyMainLayout(),
    ),
    
  ],

  redirect: (context, state) async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      final loggedIn = session.isSignedIn;

      final goingToAuthPage = state.matchedLocation == '/login' ||
                              state.matchedLocation == '/register';

      // NO autenticado → solo permitir login/register
      if (!loggedIn && !goingToAuthPage) {
        return '/login';
      }

      // Autenticado → evitar ir al login/register
      if (loggedIn && goingToAuthPage) {
        return '/home';
      }

      return null; // No redirigir
    } catch (_) {
      // Si hay error → llevar al login
      return '/login';
    }
  },
);

