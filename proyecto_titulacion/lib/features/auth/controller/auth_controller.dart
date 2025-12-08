// lib/features/auth/controller/auth_controller.dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart'; 

class AuthController {
  static Future<bool> signUpCognito({required String username, required String password}) async {
    try {
      final res = await Amplify.Auth.signUp(
        username: username,
        password: password,
      );
      return res.isSignUpComplete || res.nextStep.signUpStep == AuthSignUpStep.confirmSignUp;
    } on AuthException {
      rethrow;
    }
  }

  static Future<bool> signIn({required String username, required String password}) async {
    try {
      final res = await Amplify.Auth.signIn(username: username, password: password);
      return res.isSignedIn;
    } on AuthException {
      rethrow;
    }
  }
  static Future<void> createUserInDynamoDB({
    required String email, 
    required String name,
    String userType = 'Estudiante',
  }) async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      
      final newUser = User(
        id: authUser.userId,
        email: email,
        name: name,
        preferences: [userType],
        createdAt: TemporalDateTime.now(),
        updatedAt: TemporalDateTime.now(),
      );

      final request = ModelMutations.create(
        newUser, 
        authorizationMode: APIAuthorizationType.userPools
      );
      
      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        throw Exception('Error DynamoDB: ${response.errors.first.message}');
      }
    } catch (e) {
      safePrint('Error creando usuario en BD: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException {
      rethrow;
    }
  }

  static Future<bool> confirmSignUp({required String username, required String code}) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );
      return res.isSignUpComplete;
    } on AuthException {
      rethrow;
    }
  }
}
