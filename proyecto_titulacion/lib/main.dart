import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/trips_planner_app.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'amplifyconfiguration.dart'; 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Configuración de Amplify
  try {
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyAPI(modelProvider: ModelProvider.instance),
    ]);

    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    debugPrint("Amplify ya estaba configurado.");
  }

  // 2. Comprobación de sesión
  final session = await Amplify.Auth.fetchAuthSession();
  final initialRoute = session.isSignedIn ? '/home' : '/login';

  // 3. Iniciar la app con Riverpod
  runApp(
    ProviderScope(
      child: TripsPlannerApp(initialRoute: initialRoute),
    ),
  );
}
