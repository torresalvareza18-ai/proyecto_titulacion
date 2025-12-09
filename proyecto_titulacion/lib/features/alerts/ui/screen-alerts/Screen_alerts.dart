import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/features/alerts/controller/notification_controller.dart';

class AlertsScreen extends ConsumerWidget { 
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // CAMBIO: Añadir WidgetRef
    
    // Watch para el controlador de notificaciones
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: notificationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error cargando: $err')),
              data: (notifications) {
                if (notifications.isEmpty) {
                  return const Center(child: Text('No tienes notificaciones.'));
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationTile(
                        title: notification.title,
                        time: notification.createdAt.toString(), // [TODO]: Implementar lógica de tiempo
                        message: notification.body,
                        isUnread: false, // [TODO]: Usar campo isRead del modelo
                      );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  const _NotificationTile({
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUnread ? Colors.green.withOpacity(0.05) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(Icons.notifications, color: Colors.green[800], size: 20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( 
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                overflow: TextOverflow.ellipsis, // Opcional: para agregar "..." si es muy largo
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            message,
            style: const TextStyle(color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}