
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/features/bookmarkPost/data/bookmark_repository.dart';
import 'package:proyecto_titulacion/models/UserSavedPost.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_controller.g.dart';

@riverpod
class BookmarkSaveController extends _$BookmarkSaveController { 

  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> saveBookmark({
    required String postId,
  }) async {
    // final bookmark = UserSavedPost(
    //   userId: userId,
    //   postId: postId,
    //   createdAt: TemporalDateTime.now(),
    //   updatedAt: TemporalDateTime.now(),
    // );
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final user = await Amplify.Auth.getCurrentUser();
      final bookmarkRepository = ref.read(bookmarkRepositoryProvider);
      await bookmarkRepository.saveBookmarks(postId, user.userId);
      ref.invalidate(myBookmarksListProvider);
    });
  }

  Future<void> removeBookmark({required String postId}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final user = await Amplify.Auth.getCurrentUser();
      final bookmarkRepository = ref.read(bookmarkRepositoryProvider);
      
      await bookmarkRepository.deleteBookmark(postId, user.userId);

      ref.invalidate(myBookmarksListProvider);
    });
  }
}

@riverpod
Future<List<UserSavedPost?>> myBookmarksList(Ref ref) async {
  final repository = ref.watch(bookmarkRepositoryProvider);
  final user = await Amplify.Auth.getCurrentUser();
  return await repository.getBookmarks(user.userId);
}