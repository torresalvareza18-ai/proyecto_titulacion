import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart'; // <-- ¡Asegúrate que esta línea esté presente!
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

  Future<List<PostTag>> getPostTags( String tagName) async {
    try {
      final request = ModelQueries.list(
        PostTag.classType,
        where: PostTag.TAGNAME.eq(tagName),
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
        safePrint('Error ${response.errors}');
        return [];
      }

      final postTags = response.data?.items.whereType<PostTag>().toList() ?? [];
      return postTags;
  
    } on Exception catch (error) {
      safePrint('getPostTags failed: $error');

      return [];
    }
  }

  Future<PaginatedResult<Post>> getPostsByTagPaginated({
    required String tagName,
    int postsPerPage = 20,
    int currentPage = 0,
  }) async {
    try {
      final allPostTags = await getPostTags(tagName);

      final startIndex = currentPage * postsPerPage;
      final endIndex = (startIndex + postsPerPage).clamp(0, allPostTags.length);

      final postTagsForPage = allPostTags.sublist(startIndex, endIndex);

      List<Post> posts = [];
      for (var postTag in postTagsForPage) {
        if (postTag.postId != null) {
          final post = await _getPostById(postTag.postId!);
          if (post != null) {
            posts.add(post);
          }
        }
      }

      final hasNextPage = endIndex < allPostTags.length;

      return PaginatedResult<Post>(
        items: posts,
        hasNextPage: hasNextPage,
        currentPage: currentPage,
        totalItems: allPostTags.length,
      );
    } on Exception catch (error) {
      safePrint('getPostsByTagPaginated failed: $error');
      return PaginatedResult<Post>(
        items: [],
        hasNextPage: false,
        currentPage: 0,
        totalItems: 0,
      );
    }
  }

  Future<Post?> _getPostById(String postId) async {
    try {
      final request = ModelQueries.get(
        Post.classType,
        PostModelIdentifier(id: postId),
      );

      final response = await Amplify.API.query(request: request).response;
      return response.data;

    } catch (e) {
      safePrint('Error $e');
      return null;   
    }
  }

  Future<List<TagCatalog>> getAllTagCatalogs() async {
    try {
      final request = ModelQueries.list(TagCatalog.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
        safePrint('Error ${response.errors}');
        return [];
      }

      final tagCatalogs = response.data?.items.whereType<TagCatalog>().toList() ?? [];
      safePrint('TAGS DESCARGADOS: ${tagCatalogs.length}');
      return tagCatalogs;
  
    } on Exception catch (error) {
      safePrint('getAllTagCatalogs failed: $error');

      return [];
    }
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final bool hasNextPage;
  final int currentPage;
  final int totalItems;

  PaginatedResult({
    required this.items,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalItems,
  });
}