


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/features/bookmarkPost/service/bookmark_api_service.dart';
import 'package:proyecto_titulacion/models/UserSavedPost.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
 final bookmarkAPIService = ref.read(bookmarkAPIServiceProvider);
 return BookmarkRepository(bookmarkAPIService);
});

class BookmarkRepository {
 BookmarkRepository(this.bookmarkAPIService);

 final BookmarkAPIService bookmarkAPIService;

 Future<List<UserSavedPost?>> getBookmarks(String userId) {
   return bookmarkAPIService.getBookmarks(userId);
 }

 Future<void> saveBookmarks(String postId, String userId) {
   return bookmarkAPIService.saveBookmark(postId, userId);
 }

 Future<void> deleteBookmark(String postId, String userId) {
  return bookmarkAPIService.deleteBookmark(postId, userId);
}
}