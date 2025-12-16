import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/normal_post.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/skeleton_post.dart';
import 'package:proyecto_titulacion/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsListPage extends ConsumerStatefulWidget {
  final String initialTagName;
  const PostsListPage({this.initialTagName = 'preferencias', super.key});
  @override
  ConsumerState<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends ConsumerState<PostsListPage> {
  late String _currentTagName;
  final List<String> _staticTags = ['todos', 'preferencias'];

  @override
  void initState() {
    super.initState();
    _currentTagName = widget.initialTagName;
  }

  void _handleChipTapped(String newTagName) {
    if (_currentTagName == newTagName) return;
    setState(() {
      _currentTagName = newTagName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagListControllerProvider);

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
              data: (tags) => ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryChip(
                      'Todos', 
                      Icons.label, 
                      _currentTagName == 'todos', 
                      () => _handleChipTapped('todos'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryChip(
                      'Preferencias', 
                      Icons.home, 
                      _currentTagName == 'preferencias', 
                      () => _handleChipTapped('preferencias'),
                    ),
                  ),
                  ...tags.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildCategoryChip(
                        tag.label,
                        iconMap[tag.iconName] ?? Icons.category,
                        _currentTagName == tag.value,
                        () => _handleChipTapped(tag.value),
                      ),
                    );
                  }),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Offstage(
            offstage: !_staticTags.contains(_currentTagName),
            child: IndexedStack(
              index: _staticTags.contains(_currentTagName) 
                  ? _staticTags.indexOf(_currentTagName) 
                  : 0,
              children: _staticTags.map((tagName) {
                return _PostsListContent(tagName: tagName);
              }).toList(),
            ),
          ),
          
          if (!_staticTags.contains(_currentTagName))
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _PostsListContent(
                key: ValueKey(_currentTagName),
                tagName: _currentTagName
              ),
            ),
        ],
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

class _PostsListContent extends ConsumerStatefulWidget {
  final String tagName;
  const _PostsListContent({super.key, required this.tagName});

  @override
  ConsumerState<_PostsListContent> createState() => _PostsListContentState();
}

class _PostsListContentState extends ConsumerState<_PostsListContent> with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  bool _onScrollNotification(ScrollNotification notification) {
    
    if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
      ref.read(postsListControllerProvider(widget.tagName).notifier).loadNextPage();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    final postsAsync = ref.watch(postsListControllerProvider(widget.tagName));
    final hasMore = ref.read(postsListControllerProvider(widget.tagName).notifier).hasMore;

    return postsAsync.when(
      skipLoadingOnRefresh: false,
      loading: () {
        return ListView.builder(
          itemCount: 4,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return const PostSkeleton();
          },
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (posts) {
        if (posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async { 
              return ref.refresh(postsListControllerProvider(widget.tagName).future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
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
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(postsListControllerProvider(widget.tagName).future);
            },
            child: ListView.builder(
              key: PageStorageKey<String>(widget.tagName),
              physics: const AlwaysScrollableScrollPhysics(),
              cacheExtent: 500,
              padding: const EdgeInsets.all(8),
              itemCount: posts.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == posts.length - 3) {
                  Future.microtask(() {
                    ref.read(postsListControllerProvider(widget.tagName).notifier).loadNextPage();
                  });
                }
                if (index == posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PostSkeleton(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Normal_post(post: posts[index], index: index),
                );
              },
            ),
          ),
        );
      },
    );
  }
}