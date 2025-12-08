import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/alerts/ui/screen-alerts/Screen_alerts.dart';
import 'package:proyecto_titulacion/features/bookmarkPost/ui/bookmark_list.dart';

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
              'TABLON-',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Text(
              'QUETZAL',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
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
        const PostsListPage(),
        const BookmarkList(),
        const AlertsScreen(),
        const ProfileScreen(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(

        data: NavigationBarThemeData( 
          indicatorColor: Colors.transparent,
          iconTheme: MaterialStateProperty.resolveWith((states) {
            return IconThemeData(
              color: Colors.green[800], 
              size: 24,
            );
          }),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold);
            }
            return TextStyle(color: Colors.green[800]);
          }),
        ),
        
        child: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.orangeAccent,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined), 
              label: 'Home',
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
      )
    );
  }


  Widget _buildCircleActionButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87, size: 20),
        onPressed: onPressed,
      ),
    );
  }

}