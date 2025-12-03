import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/expandable_post_card.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/normal_post.dart';
import 'package:proyecto_titulacion/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsListPage extends ConsumerStatefulWidget {
  final String tagName;
  const PostsListPage({required this.tagName, super.key});
  @override
  ConsumerState<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends ConsumerState<PostsListPage> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      ref.read(postsListControllerProvider.notifier).loadFirstPage(widget.tagName);
    });

    _scrollController.addListener(_onScroll);
  }

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
    safePrint('EL newTagName es ${newTagName}');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PostsListPage(tagName: newTagName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            
            Image.asset(
              'images/tablon.png',
              height: 60,
            ),
            const SizedBox(width: 8),
            const Text(
              'TABLON-QUETZAL',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          _buildCircleActionButton(Icons.search, () {}),
          const SizedBox(width: 8),
          _buildCircleActionButton(Icons.notifications_none, () {}),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            child: tagsAsync.when(
              data: (tags) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    const tagValue = 'todos';
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: _buildCategoryChip(
                        'Todos', 
                        Icons.home, 
                        widget.tagName == 'todos',
                        () => _handleChipTapped(tagValue),
                      ),
                    );
                  }
                  final tag = tags[index - 1];
                  return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildCategoryChip(
                    tag.label, 
                    iconMap[tag.iconName] ?? Icons.category, 
                    tag.value == widget.tagName,
                    () => _handleChipTapped(tag.label),
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
        error: (err, stack) => Center(child: Text('Error: ${err}')),
        data: (posts) {
         
          return RefreshIndicator(
            onRefresh: () async { 
              await ref.read(postsListControllerProvider.notifier).loadFirstPage(widget.tagName);
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

  Widget _buildCircleActionButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFA5F2C6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87, size: 20),
        onPressed: onPressed,
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