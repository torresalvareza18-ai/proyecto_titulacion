import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyecto_titulacion/features/perfil/data/user_repository.dart';
import 'package:proyecto_titulacion/trips_planner_app.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplifyconfiguration.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart'; 


Future<void> _setupFirebaseMessaging(UserRepository userRepository) async {
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  final token = await messaging.getToken();
  if (token != null) {
    await userRepository.saveFCMToken(token!);
  }
  messaging.onTokenRefresh.listen((newToken) {
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    safePrint("Error al iniciar Firebase: $e");
  }
  await initializeDateFormatting('es_ES', null);
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint("Amplify ya estaba configurado.");
  }
  final container = ProviderContainer();
  final session = await Amplify.Auth.fetchAuthSession();
  if (session.isSignedIn) {
    final userRepository = container.read(userRepositoryProvider); 
    
    // 💡 AGREGAR UN RETRASO MAYOR (Ej. 5 segundos)
    await Future.delayed(Duration(seconds: 5)); 
    
    // Llama a la función del token
    await _setupFirebaseMessaging(userRepository); 
}
  print('Usuario logueado: ${session.isSignedIn}');
  final initialRoute = session.isSignedIn ? '/home' : '/login';

  runApp(
    ProviderScope(
      child: TripsPlannerApp(initialRoute: initialRoute),
    ),
  );
}

Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyAuthCognito(),
    AmplifyAPI(modelProvider: ModelProvider.instance),
    AmplifyStorageS3()
  ]);
  await Amplify.configure(amplifyconfig);
}