import 'package:proyecto_titulacion/features/perfil/service/user_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userAPIService = ref.read(userAPIServiceProvider);
  return UserRepository(userAPIService);
});

class UserRepository {
  final UserAPIService _apiService;

  UserRepository(this._apiService);

  // LECTURA: Obtiene el email y luego busca las preferencias en la nube.
  Future<List<String>> fetchUserPreferences() async {
    final userEmail = await _apiService.getCurrentUserEmail();
    return _apiService.fetchPreferencesByEmail(userEmail);
  }
  
  // ESCRITURA: Lógica para obtener el ID de usuario (necesario para la mutación) y guardar.
  // [UserRepository.dart]

  Future<void> saveUserPreferences(List<String> newPreferences) async {
    // 1. Obtener el email del usuario logeado
    final userEmail = await _apiService.getCurrentUserEmail(); // <-- Llamada directa al APIService.Auth
    
    // 2. Buscar el ID del usuario en DynamoDB usando el email
    final userId = await _apiService.getUserIdByEmail(userEmail);
    
    // 3. Usar el ID real para realizar la mutación
    await _apiService.updatePreferences(userId, newPreferences);
}
}