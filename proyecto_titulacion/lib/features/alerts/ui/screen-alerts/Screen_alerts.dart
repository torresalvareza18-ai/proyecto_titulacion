import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Badge(
              smallSize: 8,
              backgroundColor: Colors.red,
              child: Icon(Icons.bookmark_border, color: Colors.black87),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Badge(
              smallSize: 8,
              backgroundColor: Colors.red,
              child: Icon(Icons.notifications_none, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: const Color(0xFFE8F5E9),
            child: Text(
              'Notificaciones / Alertas:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return const _NotificationTile(
                  title: 'Cambio de salón',
                  time: 'Hace 10 min',
                  message: 'La clase de Ingeniería de Software se mueve al laboratorio 3.',
                  isUnread: true,
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
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
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