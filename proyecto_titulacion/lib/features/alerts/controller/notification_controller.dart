// lib/features/alerts/controller/notification_controller.dart (NUEVO ARCHIVO
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proyecto_titulacion/features/alerts/data/notification_repository.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart'; 

part 'notification_controller.g.dart';

@riverpod
Future<List<Notifications>> notificationsList(Ref ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.fetchUserNotifications();
}