import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path/path.dart';
import 'package:proyecto_titulacion/features/posts/data/posts_repository.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart' hide PaginatedResult;
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart' hide PaginatedResult;

part 'posts_list_controller.g.dart';

@riverpod
class PostsListController extends _$PostsListController {
  String? _nextToken;
  bool _hasMore = true;
  String _tagName = '';

  @override
  FutureOr<List<Post>> build() async {
    return [];
  }

  Future<void> loadFirstPage(String tagName) async {
    _tagName = tagName;
    _nextToken = null;
    _hasMore = true;

    state = const AsyncValue.loading();

    try {
      final postsRepository = ref.read(postsRepositoryProvider);
      final result = await postsRepository.getPostsByTagPaginated(
        tagName: tagName,
        nextToken: null,
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
        tagName: _tagName,
        nextToken: _nextToken,
      );

      _nextToken = result.nextToken;
      _hasMore = result.hasNextPage;

      state = AsyncValue.data([
        ...currentState.value!,
        ...result.items,
      ]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}

@riverpod
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