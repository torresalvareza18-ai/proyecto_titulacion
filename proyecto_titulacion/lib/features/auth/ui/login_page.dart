import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/features/auth/controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Colores extraídos aproximados de la imagen
  final Color _upiicsaGreen = const Color(0xFF0B6730); // Verde oscuro institucional
  final Color _textColor = const Color(0xFF0B6730); 
  
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
        if(mounted) context.go('/home');
      } else {
        setState(() { errorMessage = 'No se pudo iniciar sesión'; });
      }
    } on AuthException catch (e) {
      setState(() { errorMessage = e.message; });
    } finally {
      if(mounted) setState(() { loading = false; });
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
                  height: 100,
                  child: Image.asset(
                    'assets/images/logo_quetzal.png', // <--- ASEGÚRATE DE TENER ESTA IMAGEN
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Placeholder por si no tienes la imagen aún
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 50, color: _upiicsaGreen),
                          Text("TABLON QUETZAL", style: TextStyle(color: _upiicsaGreen, fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 40),

                // 2. TEXTO BIENVENIDO
                Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _textColor, // Color verde
                  ),
                ),
                
                const SizedBox(height: 40),

                // 3. CAMPO CORREO (Etiqueta afuera + Input)
                _buildInputLabel('Correo/Usuario'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Ej. jnajosea1900@alumno.ipn.mx',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // 4. CAMPO CONTRASEÑA
                _buildInputLabel('Contraseña'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // MENSAJE DE ERROR
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 30),

                // 5. BOTÓN INICIAR SESIÓN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _upiicsaGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Bordes redondeados (píldora)
                      ),
                    ),
                    child: loading 
                      ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white) 
                      : const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
                
                const SizedBox(height: 5),
                // Línea separadora sutil (opcional, como en el diseño a veces aparece)
                Divider(color: Colors.grey.shade300, thickness: 1, indent: 20, endIndent: 20),
                const SizedBox(height: 10),

                // 6. LINKS INFERIORES
                TextButton(
                  onPressed: () {
                    // Lógica recuperar contraseña
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.grey[800],
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text(
                    'Crear nueva cuenta',
                    style: TextStyle(
                      color: Colors.grey[800],
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para la etiqueta verde de arriba
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

  // Widget auxiliar para el campo de texto estilizado
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
        border: Border.all(color: Colors.grey.shade300), // Borde gris sutil
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