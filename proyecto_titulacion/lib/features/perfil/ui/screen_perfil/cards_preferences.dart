import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/perfil/ui/preferences-user/list-preferences-user';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.settings_outlined,
            title: 'Preferencias de Contenido',
            subtitle: 'Personaliza tu feed',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferenciasContenidoScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.notifications_none_outlined,
            title: 'Preferencias de Notificaciones',
            subtitle: 'Personaliza tus notificaciones',
            onTap: () {
              print("Ir a notificaciones");
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orangeAccent, 
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.grey[900], 
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.green[700],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.green[900],
          size: 18,
        ),
      ),
    );
  }
}