import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/trips_planner_app.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'amplifyconfiguration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AppLoader(),
    ),
  );
}

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late Future<String> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _configureAndCheckAuth();
  }

  Future<String> _configureAndCheckAuth() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyAPI(modelProvider: ModelProvider.instance),
        AmplifyStorageS3()
      ]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      debugPrint("Amplify ya estaba configurado.");
    } catch (e) {
      debugPrint("Error configurando Amplify: $e");
    }

    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn ? '/home' : '/login';
    } catch (e) {
      debugPrint("Error verificando sesión: $e");
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