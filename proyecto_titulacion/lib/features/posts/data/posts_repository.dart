import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
 final postsAPIService = ref.read(postsAPIServiceProvider);
 return PostsRepository(postsAPIService);
});

class PostsRepository {
 PostsRepository(this.postsAPIService);

 final PostsAPIService postsAPIService;

 Future<List<Post>> getPosts() {
   return postsAPIService.getPosts();
 }

 Future<PaginatedResult<Post>> getPostsByTagPaginated({
  String? nextToken,
  required List<String> preferences
  }) {
    return postsAPIService.getPostsByTagPaginated(
      preferences: preferences, 
      nextToken: nextToken,
    );
 }

 Future<List<TagCatalog>> getAllTagCatalogs() {
  return postsAPIService.getAllTagCatalogs();
 }
}