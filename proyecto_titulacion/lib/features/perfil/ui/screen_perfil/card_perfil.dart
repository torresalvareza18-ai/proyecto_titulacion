import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_titulacion/features/perfil/controller/user_preferences_controller.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  const ProfileCard({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    const double coverHeight = 160.0;
    const double avatarRadius = 60.0;


    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // CAPA 1: Fondo
          Column(
            children: [
              Container(
                height: coverHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/800/400'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFFF1F8E9),
                padding: const EdgeInsets.only(
                  top: avatarRadius + 10.0,
                  bottom: 24.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                  ],
                ),
              ),
            ],
          ),
          // CAPA 2: Avatar
          Positioned(
            top: coverHeight - avatarRadius,
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: const Color(0xFFF1F8E9),
              child: const CircleAvatar(
                radius: avatarRadius - 6,
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}