import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/features/perfil/controller/user_data_controller.dart';
import 'package:proyecto_titulacion/features/perfil/controller/user_preferences_controller.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/button_signOut.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/card_perfil.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/cards_preferences.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/data_cards.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userDataAsyncValue = ref.watch(currentUserDataProviderProvider);
    final prefsAsyncValue = ref.watch(userPreferencesControllerProvider); 

    final combinedState = userDataAsyncValue.isLoading || prefsAsyncValue.isLoading;
    final combinedError = userDataAsyncValue.hasError || prefsAsyncValue.hasError;

    if (combinedState) {
        return const Scaffold(
            body: Center(child: CircularProgressIndicator())
        );
    }
    
    if (combinedError) {
        return Scaffold(
            body: Center(child: Text('Error al cargar datos: ${userDataAsyncValue.error ?? prefsAsyncValue.error}'))
        );
    }
    
    final userData = userDataAsyncValue.value!;
    final preferences = prefsAsyncValue.value!; 

    final name = userData['name'] as String? ?? 'Usuario';
    final email = userData['email'] as String? ?? 'Correo no disponible';
    final status = preferences.isNotEmpty ? preferences.first : 'Estudiante';


    return Scaffold(
      backgroundColor: Colors.white, 
      body: Column(
        children: [
          Expanded( 
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileCard(
                      name: name,
                      email: email,
                  ), 
                  const SizedBox(height: 16),
                  const ProfileSettings(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 10), 
                ],
              ),
            ),
          ),
          button_signout(), 
          const SizedBox(height: 24), 
        ],
      ),
    );
  }
}