// lib/features/alerts/service/notification_api_service.dart (NUEVO ARCHIVO)

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart'; 

final notificationAPIServiceProvider = Provider<NotificationAPIService>((ref) {
  return NotificationAPIService();
});

class NotificationAPIService {
  Future<List<Notifications>> getNotificationsByUserId(String userId) async {
    print('La id es ${userId}');
    final request = ModelQueries.list(
      Notifications.classType,
      where: Notifications.USERID.eq(userId), 
    );

    try {
      final response = await Amplify.API.query(request: request).response;

      if (response.data == null) {
        safePrint("Errores de GraphQL: ${response.errors}");
        return [];
      }

      final notifications = response.data?.items.whereType<Notifications>().toList() ?? [];
      
      print('Las notificaciones son ${notifications}');

      notifications.sort((a,b) => b.createdAt.compareTo(a.createdAt));

      return notifications;
    } catch (e) {
      safePrint("Error al traer notificaciones: $e");
      return [];
    }
  }
}