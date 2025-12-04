// lib/features/auth/ui/login_page.dart
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/features/auth/controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  bool loading = false;

  Future<void> _login() async {
    setState(() { loading = true; errorMessage = ''; });
    try {
      final success = await AuthController.signIn(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (success) {
        context.go('/home');
      } else {
        setState(() { errorMessage = 'No se pudo iniciar sesión'; });
      }
    } on AuthException catch (e) {
      setState(() { errorMessage = e.message; });
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    const placeholderPath = '/mnt/data/17dac6ae-b115-4b11-aec7-8e998abebf4b.png';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                child: Image.file(
                  File(placeholderPath),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 18),
              const Text('Bienvenido', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Institucional @upiicsa.mx',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  child: loading ? const CircularProgressIndicator.adaptive() : const Text('Iniciar Sesión'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Crear nueva cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
