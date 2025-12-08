import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify_core;
import 'package:proyecto_titulacion/features/perfil/service/user_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/models/User.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userAPIService = ref.read(userAPIServiceProvider);
  return UserRepository(userAPIService);
});

class UserRepository {
  final UserAPIService _apiService;

  UserRepository(this._apiService);

  Future<List<String>> fetchUserPreferences() async {
    final userEmail = await _apiService.getCurrentUserEmail();
    return _apiService.fetchPreferencesByEmail(userEmail);
  }
  

  Future<void> saveUserPreferences(List<String> newPreferences) async {
    final userEmail = await _apiService.getCurrentUserEmail(); 
    final userId = await _apiService.getUserIdByEmail(userEmail);
    
    await _apiService.updatePreferences(userId, newPreferences);
  }

  Future<Map<String, dynamic>> getUserPreferencesByEmail() async {

    final userEmail = await _apiService.getCurrentUserEmail(); 
    final userId = await _apiService.getUserIdByEmail(userEmail);
    final userData = await _apiService.getUserById(userId);

    print('la user data de repository es: $userData');

    return {
      "id": userData["id"],
      "email": userData["email"],
      "name": userData["name"],
      "preferences": userData["preferences"],   
      "fcmToken": userData["fcmToken"],
      "_version": userData["_version"]
    };
  }



// EN lib/features/perfil/data/user_repository.dart

Future<void> saveFCMToken(String token) async {
  
  final userEmail = await _apiService.getCurrentUserEmail(); 
  final userId = await _apiService.getUserIdByEmail(userEmail);

  await _apiService.saveFCMToken(token, userId);
}



  void operator [](String other) {}
}