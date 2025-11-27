import 'dart:async';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsAPIServiceProvider = Provider<PostsAPIService>((ref) {
  final service = PostsAPIService();
  return service;
});

class PostsAPIService {
  PostsAPIService();

  Future<List<Post>> getPosts() async {
    try {
      final request = ModelQueries.list(Post.classType, where: Post.TYPE.eq("Post"),);
      final response = await Amplify.API.query(request: request).response;

      final posts = response.data?.items.whereType<Post>().toList() ?? [];
      posts.sort((a,b) => b.createdAt!.compareTo(a.createdAt!));
      return posts;
  
    } on Exception catch (error) {
      safePrint('getposts failed: $error');

      return const [];
    }
  }

  /*Future<void> deletePost(Post post) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.delete(post),
            
          )
          .response;
          safePrint('Post borrado.');
    } on Exception catch (error) {
      safePrint('deletePost failed: $error');
    }
  }*/

  /*Future<void> updatePost(Post updatedPost) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.update(updatedPost),
          )
          .response;
    } on Exception catch (error) {
      safePrint('updatePost failed: $error');
    }
  }*/
}