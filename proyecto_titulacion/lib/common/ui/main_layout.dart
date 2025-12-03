import 'package:flutter/material.dart';

import 'package:proyecto_titulacion/features/posts/ui/posts_list/posts_list_page.dart';

class MyMainLayout extends StatelessWidget {
  const MyMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationMenu());
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: <Widget>[
        const PostsListPage(tagName: 'urgente'),
        const Center(child: Text('perfil')),
        const Center(child: Text('perfil'))
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.indeterminate_check_box),
            icon: Icon(Icons.indeterminate_check_box_outlined), 
            label: 'Post',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Badge(child: Icon(Icons.notifications_outlined)), 
            label: 'Algo',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Badge(child: Icon(Icons.account_circle_outlined)), 
            label: 'Mi perfil',
          ),
        ]
      ),
      
    );
  }
}