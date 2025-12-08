import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/features/auth/controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // --- CONTROLADORES ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Color _upiicsaGreen = const Color(0xFF0B6730);
  final Color _textColor = const Color(0xFF0B6730);

  String errorMessage = '';
  bool loading = false;

  Future<void> _register() async {
    if (nameController.text.isEmpty || 
        emailController.text.isEmpty || 
        passwordController.text.isEmpty) {
      setState(() { 
        loading = false;
        errorMessage = 'Por favor completa todos los campos'; 
      });
      return;
    }

    setState(() { loading = true; errorMessage = ''; });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();
      final signUpSuccess = await AuthController.signUpCognito(
        username: email,
        password: password,
      );

      if (signUpSuccess) {
        if (mounted) {
          context.push(
            '/verify', 
            extra: {
              'email': email,
              'password': password,
              'name': name,
            }
          );
        }
      } else {
         setState(() { errorMessage = 'Revisa tu correo para el código.'; });
      }

    } on AuthException catch (e) {
      setState(() { errorMessage = e.message; });
    } finally {
      if (mounted) setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. LOGO
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    'assets/images/logo_quetzal.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person_add, size: 60, color: _upiicsaGreen);
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputLabel('Nombre Completo'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: nameController,
                  hintText: 'Ej. Juan Pérez',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                _buildInputLabel('Correo Institucional'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Ej. alumno@upiicsa.mx',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildInputLabel('Contraseña'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Contraseña segura',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _upiicsaGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: loading 
                      ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white) 
                      : const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: _upiicsaGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES (Diseño Visual) ---

  Widget _buildInputLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: _upiicsaGreen,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}