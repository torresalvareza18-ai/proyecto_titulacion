import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proyecto_titulacion/features/perfil/data/user_repository.dart';

import '../data/user_repository.dart';

part 'user_preferences_controller.g.dart';

@riverpod
class UserPreferencesController extends _$UserPreferencesController {

  
  @override
  FutureOr<List<String>> build() async {
    final userRepository = ref.read(userRepositoryProvider);
    safePrint('Preferencias del controller: $userRepository');
    return userRepository.fetchUserPreferences();
  }
  
  Future<void> updatePreference(String tagValue, bool isEnabled) async {
    print('El tag es: $tagValue');
    print('El tag esta: $isEnabled');
    if (state.hasError || state.value == null) return;
    
    List<String> currentActiveTags = List.from(state.value!);
    
    if (isEnabled && !currentActiveTags.contains(tagValue)) {
      currentActiveTags.add(tagValue);
    } else if (!isEnabled && currentActiveTags.contains(tagValue)) {
      currentActiveTags.remove(tagValue);
    }

    state = AsyncValue.data(currentActiveTags);

    try {
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.saveUserPreferences(currentActiveTags);
      
    } catch (e, stack) {
      state = AsyncValue.error('Fallo al guardar preferencias: $e', stack);
    }
  }

  Future<Map<String, dynamic>> loadUserPreferences() async {
    try {
      final user = ref.read(userRepositoryProvider);
      final userDataMap = await user.getUserPreferencesByEmail();

      print('EL user es: $userDataMap');

      return userDataMap; 
    } catch (e) {
      throw Exception("Error cargando preferencias: $e");
    }
  }
}