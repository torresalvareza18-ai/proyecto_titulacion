import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:proyecto_titulacion/models/Post.dart';
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
  int currentPage = 0, 
  int postsPerPage = 20, 
  required String tagName
  }) {
    return postsAPIService.getPostsByTagPaginated(
      tagName: tagName, 
      currentPage: currentPage, 
      postsPerPage: postsPerPage
    );
 }

 Future<List<TagCatalog>> getAllTagCatalogs() {
  return postsAPIService.getAllTagCatalogs();
 }
}