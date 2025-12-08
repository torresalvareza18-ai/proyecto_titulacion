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

  bool _mostrarBusqueda = false; 
  final TextEditingController _searchController = TextEditingController(); 

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: _mostrarBusqueda 
          ? null 
          : Row(
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _mostrarBusqueda ? 220 : 0, 
            height: 40,
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _mostrarBusqueda
                ? TextField(
                    controller: _searchController,
                    autofocus: true, 
                    decoration: const InputDecoration(
                      hintText: "Buscar...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      isDense: true, 
                    ),
                    onChanged: (texto) {
                      print("Filtrando por: $texto");
                    },
                  )
                : null, 
          ),
          _buildCircleActionButton(
            _mostrarBusqueda ? Icons.close : Icons.search,
            () {
              setState(() {
                _mostrarBusqueda = !_mostrarBusqueda;
                if (!_mostrarBusqueda) {
                  _searchController.clear();
                }
              });
            },
          ),
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
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return IconThemeData(
              color: Colors.green[800], 
              size: 24,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
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