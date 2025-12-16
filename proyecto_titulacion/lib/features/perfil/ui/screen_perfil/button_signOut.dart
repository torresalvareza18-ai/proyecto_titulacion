import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/features/auth/controller/auth_controller.dart';

class button_signout extends StatefulWidget {
  const button_signout({super.key});

  @override
  State<button_signout> createState() => _button_signoutState();
}

class _button_signoutState extends State<button_signout> {

  void _ejecutarCierreSesion(BuildContext context) async {
    try {
      await AuthController.signOut(); 
      
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      print("Error al cerrar sesión: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cerrando sesión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), 
      child: InkWell(
        onTap: () => _ejecutarCierreSesion(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red.shade50, 
            borderRadius: BorderRadius.circular(15), 
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 24),
              ),
              const SizedBox(width: 15),
              Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700, 
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.red.shade300),
            ],
          ),
        ),
      ),
    );
  }
}