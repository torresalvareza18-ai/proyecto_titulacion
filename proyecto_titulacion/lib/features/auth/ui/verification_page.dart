import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/features/auth/controller/auth_controller.dart';

class VerificationPage extends StatefulWidget {
  // Recibimos estos datos para poder hacer el Login automático después
  final String email;
  final String password;
  final String name;

  const VerificationPage({
    super.key,
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final codeController = TextEditingController();
  final Color _upiicsaGreen = const Color(0xFF0B6730);
  
  bool loading = false;
  String errorMessage = '';

  Future<void> _verifyAndComplete() async {
    if (codeController.text.isEmpty) return;

    setState(() { loading = true; errorMessage = ''; });

    try {
      // PASO 1: Confirmar el código con Cognito
      final isConfirmed = await AuthController.confirmSignUp(
        username: widget.email,
        code: codeController.text.trim(),
      );

      if (isConfirmed) {
        // PASO 2: Iniciar Sesión Automáticamente (Ahora sí se puede)
        final signInSuccess = await AuthController.signIn(
          username: widget.email,
          password: widget.password,
        );

        if (signInSuccess) {
          // PASO 3: Guardar en DynamoDB (Ahora que tenemos Token)
          await AuthController.createUserInDynamoDB(
            email: widget.email,
            name: widget.name,
            userType: 'Estudiante',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Verificación exitosa! Bienvenido.'))
            );
            context.go('/home'); // ¡FIN DEL PROCESO!
          }
        }
      } else {
        setState(() { errorMessage = 'No se pudo confirmar el código.'; });
      }
    } on AuthException catch (e) {
      setState(() { errorMessage = e.message; });
    } catch (e) {
      setState(() { errorMessage = 'Error: $e'; });
    } finally {
      if (mounted) setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _upiicsaGreen),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mark_email_read, size: 80, color: _upiicsaGreen),
              const SizedBox(height: 20),
              
              Text(
                'Verificar Correo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _upiicsaGreen),
              ),
              const SizedBox(height: 10),
              Text(
                'Hemos enviado un código a:\n${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              
              const SizedBox(height: 40),

              // INPUT DEL CÓDIGO
              _buildTextField(
                controller: codeController,
                hintText: 'Código de 6 dígitos',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : _verifyAndComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _upiicsaGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: loading 
                    ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white) 
                    : const Text('Confirmar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reutilizamos el estilo de tu input
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
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
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, letterSpacing: 2),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, letterSpacing: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}