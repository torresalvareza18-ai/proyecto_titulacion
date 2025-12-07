import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart'; 
import 'package:proyecto_titulacion/models/ModelProvider.dart';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsAPIServiceProvider = Provider<PostsAPIService>((ref) {
  final service = PostsAPIService();
  return service;
});

class PostsAPIService {
  PostsAPIService();

  Future<List<Post>> getPosts() async {
    try {
      final request = ModelQueries.list(Post.classType);
      final response = await Amplify.API.query(request: request).response;

      final posts = response.data?.items.whereType<Post>().toList() ?? [];
      posts.sort((a,b) => b.createdAt!.compareTo(a.createdAt!));
      return posts;
  
    } on Exception catch (error) {
      safePrint('getposts failed: $error');

      return const [];
    }
  }

  Future<PostTagPage> getPostTagsPaginated({
    required List<String> preferences,
    String? nextToken,
    int limit = 20,
  }) async {
    final bool showAll = preferences.isEmpty;

    print('Las preferencias son: ${preferences}');

    String buildFilter(List<String> preferences) {
      if (preferences.isEmpty) return '';
      final orFilters =
          preferences.map((tag) => '{ tagName: { eq: "$tag" } }').join(', ');
      return 'filter: { or: [ $orFilters ] }';
    }

    final filterString = buildFilter(preferences);

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
          query ListPostTagsFiltered(\$limit: Int, \$nextToken: String) {
            listPostTags(
              $filterString,
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

    final variables = {
      "limit": limit,
      "nextToken": nextToken,
    };

    final request = GraphQLRequest(
      document: document,
      variables: variables,
    );

    print('Documento GraphQL:\n$document');
    print('Variables:\n$variables');

    try {
      final response = await Amplify.API.query(request: request).response;
      print('Response raw: ${response.data}');

      if (response.data == null) {
        safePrint('No se obtuvieron datos: ${response.errors}');
        return PostTagPage(items: [], nextToken: null);
      }

      final Map<String, dynamic> json = jsonDecode(response.data);
      final data = json['listPostTags'];

      print('la data transforamda es ${data}');

      if (data == null) return PostTagPage(items: [], nextToken: null);

      final items = (data['items'] as List)
          .map((json) => PostTag.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      print('Los items son: ${items}');

      return PostTagPage(items: items, nextToken: data['nextToken']);
    } catch (e) {
      safePrint('ERROR getPostTagsPaginated: $e');
      return PostTagPage(items: [], nextToken: null);
    }
  }

  Future<PaginatedResult<Post>> getPostsByTagPaginated({
    required List<String> preferences,
    required String? nextToken, 
    int limit = 20,
  }) async {
    try {
      final tagPage = await getPostTagsPaginated(
        preferences: preferences,
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

  Future<String> getAmplifyImageUrl(String imageKey) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: imageKey,
        options: const StorageGetUrlOptions(accessLevel: StorageAccessLevel.guest), 
      ).result;
      return result.url.toString();
    } on StorageException catch (e) {
      safePrint('Error al obtener URL de Amplify: ${e.message}');
      return ''; 
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
