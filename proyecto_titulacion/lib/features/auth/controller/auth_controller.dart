// lib/features/auth/controller/auth_controller.dart
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthController {
  /// Sign in with Amplify Auth
  static Future<bool> signIn({required String username, required String password}) async {
    try {
      final res = await Amplify.Auth.signIn(username: username, password: password);
      return res.isSignedIn;
    } on AuthException {
      rethrow;
    }
  }

  /// Sign up with Amplify Auth. attributes can include custom attributes.
  static Future<bool> signUp({required String username, required String password, Map<String, String>? attributes}) async {
    try {
            // 1. Convertimos las claves de String a CognitoUserAttributeKey
      final userAttributes = attributes?.map((key, value) {
        return MapEntry(CognitoUserAttributeKey.parse(key), value);
      }) ?? const {};

      // 2. Usamos el mapa ya convertido
      final options = SignUpOptions(userAttributes: userAttributes);

      final res = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: options,
      );
      return res.isSignUpComplete;
    } on AuthException {
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
}
