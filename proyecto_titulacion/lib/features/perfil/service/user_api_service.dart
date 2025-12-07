import 'dart:async';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Asumimos que los modelos están disponibles
// import 'package:proyecto_titulacion/models/ModelProvider.dart'; 

final userAPIServiceProvider = Provider<UserAPIService>((ref) {
  return UserAPIService();
});

class UserAPIService {
  
  // 1. Obtiene el email del usuario logeado desde Amplify Auth
  Future<String> getCurrentUserEmail() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final emailAttribute = attributes.firstWhere(
        (attr) => attr.userAttributeKey == CognitoUserAttributeKey.email,
      );
      return emailAttribute.value;
    } on Exception catch (e) {
      safePrint('Error al obtener email del usuario logeado: $e');
      rethrow;
    }
  }

  // 2. LECTURA: Busca un usuario por email y retorna sus preferencias [String]
  Future<List<String>> fetchPreferencesByEmail(String email) async {
    // Nota: Usamos una consulta GraphQL para buscar por email (asumiendo GSI o filtro)
    final query = '''
      query ListUsers {
        listUsers(filter: {email: {eq: "$email"}}) {
          items {
            id
            preferences
          }
        }
      }
    ''';
    
    try {
      final response = await Amplify.API.query(
        request: GraphQLRequest<String>(document: query),
      ).response;

      if (response.data == null) {
        safePrint("No se encontraron datos de usuario.");
        return [];
      }

      final data = jsonDecode(response.data!);
      final items = data['listUsers']['items'] as List;
      
      if (items.isEmpty) {
        safePrint("Usuario no encontrado en la base de datos.");
        return [];
      }
      safePrint('los items son: ${items}');
      final user = items.first;
      // Retorna la lista de preferencias o una lista vacía si es nulo
      safePrint('La preferencias que devuelve son: ${user}');
      return (user['preferences'] as List?)?.cast<String>() ?? [];

    } catch (e) {
      safePrint('Error al buscar preferencias: $e');
      rethrow;
    }
  }

  // 3. ESCRITURA: Actualiza la lista de preferencias.
  // Nota: Necesitamos el ID del usuario para mutar, aquí lo simulamos/obtenemos.
  Future<void> updatePreferences(String userId, List<String> newPreferences) async {
    
    final mutation = '''
      mutation UpdateUser {
        updateUser(input: {
          id: "$userId",
          preferences: ${jsonEncode(newPreferences)} 
        }) {
          id
          preferences
        }
      }
    ''';

    print('el usuario es: ${userId}');
    
    try {
      await Amplify.API.mutate(
        request: GraphQLRequest<String>(document: mutation),
      ).response;

      
    } catch (e) {
      safePrint('Error al actualizar preferencias: $e');
      rethrow;
    }
  }
}