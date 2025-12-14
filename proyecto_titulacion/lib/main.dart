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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AppLoader(),
    ),
  );
}

class AppLoader extends ConsumerStatefulWidget {
  const AppLoader({super.key});

  @override
  ConsumerState<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends ConsumerState<AppLoader> {
  late Future<String> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<void> _setupFirebaseMessaging() async {
    try {
      final messaging = FirebaseMessaging.instance;
      messaging.requestPermission();
      
      final token = await messaging.getToken();
      if (token != null) {
        final userRepository = ref.read(userRepositoryProvider);
        await userRepository.saveFCMToken(token).catchError((e) {
          debugPrint("Error guardando token: $e");
        });
      }
      
      messaging.onTokenRefresh.listen((newToken) {});
    } catch (e) {
      debugPrint("Error en configuración de mensajería: $e");
    }
  }

  Future<String> _initializeApp() async {
    await Future.wait([
      Firebase.initializeApp(),
      initializeDateFormatting('es_ES', null),
    ]);

    try {
      if (!Amplify.isConfigured) {
        await Amplify.addPlugins([
          AmplifyAuthCognito(),
          AmplifyAPI(modelProvider: ModelProvider.instance),
          AmplifyStorageS3()
        ]);
        await Amplify.configure(amplifyconfig);
      }
    } on AmplifyAlreadyConfiguredException {
      debugPrint("Amplify ya estaba configurado.");
    } catch (e) {
      return '/login'; 
    }

    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session.isSignedIn) {
        _setupFirebaseMessaging();
        return '/home';
      } else {
        return '/login';
      }
    } catch (e) {
      return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return TripsPlannerApp(initialRoute: snapshot.data!);
        }

        return const MaterialApp(
          home: Scaffold(body: Center(child: Text("Error cargando la app"))),
        );
      },
    );
  }
}