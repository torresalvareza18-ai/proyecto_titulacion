 import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/button_signOut.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/card_perfil.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/cards_preferences.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/data_cards.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileCard(), 
            SizedBox(height: 16),

            ProfileStats(),
            
            SizedBox(height: 20),

            ProfileSettings(),

            SizedBox(height: 16),

            button_signout()
          ],
        ),
      ),
    );
  }
}
