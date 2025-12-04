import 'package:flutter/material.dart';

import 'package:proyecto_titulacion/features/posts/ui/posts_list/posts_list_page.dart';
import 'package:proyecto_titulacion/features/perfil/ui/screen_perfil/screen_perfil.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      ),
      body: <Widget>[
        const PostsListPage(tagName: 'todos'),
        const Center(child: Text('perfil')),
        const Center(child: Text('perfil')),
        const ProfileScreen(),
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
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined), 
            label: 'Post',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border), 
            label: 'Guardados',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_none), 
            label: 'Alertas',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline), 
            label: 'Perfil',
          ),
         
        ]
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

}