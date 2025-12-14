import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/features/perfil/controller/user_preferences_controller.dart';
import 'package:proyecto_titulacion/features/posts/data/posts_repository.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_list_controller.g.dart';

@riverpod
class PostsListController extends _$PostsListController {
  String? _nextToken;
  bool _hasMore = true;
  List<String> _currentPreferencesUsed = [];

  bool _isFetching = false;

  @override
  FutureOr<List<Post>> build(String tagName) async {
    _isFetching = false;
    final link = ref.keepAlive();
    Timer(const Duration(hours: 1), () {
      link.close();
    });

    _nextToken = null;
    _hasMore = true;

    final loadUserPreferences = ref.read(userPreferencesControllerProvider.notifier);
    final userData = await loadUserPreferences.loadUserPreferences();
    final List<String> userPreferences = (userData['preferences'] as List).cast<String>();
    
    if (tagName == 'todos') {
      _currentPreferencesUsed = [];
    } else if (tagName.isNotEmpty && tagName != 'preferencias') {
      _currentPreferencesUsed = [tagName];
    } else {
      _currentPreferencesUsed = userPreferences;
    }

    final postsRepository = ref.read(postsRepositoryProvider);
    final result = await postsRepository.getPostsByTagPaginated(
      nextToken: null, 
      preferences: _currentPreferencesUsed,
    );

    _nextToken = result.nextToken;
    _hasMore = result.hasNextPage;

    return result.items;
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || state.isLoading) return;

    _isFetching = true;

    //state = AsyncValue<List<Post>>.data(currentPosts).copyWithPrevious(state);

    try {
      final currentPosts = state.value ?? [];
      final postsRepository = ref.read(postsRepositoryProvider);

      final result = await postsRepository.getPostsByTagPaginated(
        nextToken: _nextToken,
        preferences: _currentPreferencesUsed,
      );

      _nextToken = result.nextToken;
      _hasMore = result.hasNextPage;

      final uniqueNewPosts = result.items.where((newPost) {
        return !currentPosts.any((existingPost) => existingPost.id == newPost.id);
      }).toList();

      if (uniqueNewPosts.isNotEmpty) {
        state = AsyncValue.data([
          ...currentPosts,
          ...uniqueNewPosts
        ]);
      }

    } catch (e, stack) {
      state = AsyncValue<List<Post>>.error(e, stack).copyWithPrevious(state);
    } finally {
      _isFetching = false;
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