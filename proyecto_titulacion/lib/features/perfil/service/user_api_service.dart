import 'dart:async';
import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/models/User.dart';

final userAPIServiceProvider = Provider<UserAPIService>((ref) {
  return UserAPIService();
});

class UserAPIService {

  Future<String> getCurrentUserEmail() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final emailAttribute = attributes.firstWhere(
        (attr) => attr.userAttributeKey == CognitoUserAttributeKey.email, 
      );
      return emailAttribute.value;
    } on Exception catch (e) {
      safePrint('Error al obtener email de usuario logeado: $e');
      rethrow;
    }
  }

  Future<String> getUserIdByEmail(String email) async {
    final query = '''
      query ListUsers {
        listUsers(filter: {email: {eq: "$email"}}) {
          items {
            id
          }
        }
      }
    ''';
    
    try {
      final response = await Amplify.API.query(
        request: GraphQLRequest<String>(document: query),
      ).response;

      final data = jsonDecode(response.data!);
      final items = data['listUsers']['items'] as List;
      
      if (items.isEmpty) {
        throw Exception("ID de usuario no encontrado para el email: $email");
      }
      
      return items.first['id'] as String;

    } catch (e) {
      safePrint('Error al obtener el ID del usuario: $e');
      rethrow;
    }
  }

  Future<List<String>> fetchPreferencesByEmail(String email) async {
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
      
      final data = jsonDecode(response.data!);
      final items = data['listUsers']['items'] as List;
      
      if (items.isEmpty) return [];
      
      final user = items.first;
      return (user['preferences'] as List?)?.cast<String>() ?? [];

    } catch (e) {
      safePrint('Error al buscar preferencias: $e');
      rethrow;
    }
  }

  Future<void> updatePreferences(String userId, List<String> newPreferences) async {
    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: r'''
            mutation UpdateUser($input: UpdateUserInput!) {
              updateUser(input: $input) {
                id
                preferences
              }
            }
          ''',
          variables: {
            "input": {
              "id": userId,
              "preferences": newPreferences,
            }
          },
          authorizationMode: APIAuthorizationType.userPools, 
        ),
      ).response;
      

      final session = await Amplify.Auth.fetchAuthSession();


    } catch (e) {
      print("Error in updatePreferences: $e");
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final query = '''
      query GetUser {
        getUser(id: "$userId") {
          id
          email
          name
          preferences    
          fcmToken
          
        }
      }
    ''';

    print('User id ${userId}');

    try {
      final response = await Amplify.API.query(
        request: GraphQLRequest<String>(document: query),
      ).response;

      print('EL response es: ${response}');

      if (response.data == null) {
        throw Exception("No se encontró el usuario");
      }

      final data = jsonDecode(response.data!);

      print("data ${data['getUser']}");

      return data['getUser'];
    } catch (e) {
      safePrint("Error API getUserById: $e");
      rethrow;
    }
  }

  Future<void> updateUserRecord(User user) async {
    try {
      final request = ModelMutations.update(user);
      await Amplify.API.mutate(request: request).response;
      safePrint("User record updated successfully in DataStore/Cloud.");
    } on DataStoreException catch (e) {
      safePrint("Error updating user record: $e");
    }
  }

  Future<void> saveFCMToken(String token, String userId) async {
    try {
      
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: r'''
            mutation UpdateUser($input: UpdateUserInput!) {
              updateUser(input: $input) {
                id
                fcmToken
              }
            }
          ''',
          variables: {
            "input": {
              "id": userId,
              "fcmToken": token, 
            }
          },
          authorizationMode: APIAuthorizationType.userPools, 
        ),
      ).response;

      print('El response es ${response}');

      final session = await Amplify.Auth.fetchAuthSession();
      print('El session es ${session}');

    } catch (e) {
      safePrint("Error en saveFCMToken: $e");
    }
  }
}
