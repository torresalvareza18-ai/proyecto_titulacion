// lib/features/alerts/data/notification_repository.dart (NUEVO ARCHIVO)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/features/alerts/service/notification_api_service.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart'; 

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
 final apiService = ref.read(notificationAPIServiceProvider);
 return NotificationRepository(apiService);
});

class NotificationRepository {
  final NotificationAPIService _apiService;

  NotificationRepository(this._apiService);

  Future<List<Notifications>> fetchUserNotifications() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId; 
      return await _apiService.getNotificationsByUserId(userId);

    } catch (e) {
      safePrint('Error en NotificationRepository: $e');
      return [];
    }
  }
}