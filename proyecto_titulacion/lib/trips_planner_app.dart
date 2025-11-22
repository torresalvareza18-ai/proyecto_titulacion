import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/common/navigation/router/router.dart';

class TripsPlannerApp extends StatelessWidget {
  final String initialRoute;

  const TripsPlannerApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // <--- AQUI EL CAMBIO
    );
  }
}
