import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart'; 
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide Amplify;
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
      posts.sort((a,b) => b.createdAt.compareTo(a.createdAt));
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

    print('Las preferencias son: $preferences');

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
                createdAt
                updatedAt
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

    try {
      final response = await Amplify.API.query(request: request).response;
      print('Response raw: ${response.data}');

      if (response.data == null) {
        safePrint('No se obtuvieron datos: ${response.errors}');
        return PostTagPage(items: [], nextToken: null);
      }

      final Map<String, dynamic> json = jsonDecode(response.data);
      final data = json['listPostTags'];

      print('la data transforamda es $data');

      if (data == null) return PostTagPage(items: [], nextToken: null);

      final items = (data['items'] as List)
          .map((json) => PostTag.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      print('Los items son: $items');

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
      // 1. Obtener tags
      final tagPage = await getPostTagsPaginated(
        preferences: preferences,
        nextToken: nextToken,
        limit: limit,
      );

      // 2. IDs únicos
      final Set<String> uniquePostIds = {};
      for (var tag in tagPage.items) {
        uniquePostIds.add(tag.postId!);
      }

      // 3. Descarga paralela
      final futureRequests = uniquePostIds.map((postId) => _getPostById(postId));
      final results = await Future.wait(futureRequests);
      final validPosts = results.whereType<Post>().toList();

      // --- HELPER 1: Extraer String del JSON ---
      String getFirstDateString(String? rawDates) {
        if (rawDates == null || rawDates.isEmpty) return "Próximamente";
        try {
          // Limpiamos un poco por si viene con comillas extra
          final cleanRaw = rawDates.replaceAll('"', '').replaceAll('[', '').replaceAll(']', '');
          if (cleanRaw.contains(',')) {
             return cleanRaw.split(',')[0].trim();
          }
          // Intento de decodificar JSON estándar
          final List<dynamic> parsedList = jsonDecode(rawDates);
          if (parsedList.isNotEmpty) return parsedList.first.toString();
          return "Próximamente";
        } catch (e) {
          // Si falla el JSON, devolvemos el string limpio
          return rawDates.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
        }
      }

      // --- HELPER 2: PARSER FLEXIBLE (La solución mágica) ---
      DateTime? parseFlexibleDate(String input) {
        if (input.toLowerCase().contains("próx")) return null;
        
        // 1. Intenta formato estándar ISO (2025-10-30)
        DateTime? dt = DateTime.tryParse(input);
        if (dt != null) return dt;

        // 2. Intenta formato Latino (30/10/2025 o 30-10-2025)
        try {
          // Divide por "/" o "-"
          final parts = input.split(RegExp(r'[-/]'));
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            // Reconstruye año completo si viene corto (ej 25 -> 2025)
            final fullYear = year < 100 ? 2000 + year : year;
            return DateTime(fullYear, month, day);
          }
        } catch (e) {
          return null; 
        }
        return null;
      }

      // --- ORDENAMIENTO CON DEBUG ---
      final now = DateTime.now().subtract(const Duration(days: 1)); 

      print("\n--- INICIANDO ORDENAMIENTO ---");
      
      validPosts.sort((a, b) {
        final String strA = getFirstDateString(a.dates);
        final String strB = getFirstDateString(b.dates);
        
        final DateTime? dateA = parseFlexibleDate(strA);
        final DateTime? dateB = parseFlexibleDate(strB);

        final bool isProxA = strA.toLowerCase().contains("próx");
        final bool isProxB = strB.toLowerCase().contains("próx");

        // Asignar Prioridades:
        // 1 = Futuro
        // 2 = Próximamente
        // 3 = Pasado
        // 4 = Error/Desconocido
        int getPriority(bool isProx, DateTime? date, String originalStr) {
          if (date != null) {
            if (date.isAfter(now)) return 1; // Futuro
            return 3; // Pasado
          }
          if (isProx) return 2; // "Próximamente"
          
          // DEBUG: Si cae aquí, es porque la fecha no se pudo leer
          print("⚠️ FECHA INVÁLIDA DETECTADA: '$originalStr' -> Prioridad 4");
          return 4; 
        }

        final int priorityA = getPriority(isProxA, dateA, strA);
        final int priorityB = getPriority(isProxB, dateB, strB);

        // Nivel 1: Prioridad de grupos
        if (priorityA != priorityB) {
          return priorityA.compareTo(priorityB);
        }

        // Nivel 2: Desempate dentro del grupo
        if (priorityA == 1) { // Futuros: Ascendente (Más cercano primero)
          return dateA!.compareTo(dateB!);
        } 
        else if (priorityA == 3) { // Pasados: Descendente (Más reciente primero)
          return dateB!.compareTo(dateA!);
        }

        return 0;
      });

      print("--- ORDENAMIENTO FINALIZADO ---\n");

      // Recursividad si quedó vacío
      if (validPosts.isEmpty && tagPage.nextToken != null) {
        return getPostsByTagPaginated(
          preferences: preferences,
          nextToken: tagPage.nextToken,
          limit: limit,
        );
      }

      return PaginatedResult(
        items: validPosts,
        hasNextPage: tagPage.nextToken != null,
        currentPage: 0, 
        totalItems: validPosts.length,
        nextToken: tagPage.nextToken,
      );
    } catch (e) {
      safePrint('ERROR getPostsByTagPaginated: $e');
      return PaginatedResult(
        items: [],
        hasNextPage: false,
        currentPage: 0,
        totalItems: 0,
        nextToken: null,
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
        key: 'public/${imageKey}',
        options: const StorageGetUrlOptions(
          //accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;
      return result.url.toString();
    } on StorageException catch (e) {
      safePrint('Error al obtener URL: ${e.message}');
      return ''; 
    }
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final bool hasNextPage;
  final int currentPage;
  final int totalItems;
  final String? nextToken;

  PaginatedResult({
    required this.items,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalItems,
    this.nextToken,
  });
}

class PostTagPage {
  final List<PostTag> items;
  final String? nextToken;

  PostTagPage({
    required this.items, 
    required this.nextToken});
}