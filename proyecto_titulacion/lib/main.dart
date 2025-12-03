import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/trips_planner_app.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplifyconfiguration.dart'; 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint("Amplify ya estaba configurado.");
  }

  

  final session = await Amplify.Auth.fetchAuthSession();
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
