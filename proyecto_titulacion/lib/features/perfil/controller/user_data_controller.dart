// lib/features/perfil/controller/user_data_controller.dart (NUEVO ARCHIVO)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proyecto_titulacion/features/perfil/data/user_repository.dart';

part 'user_data_controller.g.dart';

// 💡 Este provider obtiene TODOS los datos del usuario (id, email, name, fcmToken, preferences)
@riverpod
Future<Map<String, dynamic>> currentUserDataProvider(Ref ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  
  // Usamos / Esta función regresa: {id, email, name, preferences, fcmToken, _version} [cite: 595]
  return userRepository.getUserPreferencesByEmail();
}