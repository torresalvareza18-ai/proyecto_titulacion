

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/features/bookmarkPost/controller/bookmark_controller.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/normal_post.dart';

class BookmarkList extends ConsumerStatefulWidget {
  const BookmarkList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarkListState();
}

class _BookmarkListState extends ConsumerState<BookmarkList> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
      _scrollController.position.maxScrollExtent * 0.9) {
    }
  }

    

  @override
  Widget build(BuildContext context) {
    final favoritosAsync = ref.watch(myBookmarksListProvider);    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Guardados"),
      ),
      body: favoritosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (savedPosts) {
          if (savedPosts.isEmpty) {
            return const Center(child: Text("Aún no has guardado nada."));
          }

          return RefreshIndicator(
            onRefresh: () async { 
              await ref.refresh(myBookmarksListProvider.future);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: savedPosts.length,
              itemBuilder: (context, index) {
                final savedItem = savedPosts[index];
                final postReal = savedItem?.post;
                safePrint(  'Post real en bookmark list: $postReal');
                safePrint(  'saveditem: $savedItem.toString()');
                safePrint(  'Post ID en bookmark list: ${savedItem?.postId}');
                if (postReal == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  
                  child: Normal_post(post: postReal, index: index),
                );
              },
            ),
          );
        },
      ),
    );
  }
}