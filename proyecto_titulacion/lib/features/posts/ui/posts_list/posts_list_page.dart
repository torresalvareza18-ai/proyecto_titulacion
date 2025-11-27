import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/expandable_post_card.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/normal_post.dart';
import 'package:proyecto_titulacion/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsListPage extends ConsumerStatefulWidget {
  const PostsListPage({super.key});

  @override
  ConsumerState<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends ConsumerState<PostsListPage> {

  @override
  Widget build(BuildContext context) {

    final postsAsync = ref.watch(postsListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20), 
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
            child: SearchBar(
              hintText: 'Buscar Post...',
              leading: const Icon(Icons.search),

              onTap: () {
                
              },

              onChanged: (value) {
                print("Buscando: $value");
              },
            )
          ),
        ),
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err}')),
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text("No hay publicaciones aún."));
          }
          return RefreshIndicator(
            // Pa recargar la pagina xd
            onRefresh: () => ref.refresh(postsListControllerProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                // Post
                return Normal_post(post: posts[index], index: index);
              },
            ),
          );
        }
      ),
    );
  }


}