

import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/models/Post.dart';
import 'package:proyecto_titulacion/models/UserSavedPost.dart';

final bookmarkAPIServiceProvider = Provider<BookmarkAPIService>((ref) {
  final service = BookmarkAPIService();
  return service;
});

class BookmarkAPIService {
  
  BookmarkAPIService();

  Future<List<UserSavedPost>> getBookmarks(String userId) async {
    try {
      final request = GraphQLRequest<String>( 
        document: '''
          query GetBookmarks(\$userId: ID!) {
            listUserSavedPosts(filter: { userId: { eq: \$userId } }) {
              items {
                id
                userId
                postId
                createdAt
                updatedAt
                post {
                  id
                  title
                  description
                  images
                  tags
                  authorName
                  createdAt
                  updatedAt
                  authorFamily
                }
              }
            }
          }
        ''',
        variables: { "userId": userId },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
         safePrint("Errores de GraphQL: ${response.errors}");
         return [];
      }

      final Map<String, dynamic> jsonResp = jsonDecode(response.data!);
      final items = jsonResp["listUserSavedPosts"]?["items"];

      if (items == null) return [];

      return (items as List)
          .map((json) => UserSavedPost.fromJson(json))
          .toList();

    } catch (e) {
      safePrint("Error al traer bookmarks: $e");
      return [];
    }
  }

  Future<void> saveBookmark(String postId, String userId) async {
    try {

      final bookmarkSave = UserSavedPost(
        userId: userId, 
        postId: postId, 
        createdAt: TemporalDateTime.now(), 
        updatedAt: TemporalDateTime.now()
      );

      final request = ModelMutations.create(bookmarkSave);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        safePrint('Error saving bookmark: ${response.errors.first.message}');
      } else {
        safePrint('Bookmark saved successfully: ${response.data}');
      }
    
    } catch (e) {
      safePrint('Exception saving bookmark: $e');
    }
  }

  Future<void> deleteBookmark(String postId, String userId) async {
    try {
      final request = ModelQueries.list(
        UserSavedPost.classType,
        where: UserSavedPost.USERID.eq(userId).and(UserSavedPost.POSTID.eq(postId)),
      );
      
      final response = await Amplify.API.query(request: request).response;
      final itemsToDelete = response.data?.items;

      if (itemsToDelete == null || itemsToDelete.isEmpty) {
        return;
      }

      for (var item in itemsToDelete) {
        if (item != null) {
          final deleteRequest = ModelMutations.delete(item);
          Amplify.API.mutate(request: deleteRequest);
        }
      }

    } catch (e) {
      safePrint(e);
    }
  }
}