import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path/path.dart';
import 'package:proyecto_titulacion/features/posts/data/posts_repository.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_list_controller.g.dart';

@riverpod
class PostsListController extends _$PostsListController {


 Future<List<Post>> _fetchPosts() async {
   final postsRepository = ref.read(postsRepositoryProvider);
   final posts = await postsRepository.getPosts();
   return posts;
 }

 @override
 FutureOr<List<Post>> build() async {
   return _fetchPosts();
 }

 /*Future<void> removePost(Post post) async {
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() async {
     final postsRepository = ref.read(postsRepositoryProvider);
     await postsRepository.delete(post);

     return _fetchPosts();
   });
 }*/

 /*Future<void> updatePost({
  required Post originalPost,
  required String title,
  required String description,
  required List<DateTime> dates,
  required List<String> tags,
  String? newImageKey,
 }) async {
  final parsedDate = dates.map((d) => TemporalDate(d)).toList();
  final updatePost = originalPost.copyWith(
    title: title,
    description: description,
    dates: parsedDate,
    tags: tags,
    images: newImageKey != null ? [newImageKey] : originalPost.images,
    updatedAt: TemporalDateTime.now(),
  );
  state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final postsRepository = ref.read(postsRepositoryProvider);
      await postsRepository.update(updatePost); 

      return _fetchPosts(); 
    });
 }*/
}