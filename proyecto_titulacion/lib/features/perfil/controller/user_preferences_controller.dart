import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proyecto_titulacion/features/perfil/data/user_repository.dart';

part 'user_preferences_controller.g.dart';

// Este controller gestiona el estado de la lista de strings (los tag.value ACTIVOS)
@riverpod
class UserPreferencesController extends _$UserPreferencesController {
  
  @override
  // Carga inicial: llama al Repository para obtener las preferencias de la nube
  FutureOr<List<String>> build() async {
    final userRepository = ref.read(userRepositoryProvider);
    safePrint('Preferencias del controller: ${userRepository}');
    return userRepository.fetchUserPreferences();
  }
  
  // LÓGICA DE ACTUALIZACIÓN
  Future<void> updatePreference(String tagValue, bool isEnabled) async {
    print('El tag es: ${tagValue}');
    print('El tag esta: ${isEnabled}');
    if (state.hasError || state.value == null) return;
    
    // 1. Clonar y modificar la lista de tags activos (optimistic update)
    List<String> currentActiveTags = List.from(state.value!);
    
    if (isEnabled && !currentActiveTags.contains(tagValue)) {
      currentActiveTags.add(tagValue);
    } else if (!isEnabled && currentActiveTags.contains(tagValue)) {
      currentActiveTags.remove(tagValue);
    }

    // 2. Actualizar el estado localmente (UI responde)
    state = AsyncValue.data(currentActiveTags);

    try {
      // 3. Llamar al repositorio para sincronizar con la nube
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.saveUserPreferences(currentActiveTags);
      
    } catch (e, stack) {
      // 4. Si falla, manejamos el error (revertir o mostrar mensaje)
      state = AsyncValue.error('Fallo al guardar preferencias: $e', stack);
      // Opcional: Re-cargar la lista original de la nube si falla la mutación
    }
  }
}