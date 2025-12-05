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
  
    } on Exception catch (error)  {
      safePrint('getposts failed: $error');

      return const [];
    }
  }

  Future<PostTagPage> getPostTagsPaginated({
    required String tagName,
    String? nextToken,
    int limit = 20,
  }) async {
    final bool showAll = tagName == "todos";

    final document = showAll
        ? '''
          query ListPostTagsAll(\$limit: Int, \$nextToken: String) {
            listPostTags(
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                id
                postId
                tagName
              }
              nextToken
            }
          }
        '''
        : '''
          query ListPostTagsFiltered(\$tagName: String!, \$limit: Int, \$nextToken: String) {
            listPostTags(
              filter: { tagName: { eq: \$tagName } },
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                id
                postId
                tagName
              }
              nextToken
            }
          }
        ''';

    final variables = showAll
        ? {
            "limit": limit,
            "nextToken": nextToken,
          }
        : {
            "tagName": tagName,
            "limit": limit,
            "nextToken": nextToken,
          };

    final request = GraphQLRequest(
      document: document,
      variables: variables,
    );

    final response = await Amplify.API.query(request: request).response;

    final Map<String, dynamic> json = jsonDecode(response.data);
    final data = json['listPostTags'];

    if (data == null) return PostTagPage(items: [], nextToken: null);

    final items = (data['items'] as List)
        .map((json) => PostTag.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    return PostTagPage(items: items, nextToken: data['nextToken']);
  }


  Future<PaginatedResult<Post>> getPostsByTagPaginated({
    required String tagName,
    required String? nextToken, 
    int limit = 20,
  }) async {
    try {
      final tagPage = await getPostTagsPaginated(
        tagName: tagName,
        nextToken: nextToken,
        limit: limit,
      );

      List<Post> posts = [];
      for (var tag in tagPage.items) {
        if (tag.postId != null) {
          final post = await _getPostById(tag.postId!);
          if (post != null) posts.add(post);
        }
      }

      return PaginatedResult(
        items: posts,
        hasNextPage: tagPage.nextToken != null,
        currentPage: 0, 
        totalItems: posts.length,
      );
    } catch (e) {
      safePrint('ERROR getPostsByTagPaginated: $e');
      return PaginatedResult(
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

  String? get nextToken => null;
}

class PostTagPage {
  final List<PostTag> items;
  final String? nextToken;

  PostTagPage({
    required this.items, 
    required this.nextToken});
}
