import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/normal_post.dart';
import 'package:proyecto_titulacion/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PostsListPage extends ConsumerStatefulWidget {
  final String initialTagName;
  const PostsListPage({this.initialTagName = 'preferencias', super.key});
  @override
  ConsumerState<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends ConsumerState<PostsListPage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  late String _currentTagName;

  
  
  @override
  void initState() {
    super.initState();

    _currentTagName = widget.initialTagName;
    
    Future.microtask(() {
      final controller = ref.read(postsListControllerProvider.notifier);
      final posts = ref.read(postsListControllerProvider);
      if (posts.value == null || posts.value!.isEmpty) {
        controller.loadFirstPage(_currentTagName);
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(postsListControllerProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleChipTapped(String newTagName) {
    if (_currentTagName == newTagName) return;
    setState(() {
      _currentTagName = newTagName;
    });
    ref.read(postsListControllerProvider.notifier).loadFirstPage(newTagName);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final postsAsync = ref.watch(postsListControllerProvider);
    final tagsAsync = ref.watch(tagListControllerProvider);
    final hasMore = ref.read(postsListControllerProvider.notifier).hasMore;

    final Map<String, IconData> iconMap = {
      'home': Icons.home,
      'work': Icons.work,
      'event': Icons.event_note,
      'groups': Icons.groups,
      'people': Icons.people,
      'school': Icons.school,
      'campaign': Icons.campaign,
      'badge': Icons.badge,
      'storefront': Icons.storefront,
      'monetization_on': Icons.monetization_on,
      'theater_comedy': Icons.theater_comedy,
    };


    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            child: tagsAsync.when(
              data: (tags) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  
                  const String todosTag = 'todos';
                  const String prefTag = 'preferencias';
                  
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0), 
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min, 
                        children: [
                          _buildCategoryChip(
                            'Todos', 
                            Icons.label, 
                            _currentTagName == todosTag, 
                            () => _handleChipTapped(todosTag), 
                          ),
                          const SizedBox(width: 8.0),
                          _buildCategoryChip(
                            'Preferencias', 
                            Icons.home, 
                            _currentTagName == prefTag, 
                            () => _handleChipTapped(prefTag), 
                          ),
                        ],
                      ),
                    ); 
                  }
                  
                  final tag = tags[index - 1];
                  final String chipValue = tag.value; 
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryChip(
                      tag.label, 
                      iconMap[tag.iconName] ?? Icons.category, 
                      _currentTagName == chipValue, 
                      () => _handleChipTapped(chipValue), 
                    ),
                  );
                },
              ), 
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (posts) {
          if (posts.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(postsListControllerProvider.notifier).loadFirstPage(_currentTagName);
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay publicaciones aún',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async { 
              await ref.read(postsListControllerProvider.notifier).loadFirstPage(_currentTagName);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: posts.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Normal_post(post: posts[index], index: index),
                );
              },
            ),
          );
        }
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );    
  }

}