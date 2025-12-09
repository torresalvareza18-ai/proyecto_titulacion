import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path/path.dart';
import 'package:proyecto_titulacion/features/perfil/controller/user_preferences_controller.dart';
import 'package:proyecto_titulacion/features/perfil/data/user_repository.dart';
import 'package:proyecto_titulacion/features/posts/data/posts_repository.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart' hide PaginatedResult;
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart' hide PaginatedResult;

part 'posts_list_controller.g.dart';

@Riverpod(keepAlive: true)
class PostsListController extends _$PostsListController {
  String? _nextToken;
  bool _hasMore = true;
  String _tagName = '';
  List<String> _preferencesToSend = [];

  @override
  FutureOr<List<Post>> build() async {
    return [];
  }

  Future<void> loadFirstPage(String tagName) async {
    _tagName = tagName;
    _nextToken = null;
    _hasMore = true;

    state = const AsyncValue.loading();

    final loadUserPreferences = ref.read(userPreferencesControllerProvider.notifier);

    try {
      final Map<String, dynamic> userData = await loadUserPreferences.loadUserPreferences();
      final postsRepository = ref.read(postsRepositoryProvider);

      print('el user data es: $userData');

      final List<String> userPreferences = (userData['preferences'] as List).cast<String>();
      print('el user data es: $userPreferences');
      final List<String> preferencesToSend;

      if (tagName == 'todos') {
        preferencesToSend = [];
      } else if (tagName.isNotEmpty && tagName != 'todos' && tagName != 'preferencias') {
        preferencesToSend = [tagName];
      } else {
        preferencesToSend = userPreferences;
      }

      _preferencesToSend = preferencesToSend;

      final result = await postsRepository.getPostsByTagPaginated(
        
        nextToken: null, 
        preferences: preferencesToSend,
      );

      _hasMore = result.hasNextPage;
      state = AsyncValue.data(result.items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || state.isLoading) return;

    final currentState = state;
    if (!currentState.hasValue) return;

    try {
      final postsRepository = ref.read(postsRepositoryProvider);

      final result = await postsRepository.getPostsByTagPaginated(
        nextToken: _nextToken,
        preferences: _preferencesToSend,
      );

      _nextToken = result.nextToken;
      _hasMore = result.hasNextPage;

      // --- CORRECCIÓN: EVITAR DUPLICADOS ---
      final currentPosts = currentState.value!;

      // Filtramos los nuevos posts (result.items):
      // Solo dejamos pasar aquellos cuyo ID NO exista ya en currentPosts
      final uniqueNewPosts = result.items.where((newPost) {
        final alreadyExists = currentPosts.any((existingPost) => existingPost.id == newPost.id);
        return !alreadyExists;
      }).toList();

      // Guardamos la lista combinada (viejos + nuevos únicos)
      state = AsyncValue.data([
        ...currentPosts,
        ...uniqueNewPosts,
      ]);
      // -------------------------------------

    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}

@Riverpod(keepAlive: true)
class TagListController extends _$TagListController {
  
  Future<List<TagCatalog>> getAllTagCatalogs() async {
    final postsRepository = ref.read(postsRepositoryProvider);
    return postsRepository.getAllTagCatalogs();
  }

  @override
  FutureOr<List<TagCatalog>> build() async {
    return getAllTagCatalogs();
  }
  
  
}