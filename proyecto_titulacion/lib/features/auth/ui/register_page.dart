// lib/features/auth/ui/register_page.dart
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/features/auth/controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  String errorMessage = '';
  bool loading = false;
  String userType = 'Estudiante';

  Future<void> _register() async {
    if (passwordController.text != confirmController.text) {
      setState(() { errorMessage = 'Las contraseñas no coinciden'; });
      return;
    }
    setState(() { loading = true; errorMessage = ''; });
    try {
      final ok = await AuthController.signUp(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
        attributes: {'custom:userType': userType, 'custom:id': idController.text.trim()},
      );
      if (ok) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() { errorMessage = 'No se pudo registrar'; });
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Crear Cuenta', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(height: 80, child: Image.file(File(placeholderPath), fit: BoxFit.contain)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Radio<String>(
                        value: 'Estudiante',
                        groupValue: userType,
                        onChanged: (v) => setState(() { userType = v ?? 'Estudiante'; }),
                      ),
                      title: const Text('Estudiante'),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Radio<String>(
                        value: 'Supercompañero',
                        groupValue: userType,
                        onChanged: (v) => setState(() { userType = v ?? 'Supercompañero'; }),
                      ),
                      title: const Text('Supercompañero'),
                    ),
                  ),
                ],
              ),
              TextField(controller: idController, decoration: const InputDecoration(labelText: 'Número de Cuenta/Empleado', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Correo Institucional @upiicsa.mx', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: confirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar Contraseña', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              if (errorMessage.isNotEmpty) Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : _register,
                  child: loading ? const CircularProgressIndicator.adaptive() : const Text('Registrarse'),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/login'), 
                child: const Text('Iniciar sesion'))
            ],
          ),
        ),
      ),
    );
  }
}
